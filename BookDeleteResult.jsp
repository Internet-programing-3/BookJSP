<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>���� ���� ���</title>
</head>
<body>
<%
try {
    String DB_URL = "jdbc:mysql://localhost:3306/internetproject"; // DB ������ ��
    String DB_ID = "multi"; // ������ ���̵�
    String DB_PASSWORD = "abcd"; // ������ �н�����

    Class.forName("com.mysql.cj.jdbc.Driver"); // JDBC ����̹� �ε�
    Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

    String key = request.getParameter("bookId");
    String jsql = "DELETE FROM Book WHERE bookId=?";
    PreparedStatement pstmt = con.prepareStatement(jsql);
    pstmt.setString(1, key);
    pstmt.executeUpdate();
%>
    <jsp:forward page="BookSelect.jsp"/>
<%
} catch (Exception e) {
    out.println(e);
}
%>
</body>
</html>
