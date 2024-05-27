<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>���� ���� ���</title>
</head>
<body>
<center>
<%
    request.setCharacterEncoding("euc-kr");

    String bookCtg = request.getParameter("bookCtg");
    String bookId = request.getParameter("bookId");
    String bookName = request.getParameter("bookName");
    int price = Integer.parseInt(request.getParameter("price"));
    int bookStock = Integer.parseInt(request.getParameter("bookStock"));
    String writer = request.getParameter("writer");
    String bookContent = request.getParameter("bookContent");
    String publisher = request.getParameter("publisher");
    String bookStatus = request.getParameter("bookStatus");

    try {
        String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

		Class.forName("com.mysql.cj.jdbc.Driver"); 
        Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        String jsql = "UPDATE BOOK SET bookName=?, price=?, bookStock=?, ";
        jsql += "writer=?, bookContent=?, publisher=?, bookStatus=?, bookCtg=? WHERE bookId=?";
        PreparedStatement pstmt = con.prepareStatement(jsql);
        pstmt.setString(1, bookName);
        pstmt.setInt(2, price);
        pstmt.setInt(3, bookStock);
        pstmt.setString(4, writer);
        pstmt.setString(5, bookContent);
        pstmt.setString(6, publisher);
        pstmt.setString(7, bookStatus);
        pstmt.setString(8, bookCtg);
        pstmt.setString(9, bookId);
        pstmt.executeUpdate();

        String jsql2 = "SELECT * FROM BOOK WHERE bookId=?";
        PreparedStatement pstmt2 = con.prepareStatement(jsql2);
        pstmt2.setString(1, bookId);
        ResultSet rs = pstmt2.executeQuery();
        rs.next();
%>
        <font color="blue" size='6'><b>������ ��ǰ������ ������ �����ϴ�.</b></font><p>
        <table border="2" cellpadding="10" style="font-size:10pt;font-family:'���� ���'">

            <tr><td>ī�װ��з�</td><td><%=rs.getString("bookCtg")%></td></tr>

            <tr><td>������ȣ</td><td><%=rs.getString("bookId")%></td></tr>

            <tr><td>���� ��</td><td><%=rs.getString("bookName")%></td></tr>

            <tr><td>���� ����</td><td><%=rs.getInt("price")%> ��</td></tr>

            <tr><td>������</td><td><%=rs.getInt("bookStock")%> ��</td></tr>

            <tr><td>���� </td><td><%=rs.getString("writer")%></td></tr>

            <tr><td>�󼼼���</td><td width=300><%=rs.getString("bookContent")%></td></tr>

            <tr><td>���ǻ�</td><td><%=rs.getString("publisher")%></td></tr>

            <tr><td>�Ǹ� ����</td><td><%=rs.getString("bookStatus")%></td></tr>

            <tr><td>å ����</td><td><%=rs.getString("bookReview")%></td></tr>
        </table><p>
        <a href="BookSelect.jsp" align=center style="font-size:10pt;font-family: '���� ���'">��ü ��ϻ�ǰ ��ȸ </a>
<%
    } catch (Exception e) {
        out.println(e);
    }
%>
</center>
</body>
</html>
