<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>Shop Homepage - Start Bootstrap Template</title>
<!-- Favicon-->
<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
<!-- Bootstrap icons-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"
	rel="stylesheet" />
<!-- Core theme CSS (includes Bootstrap)-->
<link rel="stylesheet" type="text/css" href="/css/styles.css">

<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
	href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet" href="../css/profileEdit.css">
<style type="text/css">
</style>
</head>
<body>
	<!-- Navigation-->
   <%@ include file="menubar.jsp" %>
	<!-- Header-->
	<header> </header>
	<!-- Section-->
	<section class="py-5">

		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
			<div class="d-flex inside-bar align-items-center">
				<div class="back col-auto" onclick="location.href='/profile'">
					<i class="xi-angle-left xi-x"></i>
				</div>
				<div class="location col">프로필수정</div>
			</div>
			
			<div class="edit-div">
				
				<div class="user-img">
					<img src="../img/흰배경셀라스.jpg" alt="user-img" class="user-img-img">
				</div>
				<img src="../img/camera.png" alt="camera" class="camera" onclick="picChange()">
				</div>
				
				
			<div class="form-floating" id="nicknameDIV">
				<input class="form-control" id="newNickname" value=${nickname}>
			</div>
				<button id="nickChangeBtn" onclick="nickChange()">닉네임 변경</button>
		</div>

	</section>
	<!-- Footer-->
	<!-- Bootstrap core JS-->
	<script src="../js/jquery-3.7.0.min.js"></script>
	<script src="../js/mypage.js"></script>
</body>
</html>
