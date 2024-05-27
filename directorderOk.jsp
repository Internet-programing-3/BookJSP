<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.text.*" %>
<html>
<head>
    <title>�ֹ� ó�� �Ϸ�</title>
    <style type="text/css">
        a:link { text-decoration: none; color: black; } <!-- Ŭ���ϱ����� ������ ������ ������ -->
        a:visited { text-decoration: none; color: black; } <!-- �湮�ѵ��� ������ ���پ��� ���� -->
        a:hover { text-decoration: underline; color: gray; } <!-- ���콺�� �ö󰥶� ������ �Ʒ����ְ� �Ķ� -->
    </style>
</head>
<body>
<%
try {
    String DB_URL = "jdbc:mysql://localhost:3306/project";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

	Class.forName("com.mysql.cj.jdbc.Driver"); 
    Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);
    request.setCharacterEncoding("euc-kr");
    String cartId = session.getId();
    String userId = (String) session.getAttribute("sid");

    // �ֹ��� ������ ���� ���� �ʿ���
    String orderName = request.getParameter("name");
    String orderTel = request.getParameter("memTel");
    String orderReceiver = request.getParameter("receiver");
    String orderRcvAddress = request.getParameter("rcvAddress");
    String orderRcvPhone = request.getParameter("rcvPhone");
    String orderCardNo = request.getParameter("cardNo");
    String orderCardPass = request.getParameter("cardPass");
    String orderBank = request.getParameter("bank");
    String orderPay = request.getParameter("pay");

    // ���ο� �ֹ���ȣ�� �ο��ϱ� ���� �ֹ����̺� �ִ� ������ �ֹ���ȣ�� ������
    String jsql = "SELECT MAX(orderId) FROM CartOrder";
    PreparedStatement pstmt = con.prepareStatement(jsql);
    ResultSet rs = pstmt.executeQuery();

    int orderId;
    if (rs.next()) {
        orderId = rs.getInt(1) + 1;
    } else {
        orderId = 1;
    }

    String jsql2 = "SELECT bookId, quantity FROM CartItem WHERE cartId = ?";
    PreparedStatement pstmt2 = con.prepareStatement(jsql2);
    pstmt2.setString(1, cartId);
    ResultSet rs2 = pstmt2.executeQuery();

    while (rs2.next()) {
        int bookId = rs2.getInt("bookId");
        int quantity = rs2.getInt("quantity");
        String jsql3 = "INSERT INTO OrderItem (orderId, bookId, quantity) VALUES (?,?,?)";
        PreparedStatement pstmt3 = con.prepareStatement(jsql3);
        pstmt3.setInt(1, orderId);
        pstmt3.setInt(2, bookId);
        pstmt3.setInt(3, quantity);
        pstmt3.executeUpdate();
    }

    String jsql4 = "INSERT INTO CartOrder (orderId, orderState, cartId) VALUES(?,?,?)";
    java.util.Date date = new java.util.Date();
    String orderDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    PreparedStatement pstmt4 = con.prepareStatement(jsql4);
    pstmt4.setInt(1, orderId);
    pstmt4.setString(2, "�ֹ� �Ϸ�");
    pstmt4.setString(3, cartId);
    pstmt4.executeUpdate();

    String jsql5 = "INSERT INTO Payment (paymentId, paymentKind, totalPay, orderId, userId) VALUES(?,?,?,?,?)";
    PreparedStatement pstmt5 = con.prepareStatement(jsql5);
    pstmt5.setInt(1, orderId);
    pstmt5.setString(2, "ī�� ����"); // �Ǵ� �ٸ� ���� ���ܿ� �°� ����
    pstmt5.setString(3, orderPay);
    pstmt5.setInt(4, orderId);
    pstmt5.setString(5, userId);
    pstmt5.executeUpdate();

    response.sendRedirect("deleteTempCart.jsp");
} catch (Exception e) {
    out.println(e);
}
%>
</body>
</html>
