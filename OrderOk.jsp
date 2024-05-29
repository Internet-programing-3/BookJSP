<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.*, java.util.*, java.net.*" %>
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

    // ctNos 값 디코딩
    String[] ctNosEncoded = request.getParameterValues("ctNos"); // 인코딩된 값 받기
    String[] ctNos = new String[ctNosEncoded.length]; // 디코딩된 값 저장할 배열 생성
    for (int i = 0; i < ctNosEncoded.length; i++) {
        ctNos[i] = URLDecoder.decode(ctNosEncoded[i], "UTF-8");
    }

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

    // 주문상품 테이블에 데이터 삽입
    for (String ctNo : ctNos) { // 수정된 부분
    // 쉼표로 구분된 문자열을 분할하여 각 숫자를 추출
    String[] numbers = ctNo.split(",\\s*");
		for (String number : numbers) { // 수정된 부분
		    // ctNo를 정수로 파싱하여 사용
		    int cartId = Integer.parseInt(number.replaceAll("\\[|\\]", ""));
		    
		    // cart 테이블에서 해당 ctNo에 해당하는 데이터 조회
		    String jsql5 = "SELECT bookId, ctQty FROM cart WHERE ctNo = ?";
		    PreparedStatement pstmt5 = con.prepareStatement(jsql5);
		    pstmt5.setInt(1, cartId);
		    ResultSet rs5 = pstmt5.executeQuery();
		
		    // 조회된 데이터를 사용하여 주문상품 테이블에 삽입
		    if (rs5.next()) {
		        int bookId = rs5.getInt("bookId");
		        int ctQty = rs5.getInt("ctQty");
		
		        String jsql6 = "INSERT INTO orderProduct (ordNo, bookId, ordQty) VALUES (?, ?, ?)";
		        PreparedStatement pstmt6 = con.prepareStatement(jsql6);
		        pstmt6.setInt(1, oNum);
		        pstmt6.setInt(2, bookId);
		        pstmt6.setInt(3, ctQty);
		        pstmt6.executeUpdate();
		        pstmt6.close();
		    }
		    
		    // 리소스 닫기
		    rs5.close();
		    pstmt5.close();
		}
    }


 	// 주문 처리 후 장바구니 비우기
    // ctNos 배열을 URL 파라미터로 변환
		StringBuilder urlBuilder = new StringBuilder("DeleteAllCart.jsp?ordNo=" + oNum);
		for (String ctNo : ctNosEncoded) {
		    String[] values = ctNo.split(","); // 쉼표로 각 요소 분할
		    for (String value : values) {
		        String trimmedValue = value.replaceAll("\\[|\\]", ""); // 대괄호 제거
		        urlBuilder.append("&ctNos=").append(URLEncoder.encode(trimmedValue, "UTF-8"));
		    }
		}

    // 최종 URL로 리디렉션
    response.sendRedirect(urlBuilder.toString());


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
