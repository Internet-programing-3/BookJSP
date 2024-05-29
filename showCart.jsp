<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
	<link rel="stylesheet" type="text/css" href="Main.css?v=1">
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
		String DB_ID = "multi";
		String DB_PASSWORD = "abcd";
		Class.forName("com.mysql.cj.jdbc.Driver"); 
		Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);
		String userId = (String)session.getAttribute("userId"); 
	%>

	<header>
		<a href="Mainpage.jsp">
			<img src="images/Logo.jpg" style="width: 400px; height: 150px;" alt="청년책방 로고">
		</a>
	</header>

	<nav class="navMainOne">
		<div class="todayMain">
			<a href="#">
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
			</a>
		</div>
		  <!-- 검색바 -->
      <div class="searchMain">
         <img src="images/LogoIcon.png" alt="로고아이콘">
         <form method="post" action="Search.jsp">
            <input type="text" name="bookName">
         <button type="submit" alt="검색 버튼">검색</button>
         </form>
      </div>
		<div>
			<%
				if (userId == null) {
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

	<main class="ShopMain">
		<%
		try {

			String jsql = "select * from cart where userId = ?";
			PreparedStatement pstmt = con.prepareStatement(jsql);
			pstmt.setString(1, userId);
			ResultSet rs = pstmt.executeQuery();

			if (!rs.next()) {
		%>
				<article class="shopList">
					<table>
						<tr class="shopHeader">
							<th>장바구니가 비었습니다.</th>
						</tr>
					</table>
				</article>
		<%
			} else {
		%>
		<form method="post" action="DeleteCart.jsp">
		<article class="shopList">
    <table>
        <tr class="shopHeader">
            <th><input type="checkbox" id="selectAll" checked></th>
            <th colspan="2" align="left">전체 선택</th>
            <th colspan="2" align="right">
                <a href=""><button type="submit">선택 삭제</button></a>
            </th>
        </tr>
        <%
// 기존 코드와 함께 사용할 변수 선언
int totalAmount = 0;

String jsql2 = "select cart.ctNo, cart.bookId, ctQty, bookName, price, bookImg " +
               "from cart " +
               "join Book on cart.bookId = Book.bookId " +
               "where userId = ?";
PreparedStatement pstmt2 = con.prepareStatement(jsql2);
pstmt2.setString(1, userId);
ResultSet rs2 = pstmt2.executeQuery();
while (rs2.next()) {
    int ctNo = rs2.getInt("ctNo"); // cart 테이블로부터 ctNo 추출
    String bookId = rs2.getString("bookId"); // cart 테이블로부터 상품번호 추출
    int ctQty = rs2.getInt("ctQty"); // cart 테이블로부터 주문수량 추출
    String bookName = rs2.getString("bookName");
    int price = rs2.getInt("price");
    String bookImg = rs2.getString("bookImg");
    int amount = price * ctQty;
    totalAmount += amount;
%>
<tr class="shopCont">
    <td><input type="checkbox" class="item-checkbox" name="selectedItems" value="<%= ctNo %>" data-amount="<%= amount %>" checked></td>
    <td><img src="<%= bookImg %>.jpg"></td>
    <td align="left"><%= bookName %></td>
    <td><%= ctQty %>권</td>
    <td><%= amount %>원</td>
</tr>
<%
}
rs2.close();
pstmt2.close();
%>
    </table>
</article>
</form>

<!-- 결제정보 -->
<aside class="shopAside">
    <table>
        <tr>
            <th>총 상품 금액</th>
            <td id="totalAmount"><%= totalAmount %>원</td>
        </tr>
        <tr>
            <th>할인 금액</th>
            <td>- 0원</td>
        </tr>
        <tr class="shopEnd">
            <th>합계</th>
            <td id="totalSum"><%= totalAmount %>원</td>
        </tr>
    </table>
    <!-- 구매 버튼 -->
    <a id="purchaseButton">
        <button>구매하기</button>
    </a>
</aside>
							<%
							}
							%>
					
		<%
			
		} catch (Exception e) {
			out.println(e);
		}
		%>
	</main>

	<%
		con.close();	
	%>

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
	<script>
$(document).ready(function() {
    // 선택된 항목의 총액을 계산하는 함수
    function calculateTotal() {
        let totalAmount = 0;
        $(".item-checkbox:checked").each(function() {
            totalAmount += parseInt($(this).data("amount"));
        });
        $("#totalAmount").text(totalAmount + "원");
        $("#totalSum").text(totalAmount + "원");
    }

    // 체크박스 선택/해제 시 총액 계산
    $(".item-checkbox").on("change", function() {
        calculateTotal();
    });

    // 전체 선택/해제
    $("#selectAll").on("change", function() {
        $(".item-checkbox").prop("checked", $(this).prop("checked"));
        calculateTotal();
    });

    // 구매하기 버튼 클릭 시 선택된 항목들만 결제 페이지로 전송
    $("#purchaseButton").on("click", function() {
    let selectedItems = [];
    $(".item-checkbox:checked").each(function() {
        selectedItems.push($(this).val()); // ctNo 값을 가져와서 배열에 추가
    });

    if (selectedItems.length > 0) {
        // 선택된 ctNo 값을 배열로 가지고 있는 selectedItems를 문자열로 변환하여 쿼리 문자열에 추가
        var queryString = selectedItems.map(function(ctNo) {
            return 'ctNo=' + ctNo;
        }).join('&');

        // 결제 페이지로 이동하면서 쿼리 문자열을 추가하여 전달
        window.location.href = "Payment.jsp?" + queryString;
    } else {
        alert("선택된 상품이 없습니다.");
    }
});

    // 초기 총액 계산
    calculateTotal();
});
</script>
</body>
</html>

			