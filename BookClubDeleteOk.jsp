<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>ȸ��Ż��</title>
</head>
<body>
	<%
		String postId = request.getParameter("postId");
		String pw = request.getParameter("pw");
	
		try{
			
			String DB_URL = "jdbc:mysql://localhost:3306/internetproject";	//  ������ DB��
			String DB_ID = "multi";	//  ������ ���̵�
			String DB_PASSWORD = "abcd";	// ������ �н�����
			
			Class.forName("com.mysql.cj.jdbc.Driver"); 
			Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);	// DB�� ����
			
			String sql = "select * from User where password = ?";	//SQL�� �ۼ�
			
			//PreparedStatement ����(SQL���� ��Ʋ�� ����)
			PreparedStatement pstmt1 = con.prepareStatement(sql);
			pstmt1.setString(1, pw);
			// sql�� ����
			ResultSet rs = pstmt1.executeQuery();
			
			if(rs.next()){ // ����
				String jsql = "delete from clubpost where postId=?";
				PreparedStatement  pstmt3 = con.prepareStatement(jsql);
				pstmt3.setString(1, postId);
				
				pstmt3.executeUpdate();
				%>
				<script>
					alert("�Խù� ������ �Ϸ�Ǿ����ϴ�.");
					location.href = "BookClub.jsp?clubId=1"
				</script>
			<% }else{	// ���� %>
				<script>
					alert("��й�ȣ�� Ʋ�Ƚ��ϴ�.");
					location.href = "BookClubDelete.jsp?postId=<%=postId%>"
				</script>
			<% }
			
		} catch (Exception e) {
	        out.println(e);
		}
	%>
</body>
</html>