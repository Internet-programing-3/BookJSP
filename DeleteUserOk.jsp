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
		String userId = (String) session.getAttribute("userId");
		String pw = request.getParameter("pw");
		try{
			
			String DB_URL = "jdbc:mysql://localhost:3306/internetproject";	//  ������ DB��
			String DB_ID = "multi";	//  ������ ���̵�
			String DB_PASSWORD = "abcd";	// ������ �н�����
			
			Class.forName("com.mysql.cj.jdbc.Driver"); 
			Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);	// DB�� ����
			
			String sql = "select * from User where userid = ? and password = ?";	//SQL�� �ۼ�
			
			//PreparedStatement ����(SQL���� ��Ʋ�� ����)
			PreparedStatement pstmt1 = con.prepareStatement(sql);
			pstmt1.setString(1, userId);
			pstmt1.setString(2, pw);
			// sql�� ����
			ResultSet rs = pstmt1.executeQuery();
			
			if(rs.next()){ // ����
				String jsql = "delete from User where userid=?";
				PreparedStatement  pstmt2 = con.prepareStatement(jsql);
				pstmt2.setString(1, userId);
				
				pstmt2.executeUpdate();
				%>
				<script>
					alert("ȸ��Ż�� �Ϸ�Ǿ����ϴ�.");
					window.location.href = "<%= request.getContextPath() %>/Logout.jsp";
				</script>
			<% }else{	// ���� %>
				<script>
					alert("��й�ȣ�� Ʋ�Ƚ��ϴ�.");
					window.location.href = "<%= request.getContextPath() %>/DeleteUser.jsp";
				</script>
			<% }
			
		} catch (Exception e) {
	        out.println(e);
		}
	%>
</body>
</html>