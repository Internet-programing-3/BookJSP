<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
	<!-- 외부 CSS 적용 / 파일 경로 뒤에 ' ?v=1 ' 부분 지우지 마세요. 에러나요! -->
	<!-- 단위 수정 잘못하면 UI랑 배열 깨집니다 -->
	<link rel="stylesheet" type="text/css" href="Main.css?v=1">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
</head>
<body>
	<%
		// 인코딩
		request.setCharacterEncoding("UTF-8");
		// DB 연결
		String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
		String DB_ID = "multi";
		String DB_PASSWORD = "abcd";
		Class.forName("com.mysql.cj.jdbc.Driver"); 
		Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);
		String userId = (String) session.getAttribute("userId");
	%>
	<!-- 제이쿼리용 -->
	<script type="text/javascript">
	    $(document).ready(function(){
	        $(".btnMM li").click(function () {
	           var contNum = $(this).index();
	           $(this).addClass("On").siblings().removeClass("On");
	           $(".contMM").eq(contNum).addClass("On").siblings().removeClass("On");
	       });
	    })
	</script>

	<!-- header (로고) -->
	<header>
		<a href="Mainpage.jsp">
			<img src="images/Logo.jpg" style="width: 400px; height: 150px;" alt="청년책방 로고">
		</a>
	</header>

	<!-- nav1 ( 오늘의 책, 검색창, 마이페이지, 로그인 ) -->
	<nav class="navMainOne">
		<!--오늘의 책 -->
		<div class="todayMain"><a href="#">
		
		<%
    int today = 0;
    Random random = new Random();
    today = random.nextInt(8) + 1;

    String todayBook = "SELECT bookId, bookName, writer, bookImg FROM Book WHERE bookId = ?";
    PreparedStatement pstmtToday = con.prepareStatement(todayBook);
    pstmtToday.setInt(1, today);
    ResultSet rsToday = pstmtToday.executeQuery();

    // 결과 집합이 비어있는지 확인
    if (rsToday.next()) {
        int todaykId = rsToday.getInt("bookId");
        String todayName = rsToday.getString("bookName");
        String todayWriter = rsToday.getString("writer");
        String todayBookImg = rsToday.getString("bookImg");
%>
<span>
    <img src="<%=todayBookImg%>.jpg" title="<%=todayName%>(<%=todayWriter%>)" alt="<%=todayName%>">
</span>
<span>
    <h3><%=todayName%></h3>
    <p><%=todayWriter%></p>
</span>
<%
    } else {
        // 결과가 없을 때 처리하는 부분을 여기에 추가합니다.
    }
    rsToday.close();
    pstmtToday.close();
%>
		</a></div>
		  <!-- 검색바 -->
      <div class="searchMain">
         <img src="images/LogoIcon.png" alt="로고아이콘">
         <form method="post" action="Search.jsp">
            <input type="text" name="bookName">
         <button type="submit" alt="검색 버튼">검색</button>
         </form>
      </div>
		<!-- 마이페이지, 장바구니, 로그인/로그아웃 버튼 -->
		<div>
			<!-- 로그인 -->
			<%
				if (userId == null) {
			%>
				<script>
						window.location.href = "<%= request.getContextPath() %>/Login.jsp";
				</script>
			<!-- 로그아웃 -->
			<%
				} else {
			%>
			<a href="MyPage.jsp">
				<img src="images/mypage.png" style="width: 50px; height: 50px;" title="마이페이지" alt="마이페이지">
			</a>
			<a href="showCart.jsp">
				<img src="images/cart.png" style="width: 50px; height: 50px; margin: 0 10px;" title="장바구니" alt="장바구니">
			</a>
			<a href="Logout.jsp">
				<img src="images/logOut.png" style="width: 50px; height: 50px;" title="로그아웃" alt="로그아웃">
			</a>
			<%
				}
			%>
        </div>
	</nav>

	<!-- nav2 (베스트셀러, 신간도서, 국내도서 등) -->
	<nav class="navMainTwo">
		<ul>
			<li><a href="BookList.jsp?bookCtg=베스트셀러">
				<img src="images/menuButton01.png" alt="베스트셀러">
			</a></li>
			<li><a href="BookList.jsp?bookCtg=신간도서">
				<img src="images/menuButton02.png" alt="신간도서">
			</a></li>
			<li><a href="BookList.jsp?bookCtg=국내도서">
				<img src="images/menuButton03.png" alt="국내도서">
			</a></li>
			<li><a href="BookList.jsp?bookCtg=해외도서">
				<img src="images/menuButton04.png" alt="해외도서">
			</a></li>
			<li><a href="BookClub.jsp?clubId=1">
				<img src="images/menuButton06.png" alt="북클럽">
			</a></li>
		</ul>
	</nav>

	<main class="MyMain">
		<ul class="btnMM">
				<li class="On"><a href="javascript:void(0);">주문 내역 조회</a></li>
				</ul>
				<%

    String mypagebookinfo = "SELECT ordNo, ordDate, ordReceiver, ordRcvAddress FROM orderInfo WHERE userId = ?";
    PreparedStatement pstmt1 = con.prepareStatement(mypagebookinfo);
    pstmt1.setString(1, userId);
    ResultSet rs1 = pstmt1.executeQuery();
    
        // 주문 상품 정보 가져오는 쿼리 추가 필요
