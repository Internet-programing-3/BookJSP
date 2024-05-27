<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>���� ������ ��ȸ</title>
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
    String bookReview = rs.getString("bookReview");
%>
    <font color="blue" size='6'><b>[���� ������ ��ȸ]</b></font><p>
    <table border="1" style="font-size:10pt;font-family:'���� ���'">
        <tr>
            <td align=center>ī�װ��з�</td><td align=center><%=bookCtg%></td>
            <td rowspan="7" align=center><img src="images/<%=bookId%>.jpg" width="300" height="300"></td>
        </tr>

        <tr><td align=center>������ȣ</td><td align=center><%=bookId%></td></tr>
        <tr><td align=center>������</td><td align=center><%=bookName%></td></tr>
        <tr><td align=center>��������</td><td align=center><%=price%> ��</td></tr>
        <tr><td align=center>������</td><td align=center><%=bookStock%> ��</td></tr>
        <tr><td align=center>����</td><td align=center><%=writer%></td></tr>
        <tr><td align=center>��ǰ����</td><td align=center width=300><%=bookContent%></td></tr>
        <tr><td align=center>���ǻ�</td><td align=center><%=publisher%></td></tr>
        <tr><td align=center>���� ����</td><td align=center><%=bookStatus%></td></tr>
        <tr><td align=center>å ����</td><td align=center><%=bookReview%></td></tr>
    </table><p>
    <br><br>
    <img src="./images/<%=bookId%>_detail.jpg" width=700 height=700 border=0>
    <br><br><br>
    <a href="BookUpdate.jsp?bookId=<%=bookId%>" align=center style="font-size:10pt;font-family:'���� ���'">����</a>&nbsp;&nbsp;&nbsp;
    <a href="BookDelete.jsp?bookId=<%=bookId%>" align=center style="font-size:10pt;font-family:'���� ���'">����</a>
    <br><br><br>
</center>
<%
} catch (Exception e) {
    out.println(e);
}
%>
</body>
</html>
