<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<title>Shop Homepage - Start Bootstrap Template</title>
		<!-- Favicon-->
		<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
		<!-- Bootstrap icons-->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
		<!-- Core theme CSS (includes Bootstrap)-->
		<link href="css/styles.css" rel="stylesheet" />
		<link href="css/findid.css" rel="stylesheet">

		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="./js/jquery-3.7.0.min.js"></script>
	</head>
	<body>


		<div class="page" id="page1">
			<div class="form-floating">
				<input class="form-control" type="text" id="email" placeholder="이메일 주소" maxlength="36" required="required">
				<label for="email">이메일 주소</label>
				<div id="emailMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">
				<button onclick="findid(true)">다음</button>
			</div>
		</div>

		<div class="page" id="page2" style="display:none">
			<div class="form-floating">
				<div class="idDiv" id="filteredid">ID</div>
			</div>
			<div class="form-floating" id="emailCodeDiv" style="visibility: hidden;">
				<input class="form-control" type="text" id="emailCode" placeholder="인증번호" maxlength="16" required="required">
				<label for="emailCode">인증번호</label>
				<div id="emailCodeMessage"><span style="visibility: hidden;">:</span></div>
				<button type="button" id="sendCode" onclick="sendVerificationCode()">재요청</button>
				<button type="button" id="checkCode" onclick="validateEmailCode()">확인</button>
			</div>
			<div class="form-floating">
				<button id="startEmailVerificationButton" onclick="showEmailCodeDiv()">아이디 전체보기</button>
			</div>
			<div class="form-floating" id="ExtraDiv">
				<a class="text" href="./findpw">비밀번호 찾기</a>
				<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
				<a class="text" href="./login">로그인</a>
			</div>
		</div>

		<div class="page" id="page3" style="display:none">
			<div class="form-floating">
				<div class="idDiv" id="unfilteredid">ID</div>
			</div>
			<div class="form-floating">
				<a class="text" href="#" onclick="showPage('page4')">비밀번호 찾기</a>
				<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
				<a class="text" href="./login">로그인</a>
			</div>
		</div>

		<div class="page" id="page4" style="display:none">
			<div class="form-floating">	
				<input class="form-control" type="password" id="pw" name="pw" placeholder="비밀번호" maxlength="15" required="required">
				<label for="pw">비밀번호</label>
				<div id="pwMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">
				<input class="form-control" type="password" id="pwcheck" placeholder="비밀번호 확인" maxlength="15" required="required">
				<label for="pwcheck">비밀번호 확인</label>
				<div id="pwcheckMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">
				<button id="changePasswordButton" onclick="changePassword()" disabled="disabled">확인</button>
			</div>
		</div>

		<div class="page" id="page5" style="display:none">
			<div class="form-floating">
				<a class="text" href="./login">로그인</a>
			</div>
		</div>

		<!-- Bootstrap core JS-->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		<!-- Core theme JS-->
		<script src="js/findid.js"></script>
	</body>
</html>