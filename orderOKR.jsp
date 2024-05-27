<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.text.*" %>
<html>
<head>
    <title>�ֹ� ó�� �Ϸ�</title>
    <style type="text/css">
        a:link { text-decoration: none; color: black; }
        a:visited { text-decoration: none; color: black; }
        a:hover { text-decoration: underline; color: gray; }
    </style>
</head>
<%
try{
    String DB_URL = "jdbc:mysql://localhost:3306/project";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);
    request.setCharacterEncoding("euc-kr");
    String cartId = session.getId(); // ���ǹ�ȣ ��ٱ��Ϲ�ȣ ����
    String userId = (String)session.getAttribute("sid"); // ���� ���� �����ͼ� ������ ���� (�ֹ��������� ���� ���� �ʿ���)

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
    String maxOrderNoQuery = "SELECT MAX(orderId) FROM CartOrder"; 
    PreparedStatement maxOrderNoStmt = con.prepareStatement(maxOrderNoQuery);
    ResultSet maxOrderNoRs = maxOrderNoStmt.executeQuery(); 
    int orderId;
    if(maxOrderNoRs.next())
        orderId = maxOrderNoRs.getInt(1) + 1;
    else 
        orderId = 1;

    // ��ٱ��� ���̺� �ִ� �������� �о�ͼ� �ֹ���ǰ ���̺� �ֹ���ȣ, ��ǰ��ȣ, �ֹ������� ����
    String cartItemsQuery = "SELECT bookId, quantity FROM CartItem WHERE cartId = ?";
    PreparedStatement cartItemsStmt = con.prepareStatement(cartItemsQuery);
    cartItemsStmt.setString(1, cartId);
    ResultSet cartItemsRs = cartItemsStmt.executeQuery(); 

    while(cartItemsRs.next()) {
        int bookId = cartItemsRs.getInt("bookId");
        int quantity = cartItemsRs.getInt("quantity");

        // �ֹ���ǰ���̺� �ֹ���ȣ, ��ǰ��ȣ, �ֹ����� ����
        String insertOrderItemQuery = "INSERT INTO OrderItem (orderId, bookId, quantity) VALUES (?,?,?)";
        PreparedStatement insertOrderItemStmt = con.prepareStatement(insertOrderItemQuery);
        insertOrderItemStmt.setInt(1, orderId);
        insertOrderItemStmt.setInt(2, bookId);
        insertOrderItemStmt.setInt(3, quantity);
        insertOrderItemStmt.executeUpdate();
    }

    // �ֹ����� ���̺� �����ų �ʵ���� ����
    String insertOrderInfoQuery = "INSERT INTO CartOrder (orderId, orderState, cartId) VALUES(?,?,?)";
    
    // �ֹ����� ���� ��¥�� ���̺� ����
    java.util.Date date = new java.util.Date();
    String orderDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    
    PreparedStatement insertOrderInfoStmt = con.prepareStatement(insertOrderInfoQuery);
    insertOrderInfoStmt.setInt(1, orderId);
    insertOrderInfoStmt.setString(2, "�ֹ� �Ϸ�");
    insertOrderInfoStmt.setString(3, cartId);
    insertOrderInfoStmt.executeUpdate();

    String insertPaymentQuery = "INSERT INTO Payment (paymentId, paymentKind, totalPay, orderId, userId) VALUES(?,?,?,?,?)";
    PreparedStatement insertPaymentStmt = con.prepareStatement(insertPaymentQuery);
    insertPaymentStmt.setInt(1, orderId);
    insertPaymentStmt.setString(2, "ī�� ����"); // �Ǵ� �ٸ� ���� ���ܿ� �°� ����
    insertPaymentStmt.setString(3, orderPay);
    insertPaymentStmt.setInt(4, orderId);
    insertPaymentStmt.setString(5, userId);
    insertPaymentStmt.executeUpdate();

    // �ֹ������� ���õ� ��ü�� �������� ���� ���̺�� ���̺� �����Ų �� ��ٱ��� ���⸦ ������
    // i) �ֹ� �Ŀ� ��ٱ��ϸ� ���� �Ͱ� ii) �ֹ����� ��ٱ��ϸ� ���� ���� ���� �����ϱ� ���� case �Ķ���͸� ���
    // case=1: �ֹ�ó�� �Ϸ� �Ŀ� ��ٱ��ϸ� ���� ���
    // �� ���� ���� �ֹ����� ��ٱ��� ����
    response.sendRedirect("deleteAllCart.jsp?case=1"); 
} catch(Exception e) {
    out.println(e);
} 
%>

</body>
</html>
