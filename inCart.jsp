<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>장바구니 담기</title>
    <style type="text/css">
        a:link { text-decoration: none; color: black; }
        a:visited { text-decoration: none; color: black; }
        a:hover { text-decoration: underline; color:blue; }
    </style>
</head>
<body>
<%
    String userId = (String)session.getAttribute("userId"); 
    if (userId == null) {
%>
    <center>
        <br><br><br>
        <font style="font-size:10pt;font-family: '맑은 고딕'">
            상품 주문을 위해서는 로그인이 필요합니다 ! <br><br> 
            <a href="Login.jsp" ><img src="images/logIn.png" border=0></a>
        </font>
    </center>
<%
    }
    else 
    {
        try
        {
            String DB_URL="jdbc:mysql://localhost:3306/internetproject";
            String DB_ID="multi"; 
            String DB_PASSWORD="abcd";

            Class.forName("com.mysql.cj.jdbc.Driver"); 
            Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD); 
            
            String bookId = request.getParameter("bookId"); // 상품번호
            int ctQty = Integer.parseInt(request.getParameter("ctQty")); // 주문수량 장바구니에 담을 수량

            // 기존에 장바구니에 있는 상품인지 확인
            String checkExistingQuery = "SELECT * FROM cart WHERE userId = ? AND bookId = ?";
            PreparedStatement checkExistingStmt = con.prepareStatement(checkExistingQuery);
            checkExistingStmt.setString(1, userId);
            checkExistingStmt.setString(2, bookId);
            ResultSet existingRs = checkExistingStmt.executeQuery();

            if (existingRs.next()) {
                // 이미 장바구니에 있는 상품이면 수량을 업데이트
                int existingQty = existingRs.getInt("ctQty");
                int updatedQty = existingQty + ctQty;

                String updateQuery = "UPDATE cart SET ctQty = ? WHERE userId = ? AND bookId = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateQuery);
                updateStmt.setInt(1, updatedQty);
                updateStmt.setString(2, userId);
                updateStmt.setString(3, bookId);
                updateStmt.executeUpdate();
            } else {
                // 장바구니에 없는 상품이면 새로운 레코드 추가
                String getMaxCtNoQuery = "SELECT MAX(ctNo) AS maxCtNo FROM cart";
                PreparedStatement getMaxCtNoStmt = con.prepareStatement(getMaxCtNoQuery);
                ResultSet maxCtNoRs = getMaxCtNoStmt.executeQuery(); 
                int newCtNo = 1; // 기본값은 1
                if(maxCtNoRs.next()) {
                    newCtNo = maxCtNoRs.getInt("maxCtNo") + 1; // 최대 ctNo에 1을 더하여 새로운 ctNo 생성
                }

                // 새로운 레코드를 추가할 때 ctNo도 함께 추가
                String insertQuery = "INSERT INTO cart (ctNo, userId, bookId, ctQty) VALUES (?, ?, ?, ?)";
                PreparedStatement insertStmt = con.prepareStatement(insertQuery);
                insertStmt.setInt(1, newCtNo);
                insertStmt.setString(2, userId);
                insertStmt.setString(3, bookId);
                insertStmt.setInt(4, ctQty);
                insertStmt.executeUpdate();
            }

            con.close();
            // 장바구니 내역을 보여주는 페이지로 이동
            response.sendRedirect("showCart.jsp");
            
        } catch(Exception e) {
            // 오류 발생 시 콘솔에 오류 메시지 출력
            e.printStackTrace();
            // 필요에 따라 사용자에게 오류 메시지 전달
            // response.sendRedirect("error.jsp");
        }
    }
%>
</body>
</html>
