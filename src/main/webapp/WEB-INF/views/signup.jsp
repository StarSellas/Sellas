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
		<link href="css/signup.css" rel="stylesheet">

		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="./js/jquery-3.7.0.min.js"></script>
		<script src="./js/wnInterface.js"></script> 
		<script src="./js/mcore.min.js"></script> 
		<script src="./js/mcore.extends.js"></script>
	</head>
	<body>


	<div class="form-floating">
		<a href="./login"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
	</div>

	<form action="./signup" method="post">

	<div class="page" id="page1">
		<div>
			<div class="form-floating">
				<input class="form-control" type="text" id="email" name="email" placeholder="이메일 주소" maxlength="36" required="required">
				<label for="email">이메일 주소</label>
				<div id="emailMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating" id="emailCodeDiv" style="visibility: hidden;">
				<input class="form-control" type="text" id="emailCode" placeholder="인증번호" maxlength="16" required="required">
				<label for="emailCode">인증번호</label>
				<div id="emailCodeMessage"><span style="visibility: hidden;">:</span></div>
				<button type="button" id="sendCode" onclick="sendVerificationCode()">재요청</button>
				<button type="button" id="checkCode" onclick="validateEmailCode()">확인</button>
			</div>
		</div>
		<div class="form-floating">
			<button type="button" id="next1" onclick="showPage('page2')" disabled="disabled">다음</button>
		</div>
	</div>

	<div class="page" id="page2" style="display:none">
		<div>
			<div class="form-floating">
				<input class="form-control" type="text" id="id" name="id" placeholder="아이디" maxlength="15" required="required"> 	
				<label for="id">아이디</label>
				<div id="idMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">	
				<input class="form-control" type="password" id="pw" name="password" placeholder="비밀번호" maxlength="15" required="required">
				<label for="pw">비밀번호</label>
				<div id="pwMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">
				<input class="form-control" type="password" id="pwcheck" placeholder="비밀번호 확인" maxlength="15" required="required">
				<label for="pwcheck">비밀번호 확인</label>
				<div id="pwcheckMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<input type="hidden" id="encryptPassword" name="pw" value="">
		</div>
		<div class="form-floating">
			<button type="button" id="next2" onclick="showPage('page3')" disabled="disabled">다음</button>
		</div>
	</div>

	<div class="page" id="page3" style="display:none">
		<div>
			<div class="form-floating">
				<input class="form-control" type="text" id="nickname" name="nickname" placeholder="닉네임" maxlength="18" required="required">
				<label for="nickname">닉네임</label>
				<div id="nicknameMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">
				<input class="form-control" type="text" id="name" name="name" placeholder="이름" maxlength="18" required="required">
				<label for="name">이름</label>
				<div id="nameMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div class="form-floating">
				<input class="form-control" type="text" id="phone" name="phone" placeholder="휴대전화 번호" maxlength="11" required="required">		
				<label for="phone">휴대전화 번호</label>
				<div id="phoneMessage"><span style="visibility: hidden;">:</span></div>
			</div>
		</div>
		<div class="form-floating">
			<button type="submit" disabled="disabled">가입하기</button>
		</div>
	</div>

	</form>


	<!-- Bootstrap core JS-->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/signup.js"></script>
	</body>
</html>