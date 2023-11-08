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
<script src="./js/jquery-3.7.0.min.js"></script>


<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
	href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet" href="../css/profile.css">

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
			<div class="d-flex inside-bar align-items-center">
				<div class="back col-auto" onclick="location.href='/'">
				<a href="javascript:history.back()"><i class="xi-angle-left xi-x"></i></a>
				</div>
				<div class="location col">${sessionScope.mnickname}님의 활동내역</div>
			</div>
			
		<div class="index">	
		<ul class="uldix">
			<li class="my showPostList on">내 글 보기</li>
			<li class="my showCommentList">내 댓글보기</li>
		</ul>
		</div>
		
			<div class="postList">
			<div class="rabel">내글목록</div>
			<div class="review-div">
			<div>


<c:forEach items="${myPost}" var="p">
			<div class="movedetail" onclick="location.href='./boardDetail?cate=${p.sno}&bno=${p.bno }'">
			<div class=>${p.sno}</div>
			<div class="btitle">${p.btitle}</div>
			<div class="bdate">${p.bdate}</div>
			<div class="commentcount">${p.commentcount}</div>
				</div>
			</c:forEach>
			</div>
				</div>
			</div>
			
			<div class="commentList">
				<div class="rabel">내 댓글 목록</div>

			<c:forEach items="${myComment}" var="c">
			<div class="movedetail" onclick="location.href='./boardDetail?cate=${p.sno}&bno=${c.bno }'">
			<div class=>${c.bno}</div>
			<div class=>${c.sno}</div>
			<div class="btitle">${c.ccontent}</div>
			<div class="bdate">${c.cdate}</div>
				</div>
			</c:forEach>
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
	<script>
	$(function() {
		
		$(".commentList").hide();
	
	$(".my").click(function() {
		alert("!");
	
		$(this).addClass("on");
		$(this).siblings("li").removeClass("on");
		if ($(this).hasClass("showPostList")) {
			$(".postList").show();
			$(".commentList").hide();
		} else if ($(this).hasClass("showCommentList")) {
			$(".postList").hide();
			$(".commentList").show();
		}
	})
	});
	</script>
</body>
</html>
