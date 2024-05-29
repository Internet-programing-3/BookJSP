<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.*, java.util.*, java.net.URLDecoder" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 결과</title>
    <link rel="stylesheet" type="text/css" href="Main.css?v=1">
    <script src="https://code.jquery.com/jquery-3.6.3.js"></script>
</head>
<body>
<%
Connection con = null;

try {
    request.setCharacterEncoding("UTF-8");
    String DB_URL = "jdbc:mysql://localhost:3306/internetproject";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

    String userId = (String)session.getAttribute("userId"); // 사용자의 ID를 가져옴

    // 주문 정보 가져오기
    String ordNo = request.getParameter("ordNo");

    String sql = "SELECT ordReceiver, ordRcvAddress, ordRcvPhone FROM orderInfo WHERE ordNo = ?";
    PreparedStatement pstmt1 = con.prepareStatement(sql);
    pstmt1.setString(1, ordNo);
    ResultSet rs1 = pstmt1.executeQuery();

%>

<header>
    <a href="Mainpage.jsp">
        <img src="images/Logo.jpg" style="width: 400px; height: 150px;" alt="청년책방 로고">
    </a>
</header>

<!-- nav1 ( 오늘의 책, 검색창, 마이페이지, 로그인 ) -->
<nav class="navMainOne">
    <!-- 오늘의 책 -->
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

<main class="orderMain">
    <!-- 주문 처리 완료 내용 -->
    <div class="orderHeader">
        <p>주문이 완료되었습니다!</p>
    </div>
 <!-- 주문자 정보 -->
    <section class="orderInfo">
        <%
            if (rs1.next()) {
                String ordReceiver = rs1.getString("ordReceiver");
                String ordRcvAddress = rs1.getString("ordRcvAddress");
                String ordRcvPhone = rs1.getString("ordRcvPhone");
        %>
        <article class="shopList">
            <table>
                <tr class="cartHeader">
                    <th colspan="2">주문자 정보</th>
                </tr>
                <tr class="cartCont">
                    <th>주문번호</th>
                    <td><%= ordNo %></td>
                </tr>
                <tr class="cartCont">
                    <th>수령인</th>
                    <td><%= ordReceiver %></td>
                </tr>
                <tr class="cartCont">
                    <th>주소</th>
                    <td><%= ordRcvAddress %></td>
                </tr>
                <tr class="cartCont">
                    <th>연락처</th>
                    <td><%= ordRcvPhone %></td>
                </tr>
            </table>
        </article>
        <%
            }
            rs1.close();
            pstmt1.close();
        %>
    </section>

    <!-- 주문 상품 목록 -->
    <section class="orderProducts">
        <%
            String[] ctNosEncoded = request.getParameterValues("ctNos");
            String[] ctNos = new String[ctNosEncoded.length];
            for (int i = 0; i < ctNosEncoded.length; i++) {
                ctNos[i] = URLDecoder.decode(ctNosEncoded[i], "UTF-8");
            }

            int total = 0;

            for (String ctNo : ctNos) {
                String jsql2 = "SELECT bookId, ctQty FROM cart WHERE userId = ? AND ctNo = ?";
                PreparedStatement pstmt2 = con.prepareStatement(jsql2);
                pstmt2.setString(1, userId);
                pstmt2.setString(2, ctNo);
                ResultSet rs2 = pstmt2.executeQuery();

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
        <article class="shopList">
            <table>
                <tr class="cartHeader">
                    <th colspan="4">주문 상품 : <%= ctQty %> 개</th>
                </tr>
                <tr class="shopCont">
                    <td><img src="<%= bookImg %>.jpg"></td>
                    <td align="left"><%= prdName %></td>
                    <td><%= ctQty %>권</td>
                    <td><%= amount %>원</td>
                </tr>
            </table>
        </article>
        <%
                    rs3.close();
                    pstmt3.close();
                }
                rs2.close();
                pstmt2.close();

                // 장바구니 항목 삭제
                String deleteCartSql = "DELETE FROM cart WHERE userId = ? AND ctNo = ?";
                PreparedStatement pstmtDelete = con.prepareStatement(deleteCartSql);
                pstmtDelete.setString(1, userId);
                pstmtDelete.setString(2, ctNo);
                pstmtDelete.executeUpdate();
                pstmtDelete.close();
            }
        %>
    </section>

    <!-- 결제 금액 -->
    <section class="orderSummary">
        <div class="orderEnd">
            <p class="EndOne">총 결제 금액</p>
            <p class="EndTwo"><%= total %>원</p>
        </div>
    </section>
</main>

<!-- 페이지 이동 -->
<div class="pageMove">
    <p><a href="MyPage.jsp">&lt; 메인으로 돌아가기</a></p>
    <p><a href="MyPage.jsp">마이페이지로 이동하기 &gt;</a></p>
</div>

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
<%
} catch (Exception e) {
    out.println("일반 오류: " + e.getMessage());
} finally {
    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        out.println("자원 해제 오류: " + e.getMessage());
    }
}
%>
</body>
</html>
                