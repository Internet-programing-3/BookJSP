<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.*, java.util.*" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 완료</title>
    <link rel="stylesheet" type="text/css" href="Main.css?v=1">
    <script src="https://code.jquery.com/jquery-3.6.3.js"></script>
</head>
<body>
    <%
    Connection con = null; // 변수를 try 블록 밖에서 미리 선언

    try {
        request.setCharacterEncoding("UTF-8");
        String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";
        Class.forName("com.mysql.cj.jdbc.Driver"); 
        con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        String ctNo = session.getId(); // 세션번호 장바구니번호를 가져옴
        String userId = (String)session.getAttribute("userId");
        // 주문정보 테이블에 저장
        String oName = request.getParameter("name");
		String ordReceiver = request.getParameter("ordReceiver");
		String ordRcvAddress = request.getParameter("ordRcvAddress");
		String ordRcvPhone = request.getParameter("ordRcvPhone");
		String oPay = request.getParameter("ordPay"); // 수정된 부분: "pay" -> "bank"


        // 새로운 주문번호 부여
        String jsql = "select MAX(ordNo) from orderInfo"; 
        PreparedStatement pstmt = con.prepareStatement(jsql);
        ResultSet rs = pstmt.executeQuery(); 

        int oNum;

			if (rs.next()) 
				oNum = rs.getInt(1) + 1;
			 else 
				oNum = 1;
			
		// 최대값인 경우 처리
        
        String jsql2 = "select bookId, ctQty from cart where ctNo = ?";
        PreparedStatement pstmt2 = con.prepareStatement(jsql2);
        pstmt2.setString(1, ctNo);
        ResultSet rs2 = pstmt2.executeQuery();

        // 주문상품테이블에 주문번호, 상품번호, 주문수량 저장
        while (rs2.next()) {
            String bookId = rs2.getString("bookId");
            int ctQty = rs2.getInt("ctQty");

            String jsql3 = "INSERT INTO orderProduct (ordNo, bookId, ordQty) VALUES (?,?,?)";
            PreparedStatement pstmt3 = con.prepareStatement(jsql3);
            pstmt3.setString(1, Integer.toString(oNum));
            pstmt3.setString(2, bookId);
            pstmt3.setInt(3, ctQty);
            pstmt3.executeUpdate();
        }

        String jsql4 = "INSERT INTO orderInfo (ordNo, userId, ordDate, ordReceiver, ordRcvAddress, ordRcvPhone, ordPay) VALUES(?,?,?,?,?,?,?)";            
        java.util.Date date = new java.util.Date();
        String oDate = date.toLocaleString(); 

        PreparedStatement pstmt4 = con.prepareStatement(jsql4);
        pstmt4.setString(1, Integer.toString(oNum));
        pstmt4.setString(2, userId);
        pstmt4.setString(3, oDate);
        pstmt4.setString(4, ordReceiver);
        pstmt4.setString(5, ordRcvAddress);
        pstmt4.setString(6, ordRcvPhone);
        pstmt4.setString(7, oPay);

        pstmt4.executeUpdate();

        // 주문 처리 후 장바구니 비우기
        response.sendRedirect("DeleteAllCart.jsp?case=1");

    } catch(Exception e) {
        out.println(e);
    } finally {
        try {
            if (con != null) {
                con.close();
            }
        } catch (SQLException e) {
            out.println(e);
        }
    }
    %>
</body>
</html>
