<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
	<!-- 외부 CSS 적용 / 파일 경로 뒤에 ' ?v=1 ' 부분 지우지 마세요. 에러나요! -->
	<!-- 단위 수정 잘못하면 UI랑 배열 깨집니다 -->
	<link rel="stylesheet" type="text/css" href="Main.css?v=1">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
</head>
<body>
	<!-- header (로고) -->
	<header>
		<a href="Mainpage.jsp">
			<img src="images/Logo.jpg" style="width: 400px; height: 150px;" alt="청년책방 로고">
		</a>
	</header>

	<!-- 회원가입 폼 -->
	<main class="SignMain">
		<form name="myform" method="post" action="SignUpOk.jsp">
			<h3>회원가입</h3>
			<p>회원가입을 위한 정보를 입력해주세요.</p>
			<div class="contSM">
				<!-- 아이디 입력 -->
				<div class="contSM-01">
					<h4>아이디</h4>
					<input type="text" name="id" maxlength="11" placeholder="아이디를 입력하세요 (필수)" required autofocus>
				</div>
				<p>숫자로만, 최대 11자리</p>
				<!-- 비밀번호 입력 -->
				<div class="contSM-01">
					<h4>비밀번호</h4>
					<input type="password" name="pw" maxlength="20" placeholder="비밀번호를 입력하세요 (필수)" required>
				</div>
				<p>영문과 숫자 혼합 가능, 최대 20자리</p>
				<!-- 이름 입력 -->
				<div class="contSM-01">
					<h4>이름</h4>
					<input type="text" name="name" maxlength="20" placeholder="이름을 입력하세요 (필수)" required>
				</div>
				<p>최대 20자(한글 10자)까지 가능</p>
				<!-- 핸드폰 번호 입력 -->
				<div class="contSM-02">
					<h4>연락처</h4>
					<select name="hp1">
						<option value="010" selected>010
						<option value="011">011
						<option value="016">016
						<option value="017">017
						<option value="018">018
						<option value="019">019
					</select> - 
					<input type="text" name="hp2" maxlength="4" required> - 
					<input type="text" name="hp3" maxlength="4" required>
				</div>
				<!-- 이메일 입력 -->
				<div class="contSM-03">
					<h4>이메일</h4>
					<input type="text" name="email1" placeholder="이메일 아이디" required> @ 
					<input type="text" name="email2" placeholder="이메일 주소" required>
				</div>
				<!-- 생일 입력 -->
				<div class="contSM-04">
					<h4>생년월일</h4>
					<input type="date" name="birth" required>
				</div>
				<!-- 성별 입력 -->
				<div class="contSM-05">
					<h4>성별</h4>
					<div>
						<input type="radio" name="sex" value="M" required>남성
						<input type="radio" name="sex" value="W" required>여성
					</div>
				</div>
            </div>
			<button type="submit" title="회원가입" alt="회원가입 버튼">회원가입</button>
			<button type="reset" title="입력정보 초기화" alt="입력정보 초기화 버튼">입력한 정보 초기화</button>
			<a href="/Login.jsp"><h5>로그인 화면으로 돌아가기</h5></a>
		</form>
    </main>

</body>
</html>
