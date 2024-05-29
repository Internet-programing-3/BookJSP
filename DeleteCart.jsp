<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%
try {
    request.setCharacterEncoding("UTF-8");
    String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";
    Class.forName("com.mysql.cj.jdbc.Driver"); 
    Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

    String userId = (String)session.getAttribute("userId");
    String[] selectedItems = request.getParameterValues("selectedItems");

    if (userId != null && selectedItems != null && selectedItems.length > 0) {
        String itemQuery = String.join(",", Collections.nCopies(selectedItems.length, "?"));

        // ctNo를 사용하여 선택된 항목을 삭제하는 SQL 쿼리문
        String sql = "DELETE FROM cart WHERE userId = ? AND ctNo IN (" + itemQuery + ")";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);
        
        // 선택된 항목의 ctNo를 설정합니다.
        for (int i = 0; i < selectedItems.length; i++) {
            pstmt.setInt(i + 2, Integer.parseInt(selectedItems[i]));
        }

        int deletedRows = pstmt.executeUpdate();
        pstmt.close();
    }

    con.close();
    response.sendRedirect("showCart.jsp"); // 삭제 후 장바구니 페이지로 리다이렉트	
} catch (Exception e) {
    e.printStackTrace();
}
%>
