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
		<link href="css/login.css" rel="stylesheet">
        
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

	<div class="loginDiv">

	<div>
		<div class="form-floating">
			<input class="form-control" type="text" id="id" name="id" maxlength="18" placeholder="아이디" required="required">
			<label for="id">아이디</label>
		</div>
		<div class="form-floating">
			<input class="form-control" type="password" id="pw" name="pw" maxlength="18" placeholder="비밀번호" required="required">
			<label for="pw">비밀번호</label>
		</div>

		<div class="form-floating" id="errorMessage">
			<span style="visibility: hidden;">:</span>
		</div>

		<div class="form-floating">
			<button class="endTypeButton" id="loginButton" onclick="login()">로그인</button>
		</div>
	</div>
	<div class="form-floating">
		<a class="text" href="./findid">아이디 찾기</a>
		<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
		<a class="text" href="./findpw">비밀번호 찾기</a>
		<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
		<a class="text" href="./signup">회원가입</a>
	</div>

	</div>


	<!-- Bootstrap core JS-->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/login.js"></script>

	</body>
</html>