%>
<div class="contMM On">
    <h1>전체 주문 내역</h1>
               <table class="tableMM-01">
                <tr>
                    <th>주문일</th>
                    <th>주문 번호</th>
                    <th>수령인</th>
                    <th>주문 주소</th>
                    <th>주문 상품</th>
                </tr>
                <%
                    while (rs1.next()) {
                        int ordNo = rs1.getInt("ordNo");
                        String ordDate = rs1.getString("ordDate");
                        String ordReceiver = rs1.getString("ordReceiver");
                        String ordRcvAddress = rs1.getString("ordRcvAddress");
                        // 주문 상품 정보 가져오기
                        String orderDetailsQuery = "SELECT p.bookId, b.bookName, p.ordQty " +
                                                   "FROM orderproduct p " +
                                                   "JOIN Book b ON p.bookId = b.bookId " +
                                                   "WHERE p.ordNo = ?";
                        PreparedStatement pstmtDetails = con.prepareStatement(orderDetailsQuery);
                        pstmtDetails.setInt(1, ordNo);
                        ResultSet rsDetails = pstmtDetails.executeQuery();
                %>
                <tr>
                    <td><%= ordDate %></td>
                    <td><%= ordNo %></td>
                    <td><%= ordReceiver %></td>
                    <td><%= ordRcvAddress %></td>
                    <td>
                        <%
                            while (rsDetails.next()) {
                                String bookName = rsDetails.getString("bookName");
                                int quantity = rsDetails.getInt("ordQty");
                        %>
                        <p><%= bookName %> - <%= quantity %> 개</p>
                        <%
                            }
                            rsDetails.close();
                            pstmtDetails.close();
                        %>
                    </td>
                </tr>
                <%
                    }
                    rs1.close();
                    pstmt1.close();
                %>
            </table>
</div>


		<ul class="btnMM">
				<li class><a href="javascript:void(0);">회원 정보 관리</a></li>
				</ul>
		
		<%
         String id = (String)session.getAttribute("userId");
      
          String user = "SELECT userId, name, phone, email, birth, gender FROM user WHERE userId = ?";
          PreparedStatement pstmt = con.prepareStatement(user);
          pstmt.setString(1, id);
          ResultSet rs = pstmt.executeQuery();
          
            if(rs.next()){
               
               String name = rs.getString("name");
               String phone = rs.getString("phone");
               String email = rs.getString("email");
               String birth = rs.getString("birth");
               String gender = rs.getString("gender");
      
      %>
      
      <div class="contMM">
         <h1>회원 정보</h1>
         <table class="tableMM-02">
            <tr>
               <th>이름</th>
               <td><%= name %></td>
            </tr>
            <tr>
               <th>아이디</th>
               <td><%= id %></td>
            </tr>
            <tr>
               <th>연락처</th>
               <td><%= phone %></td>
            </tr>
            <tr>
               <th>이메일</th>
               <td><%= email %></td>
            </tr>
            <tr>
               <th>생일</th>
               <td><%= birth %></td>
            </tr>
            <tr>
               <th>성별</th>
               <td><%= gender %></td>
            </tr>
         </table>
         <div class="btnModify">
            <a href="UpdateUser.jsp"><button class="Update" alt="회원 정보 수정 버튼">회원 정보 수정</button></a>
            <a href="DeleteUser.jsp"><button class="Delete" alt="회원 탈퇴 버튼">회원 탈퇴</button></a>
         </div>
         
      </div>
	  
   </main>
   
   <%
      }
   %>
	

	<!-- footer -->
	<footer>
		<div class="notices">
			<ul>
				<li><h4>공지사항</h4></li>
				<li><a href="javascript:void(0);">개인정보 처리방침 변경안내</a></li>
				<li><a href="javascript:void(0);"><h4>더보기+</h4></a></li>
				<li><h4>이벤트</h4></li>
				<li><a href="javascript:void(0);">11월 북클럽 독후감대회 우승자 발표</a></li>
				<li><a href="javascript:void(0);"><h4>더보기+</h4></a></li>
			</ul>
		</div>
		<div class="footerMain">
			<img src="images/Logo.jpg">
			<div>
				<p>회사소개 | 이용약관 | 개인정보처리방침 | 청소년보호정책 | 대량주문안내 | 협력사여러분 | 채용정보 | 광고소개</p>
				<p>
					대표이사 : 서병덕 | 남서울대학교 멀티미디어학과 | 사업자등록번호 : 181-001-2002</br>
					대표전화 : 1588-0000 (발신자 부담전화) | FAX : 0000-112-505 (지역번호 공통) | 인터넷프로그래밍2 : 제 2023호
				</p>
			</div>
		</div>
	</footer>
</body>
</html>