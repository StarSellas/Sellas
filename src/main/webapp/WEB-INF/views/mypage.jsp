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
<link href="css/styles.css" rel="stylesheet" />

<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
	href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet" href="./css/mypage.css">

</head>
<body>
	<!-- Navigation-->
	<nav class="navbar navbar-expand-lg navbar-light bg-light"
		style="z-index: 10">
		<div class="container px-4 px-lg-5">
			<a class="navbar-brand" href="#!">SellAS</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="#!">Home</a></li>
					<li class="nav-item"><a class="nav-link" href="#!">About</a></li>
					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
						role="button" data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="#!">All Products</a></li>
							<li><hr class="dropdown-divider" /></li>
							<li><a class="dropdown-item" href="#!">Popular Items</a></li>
							<li><a class="dropdown-item" href="#!">New Arrivals</a></li>
						</ul></li>
				</ul>
				<form class="d-flex">
					<button class="btn btn-outline-dark" type="submit">
						<i class="bi-cart-fill me-1"></i> Cart <span
							class="badge bg-dark text-white ms-1 rounded-pill">0</span>
					</button>
				</form>
			</div>
		</div>
	</nav>
	<!-- Header-->
	<header> </header>
	<!-- Section-->
	<section class="py-5">

		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">

			<div class="nav">
				<div class="user-img">
					<img src="../img/흰배경셀라스.jpg" alt="user-img" class="user-img-img">
				</div>
				<div class="user-nickname">${nickname}</div>
				<div class="user-level">
				<c:if test="${exp < 15}">아기고래</c:if>
								<c:if test="${exp >= 15 && exp <= 20}">고래</c:if>
								<c:if test="${exp > 20 }">슈퍼고래</c:if>
				</div>

				<button class=profile onclick="window.location.href='profile'">프로필보기</button>
			</div>
		</div>
		    <div class="card">
        <div class="card-body">
            <p class="card-text">여기가 웨일페이충전구역임</p>
        </div>
        </div>
		        <h6>나의 거래</h6>
		<div class="movedetail">
<div class="listdiv" onclick="location.href='./getwish'">
❤️ 위시리스트
</div>
<div class="listdiv" onclick="location.href='./getsell'">
📃 판매내역
</div>
<div class="listdiv" onclick="location.href='./getbuy'">
🧺 구매내역
</div>
<div class="listdiv" onclick="location.href='./getaction'">
⌛ 경매내역
</div>
</div>
		        <h6>나의 활동</h6>
		<div class="movedetail">
<div class="listdiv" onclick="location.href='./getwish'">
📝 활동내역
</div>
</div>





	</section>
	<!-- Footer-->
        <footer id="footer">
            <div class="container">
	            <ul class="menubar">
	            	<li><i class="xi-home xi-2x"></i><div id="menu">홈</div></li>
	            	<li><i class="xi-message xi-2x"></i><div id="menu">채팅</div></li>
	            	<li><i class="xi-profile xi-2x"></i><div id="menu">마이페이지</div></li>
	            </ul>
            </div>
        </footer>
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/scripts.js"></script>
</body>
</html>
