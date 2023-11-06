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
        <!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light" style="z-index: 10">
           <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="./">SellAS</a>
				<button class="navbar-toggler" type="button" data-bs-target="" aria-controls="navbarSupportedContent"><a href="/menu"><img src="../img/menuIcon.png" id="menuIcon" alt="menuIcon"></a></button>
           </div>
        </nav>
	<!-- Header-->
		<header>

		</header>
		<!-- Section-->
		<section class="py-5">
			<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
				<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
				</div>
			</div>
		</section>
        
        
		<div class="page" id="page1">
			<div>
				<input type="text" id="id" name="id" placeholder="아이디" maxlength="15" required="required"> 	
			</div>
			<div>
				<input type="text" id="email" name="email" placeholder="이메일 주소" maxlength="36" required="required">
				<div id="emailMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<button onclick="showEmailCodeDiv()">다음</button>
			<div>
				<a href="./findid">아이디 찾기</a>
				<span style="border-left: 1px solid #ccc;height: 12px;margin: 0 10px;"></span>
				<a href="./login">로그인</a>
			</div>
		</div>
		
		<div class="page" id="page2" style="display:none">
			<div id="idDiv">ID</div>
			<div id="emailDiv">EMAIL</div>
			<div id="emailCodeDiv">
				<input type="text" id="emailCode" placeholder="인증번호 입력" maxlength="16" required="required">
				<button type="button" id="sendCode" onclick="sendVerificationCode()">재요청</button>
				<button type="button" id="checkCode" onclick="validateEmailCode()">확인</button>
				<div id="emailCodeMessage"><span style="visibility: hidden;">:</span></div>
			</div>
		</div>
		
		<div class="page" id="page3" style="display:none">
			<div>	
				<input type="password" id="pw" name="pw" placeholder="비밀번호" maxlength="15" required="required">
				<div id="pwMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<div>
				<input type="password" id="pwcheck" placeholder="비밀번호 확인" maxlength="15" required="required">
				<div id="pwcheckMessage"><span style="visibility: hidden;">:</span></div>
			</div>
			<button id="changePasswordButton" onclick="changePassword()" disabled="disabled">확인</button>
		</div>
		
		<div class="page" id="page4" style="display:none">
			<div>
				<a href="./login">로그인</a>
			</div>
		</div>
        
		<!-- Bootstrap core JS-->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		<!-- Core theme JS-->
		<script src="js/findpw.js"></script>
	</body>
</html>
