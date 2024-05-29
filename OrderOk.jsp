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

    String userId = (String)session.getAttribute("userId");
    // 주문정보 테이블에 저장
    String ordReceiver = request.getParameter("ordReceiver");
    String ordRcvAddress = request.getParameter("ordRcvAddress");
    String ordRcvPhone = request.getParameter("ordRcvPhone");
    String ordPay = request.getParameter("ordPay"); // 수정된 부분: "pay" -> "ordPay"

    // 새로운 주문번호 부여
    String jsql = "SELECT MAX(ordNo) FROM orderInfo"; 
    PreparedStatement pstmt = con.prepareStatement(jsql);
    ResultSet rs = pstmt.executeQuery(); 

    int oNum;

    if (rs.next()) {
        oNum = rs.getInt(1) + 1;
    } else {
        oNum = 1;
    }

    rs.close();
    pstmt.close();

    // 현재 날짜 가져오기
    java.util.Date date = new java.util.Date();
    String oDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date); 

    // orderInfo 테이블에 데이터 삽입
    String jsql4 = "INSERT INTO orderInfo (ordNo, userId, ordDate, ordReceiver, ordRcvAddress, ordRcvPhone, ordPay) VALUES(?,?,?,?,?,?,?)";            
    PreparedStatement pstmt4 = con.prepareStatement(jsql4);
    pstmt4.setInt(1, oNum);
    pstmt4.setString(2, userId);
    pstmt4.setString(3, oDate);
    pstmt4.setString(4, ordReceiver);
    pstmt4.setString(5, ordRcvAddress);
    pstmt4.setString(6, ordRcvPhone);
    pstmt4.setString(7, ordPay);

    pstmt4.executeUpdate();
    pstmt4.close();

    // 장바구니에서 주문 상품 가져오기
    String jsql2 = "SELECT bookId, ctQty FROM cart WHERE userId = ?";
    PreparedStatement pstmt2 = con.prepareStatement(jsql2);
    pstmt2.setString(1, userId);
    ResultSet rs2 = pstmt2.executeQuery();

    // 주문상품 테이블에 데이터 삽입
    while (rs2.next()) {
        String bookId = rs2.getString("bookId");
        int ctQty = rs2.getInt("ctQty");

        String jsql3 = "INSERT INTO orderProduct (ordNo, bookId, ordQty) VALUES (?,?,?)";
        PreparedStatement pstmt3 = con.prepareStatement(jsql3);
        pstmt3.setInt(1, oNum);
        pstmt3.setString(2, bookId);
        pstmt3.setInt(3, ctQty);
        pstmt3.executeUpdate();
        pstmt3.close();
    }

    rs2.close();
    pstmt2.close();

    // 주문 처리 후 장바구니 비우기
    response.sendRedirect("DeleteAllCart.jsp?ordNo=" + oNum);

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
