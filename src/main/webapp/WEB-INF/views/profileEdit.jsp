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
<script src="../js/jquery-3.7.0.min.js"></script>
<script src="../js/wnInterface.js"></script> 
      <script src="../js/mcore.min.js"></script> 
      <script src="../js/mcore.extends.js"></script>
</head>
<body>
	<!-- Navigation-->
		<!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-white" id="headerline" style="z-index: 10">
           <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="../"><img src="../img/sellastext.png" class="header" alt="SellAS"></a>
                <button class="navbar-toggler" type="button" data-bs-target="" aria-controls="navbarSupportedContent">
  <a href="../menu" style="text-decoration: none;">
    <img src="../img/menu1.png" id="menuIcon" alt="menuIcon">
  </a>
</button>
           </div>
        </nav>
	<!-- Header-->
	<header> </header>
	<!-- Section-->
	<section class="py-5">

		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
			<div class="d-flex inside-bar align-items-center">
				<div class="back col-auto" onclick="location.href='/profile'">
					<i class="xi-angle-left xi-x"></i>
				</div>
				<div class="location col">프로필 수정</div>
			</div>
			
			<div class="edit-div">
				
				<div class="user-img">
					<img src="../userImgUpload/${mphoto}" alt="user-img" class="user-img-img">
				</div>
						<div class="toggleBtnBox">
						<button class="picChange" type="button">사진 변경</button>
						</div>
						<div class="otherBtnBox hide">
							<button id="picker2" type="button">앨범에서 추가</button>
							<button id="camera" type="button">카메라에서 추가</button>
						</div>
							<input type="hidden" name="muuid" class="muuid" value="${sessionScope.muuid }">
							<div class="bwriteBtnBox hide">
								<button type="button" id="bwriteButton">변경 완료</button>
							</div>
				</div>
				
				
			<div class="form-floating" id="nicknameDIV">
				<input class="form-control" id="newNickname" value="${nickname}">
			</div>
				<button id="nickChangeBtn" onclick="nickChange()">닉네임 변경</button>
		</div>

	</section>
	<!-- Footer-->
	 <footer id="footer">
            <div class="container">
	            <ul class="menubar">
	            	<li onclick="location.href='../'"><img src="../img/home.png" class="footericon" alt="home"><div id="menu">홈</div></li>
	            	<li onclick="location.href='#'"><img src="../img/chat.png" class="footericon" alt="chat"><div id="menu">채팅</div></li>
	            	<li onclick="location.href='../mypage'"><img src="../img/mypage.png" class="footericon" alt="mypage"><div id="menu">마이페이지</div></li>
	            </ul>
            </div>
        </footer>
	<!-- Bootstrap core JS-->
	<script src="../js/jquery-3.7.0.min.js"></script>
	<script src="../js/mypage.js"></script>
</body>
</html>
