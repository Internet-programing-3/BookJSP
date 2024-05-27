<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>���� ���� ������</title>
</head>
<body>
<center>
<%
try {
    String DB_URL = "jdbc:mysql://localhost:3306/internetproject"; // DB ������ ��
    String DB_ID = "multi"; // ������ ���̵�
    String DB_PASSWORD = "abcd"; // ������ �н�����

	Class.forName("com.mysql.cj.jdbc.Driver"); 
    Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);
    String key = request.getParameter("bookId");
    String jsql = "SELECT * FROM BOOK WHERE bookId = ?";
    PreparedStatement pstmt = con.prepareStatement(jsql);
    pstmt.setString(1, key);
    ResultSet rs = pstmt.executeQuery(); // SQL �� ����
    rs.next();
    String bookId = rs.getString("bookId");
    String bookName = rs.getString("bookName");
    int price = rs.getInt("price");
    int bookStock = rs.getInt("bookStock");
    String writer = rs.getString("writer");
    String bookContent = rs.getString("bookContent");
    String publisher = rs.getString("publisher");
    String bookStatus = rs.getString("bookStatus");
    String bookCtg = rs.getString("bookCtg");
%>
    <font color="blue" size='6'><b>[��ϵ� ���� ����]</b></font><p>

    <h4>������ ���� ��ϵ� ������ �����Ͻðڽ��ϱ�?</h4>

    <table border="2" cellpadding="10" style="font-size:10pt;font-family:'���� ���'">
        <tr>
            <td>ī�װ��з�</td>
            <td><%=bookCtg%></td>
            <td rowspan="7"><img src="images/<%=bookId%>.jpg" width="300" height="300"></td>
        </tr>
        <tr><td>���� ��ȣ</td><td><%=bookId%></td></tr>

        <tr><td>���� ��</td><td><%=bookName%></td></tr>

        <tr><td>���� ����</td><td><%=price%> ��</td></tr>

        <tr><td>������</td><td><%=bookStock%> ��</td></tr>

        <tr><td>����</td><td><%=writer%></td></tr>

        <tr><td>�󼼼���</td><td width="300"><%=bookContent%></td></tr>

        <tr><td>���ǻ�</td><td><%=publisher%></td></tr>

        <tr><td>�Ǹ� ����</td><td><%=bookStatus%></td></tr>

    </table><p>
    <a href="BookDeleteResult.jsp?bookId=<%=bookId%>" style="font-size:10pt;font-family:'���� ���'">����</a>&nbsp;&nbsp;&nbsp;
    <a href="BookSelect.jsp" style="font-size:10pt;font-family:'���� ���'">���</a>
<%
} catch (Exception e) {
    out.println(e);
}
%>
</center>
</body>
</html>
