<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 상세</title>
	<!-- 외부 CSS 적용 / 파일 경로 뒤에 ' ?v=1 ' 부분 지우지 마세요. 에러나요! -->
	<!-- 단위 수정 잘못하면 UI랑 배열 깨집니다 -->
	<link rel="stylesheet" type="text/css" href="Main.css?v=1">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		// DB 연결
		String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
		String DB_ID = "multi";
		String DB_PASSWORD = "abcd";
		Class.forName("com.mysql.cj.jdbc.Driver"); 
		Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

		String bookId = request.getParameter("bookId");
		String DetailLoad = "SELECT * FROM Book where bookId =?";

		PreparedStatement pstmtDL = con.prepareStatement(DetailLoad);
        pstmtDL.setString(1, bookId);
        ResultSet rsDL = pstmtDL.executeQuery();

		rsDL.next();
		String bookCtg = rsDL.getString("bookCtg");
		String bookName = rsDL.getString("bookName");
		int price = rsDL.getInt("price");
		int bookStock = rsDL.getInt("bookStock");
		String writer = rsDL.getString("writer");
		String bookContent = rsDL.getString("bookContent");
		String publisher = rsDL.getString("publisher");
		String bookImg = rsDL.getString("bookImg");
		String bookStatus = rsDL.getString("bookStatus");
		String bookReview = rsDL.getString("bookReview");

		rsDL.close();
		pstmtDL.close();

		int point = (price / 100) * 5;
	%>
	<!-- 제이쿼리용 -->
	<script type="text/javascript">
		 $(document).ready(function(){
			 $(".btnMO li").click(function () {
				var contNum = $(this).index();
				$(this).addClass("On").siblings().removeClass("On");
				$(".contMO").eq(contNum).addClass("On").siblings().removeClass("On");
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
				rsToday.next();
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
				rsToday.close();
				pstmtToday.close();
			%>
		</a></div>
		<!-- 검색바 -->
		<div class="searchMain">
			<img src="images/LogoIcon.png" alt="로고아이콘">
			<input type="text">
			<button type="button" alt="검색 버튼">검색</button>
		</div>
		<!-- 마이페이지, 장바구니, 로그인/로그아웃 버튼 -->
		<div>
			<!-- 로그인 -->
			<%
				if (session.getAttribute("userId") == null) {
			%>
			<a href="Login.jsp">
				<img src="images/mypage.png" style="width: 50px; height: 50px;" title="마이페이지" alt="마이페이지">
			</a>
			<a href="Login.jsp">
				<img src="images/cart.png" style="width: 50px; height: 50px; margin: 0 10px;" title="장바구니" alt="장바구니">
			</a>
			<a href="Login.jsp">
				<img src="images/logIn.png" style="width: 50px; height: 50px;" title="로그인" alt="회원가입/로그인">
			</a>
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

	<main>
		<section class="DetailOne">
			<img src="<%=bookImg%>.jpg" title="<%=bookName%>(<%=writer%>)" alt="<%=bookName%>">
			<div class="infoDO">
				<h1><%=bookName%></h1>
				<p>
					저자 : <a href="javascript:void(0);"><%=writer%></a> | 
					출판사 : <a href="javascript:void(0);"><%=publisher%></a>
				</p>
				<table>
					<tr>
						<td>상태</td>
						<td><%=bookStatus%></td>
					</tr>
					<tr>
						<td>정가</td>
						<td><b><%=price%></b>원</td>
					</tr>
					<tr>
						<td>적립금</td>
						<td><b><%=point%></b>원 (5%)</td>
					</tr>
					<tr>
						<td>배송일정</td>
						<td>영업일 기준 2~3일 이내</td>
					</tr>
				</table>
			</div>
			<div class="addDO">
				<p>주문수량 : <input type="number" id="ctQty" value="1" min="1" max="<%=bookStock%>"> 권</p>
				<%if(bookStock <= 10){ out.print("<p class='stock'>(남은 재고: " + bookStock + "권)</p>"); }%>
				<a href="javascript:addToCart('<%=bookId%>');"><button class="cart">장바구니 담기</button></a>
			</div>
			<script type="text/javascript">
    function addToCart(bookId) {
        var ctQty = document.getElementById('ctQty').value;
        window.location.href = 'inCart.jsp?bookId=' + bookId + '&ctQty=' + ctQty;
    }
</script>
		</section>
		<section class="DetailTwo">
			<!-- 도서 상세 정보 -->
			<article>
				<!-- 도서 분류 -->
				<div id="contDT-01">
					<ul>
						<li class="On">도서 분류</li>
						<a href="#contDT-02"><li>도서 정보</li></a>
						<a href="#ontDT-03"><li>독자 서평</li></a>
					</ul>
					<p><%=bookCtg%></p>
				</div>
				<!-- 도서 정보 -->
				<div id="contDT-02">
					<ul>
						<a href="#contDT-01"><li>도서 분류</li></a>
						<li class="On">도서 정보</li>
						<a href="#contDT-03"><li>독자 서평</li></a>
					</ul>
					<p><%=bookContent%></p>
				</div>
				<!-- 독자 서평 -->
				<div id="contDT-03">
					<ul>
						<a href="#contDT-01"><li>도서 분류</li></a>
						<a href="#contDT-02"><li>도서 정보</li></a>
						<li class="On">독자 서평</li>
					</ul>
					<p><%=bookReview%></p>
				</div>
			</article>
			<!-- 서브바 -->
			<aside>
				<h4><%=bookCtg%>의 신간</h4>
				<%
					String DetailSub = "SELECT bookId, bookName, price, writer, bookImg FROM Book WHERE bookCtg =? ORDER BY bookId DESC LIMIT 5";
					PreparedStatement pstmtDS = con.prepareStatement(DetailSub);
					pstmtDS.setString(1, bookCtg);
					ResultSet rsDS = pstmtDS.executeQuery();
					while(rsDS.next()){
						bookId = rsDS.getString("bookId");
						bookName = rsDS.getString("bookName");
						price = rsDS.getInt("price");
						writer = rsDS.getString("writer");
						 bookImg = rsDS.getString("bookImg");
				%>
				<a href="BookDetail.jsp?bookId=<%=bookId%>"><div>
					<img src="<%=bookImg%>.jpg" title="<%=bookName%>(<%=writer%>)" alt="<%=bookName%>">
					<p>
						<b><%=bookName%></b></br>
						<%=writer%></br>
						<%=price%>원
					</p>
				</div></a>
				<%
					}
					rsDS.close();
					pstmtDS.close();
				%>
			</aside>
		</section>
	</main>

	<%
		con.close();
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