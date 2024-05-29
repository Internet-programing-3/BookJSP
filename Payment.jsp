<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 내역 정보</title>
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
    %>

    <!-- header (로고) -->
    <header>
        <a href="Mainpage.jsp">
            <img src="images/Logo.jpg" style="width: 400px; height: 150px;" alt="청년책방 로고">
        </a>
    </header>

    <!-- nav1 ( 오늘의 책, 검색창, 마이페이지, 로그인 ) -->
    <nav class="navMainOne">
        <!-- 오늘의 책 -->
        <div class="todayMain"><a href="#">
            <%
            String userId = (String)session.getAttribute("userId");
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
         <form method="post" action="Search.jsp">
            <input type="text" name="bookName">
         <button type="submit" alt="검색 버튼">검색</button>
         </form>
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
            <a href="inCart.jsp">
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

    <main class="PayMain">
        <%
        try {
        %>
        <!-- 결제 정보 -->
        <section>
            <!-- 배송지 정보 -->
            <!-- 주문자 정보 출력 -->
            <%
            
                
                    String jsql4 = "SELECT name, phone FROM user WHERE userId = ?";
                    PreparedStatement pstmt4 = con.prepareStatement(jsql4);
                    pstmt4.setString(1, userId);
                    ResultSet rs4 = pstmt4.executeQuery();

                    
                    String name = "";
                    String tel = "";
                    if (rs4.next()) {
                        name = rs4.getString("name");
                        tel = rs4.getString("phone");
                    }
					

                    
   
    
%>
        <form name="form" method="post" action="OrderOk.jsp">
				<article class="shopList">
						<table>
							<tr class="cartCont">
								<td>주소</td>
								<td><input type="text" name="ordRcvAddress"></td>
							</tr>

							<tr class="cartCont">
								<td>수령인</td>
							   <td><input type="text"name="ordReceiver"></td>
							</tr>

							<tr class="cartCont">
								<td>연락처</dh>
								<td><input type="text" name="ordRcvPhone" ></td>
							</tr>
						</table>
					
				</article>

            <%
                    
                    rs4.close();
                    pstmt4.close();
            
            %>

            <!-- 상품 목록 -->
            <article class="shopList">
                <%
                // 주문 상품 정보 출력
                String jsql2 = "SELECT bookId, ctQty FROM cart WHERE userId = ?";
                PreparedStatement pstmt2 = con.prepareStatement(jsql2);
                pstmt2.setString(1, userId);
                ResultSet rs2 = pstmt2.executeQuery();
                int total = 0;
                while (rs2.next()) {
                    String prdNo = rs2.getString("bookId");
                    int ctQty = rs2.getInt("ctQty");
                    String jsql3 = "SELECT bookName, price, bookImg FROM Book WHERE bookId = ?";
                    PreparedStatement pstmt3 = con.prepareStatement(jsql3);
                    pstmt3.setString(1, prdNo);
                    ResultSet rs3 = pstmt3.executeQuery();
                    rs3.next();

                    String prdName = rs3.getString("bookName");
                    int prdPrice = rs3.getInt("price");
                    String bookImg = rs3.getString("bookImg");
                    int amount = prdPrice * ctQty;
                    total += amount;
                %>
                <table>
                    <tr class="cartHeader">
                        <th colspan="4">주문 상품 : <%=ctQty %> 개</th>
                    </tr>
                    <tr class="shopCont">
                            <td><img src="<%= bookImg %>.jpg"></td>
                            <td align="left"><%= prdName %></td>
                            <td><%= ctQty %>권</td>
                            <td><%= amount %>원</td>
                        </a>
                    </tr>
                </table>
                <%
                }
                rs2.close();
                pstmt2.close();
                %>
            </article>

            <!-- 결제 수단-->
            <article class="shopList">
                <table>
                    <tr class="cartHeader">
                        <th colspan="4">결제 수단</th>
                    </tr>
                    <tr class="cartCont">
						<th><input type="radio" name="ordPay" value="card" checked>카드</th>
                        <th><input type="radio" name="ordPay" value="무통장 입금">무통장 입금</th>
                        <th><input type="radio" name="ordPay" value = "카카오">카카오</th>
                        <th><input type="radio" name="ordPay" value = "네이버">네이버</th>
                    </tr>
                </table>
            </article>

        </section>
        

        <!-- 결제 확인 -->
        <aside class="shopAside">
            <table>
                <tr>
                    <th>총 상품 금액</th>
                    <td><%= total %>원</td>
                </tr>
                <tr>
                    <th>할인 금액</th>
                    <td>- 0원</td>
                </tr>
                <tr class="shopEnd">
                    <th>합계</th>
                    <td><%= total %>원</td>
                </tr>
  
            </table>
            <input type="checkbox" required>
            <span>상품, 가격, 할인 정보, 유의 사항 등을 확인하였으며 구매에 동의합니다.</span>
            <!-- 결제 버튼 -->
				<a href="OrderOk.jsp"><button>결제하기</button></a>
        </aside>
				</form>
        <%
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        %>
    </main>

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

