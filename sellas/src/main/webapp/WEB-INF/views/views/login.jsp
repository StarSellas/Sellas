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
        
		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="./js/jquery-3.7.0.min.js"></script>
	</head>
	<body>
	
	 <%@ include file="menubar.jsp" %>
	
	<!-- Section-->
	<section class="py-5">
		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
			<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
			</div>
		</div>
	</section>	
	
	<div>
		<input type="text" id="id" name="id" placeholder="아이디" maxlength="18" required="required">
		<input type="password" id="pw" name="pw" placeholder="비밀번호" maxlength="18" required="required">
		<button id="loginBtn" onclick="login()">로그인</button>
	</div>
	<div>
		<a href="./findid">아이디 찾기</a>
		<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
		<a href="./findpw">비밀번호 찾기</a>
		<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
		<a href="./signup">회원가입</a>
	</div>
	
	<!-- Bootstrap core JS-->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/login.js"></script>
    </body>
</html>

