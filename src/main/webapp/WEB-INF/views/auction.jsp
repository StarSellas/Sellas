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
		<link href="css/menu.css" rel="stylesheet">
		<link href="css/auction.css" rel="stylesheet">

		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="./js/jquery-3.7.0.min.js"></script>
	</head>
	<body>
	<%@ include file="menubar.jsp" %>


		<div class="auctionDiv">

		<div class="container mt-3">
		<div class="d-flex justify-content-between align-items-center">

		<input type="text" id="keyword" value="">
		<button id="search">검색</button>

		</div>
		</div>

		<!-- 카테고리 필터 -->

		<div class="categoryFilter" id="categoryFilter" >
		<div class="categoryList">
			<span>카테고리</span>
			<span class="closeCategoryFilter" id="closeCategoryFilter">&times;</span>
			<c:forEach var="itemCategory" items="${itemCategory}">
				<div>
					<button class="categoryButton activated" id="categoryButton${itemCategory.key }" onclick="applyCategoryFilter(${itemCategory.key })">${itemCategory.value }</button>
				</div>
			</c:forEach>
		</div>
		</div>

		<div class="container mt-3">
		<div class="d-flex justify-content-between align-items-center">

		<!-- 정렬 기준 -->
		<input type="hidden" id="sortOption" value="">

		<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
			<li class="nav-item dropdown">
				<a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">정렬기준</a>
				<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
					<li><a class="dropdown-item" href="#" onclick="setSortOption('priceDESC')">가격 높은순</a></li>
					<li><hr class="dropdown-divider" /></li>
					<li><a class="dropdown-item" href="#" onclick="setSortOption('priceASC')">가격 낮은순</a></li>
					<li><hr class="dropdown-divider" /></li>
					<li><a class="dropdown-item" href="#" onclick="setSortOption('readDESC')">조회순</a></li>
				</ul>
			</li>
		</ul>

		<button id="openCategoryFilter">카테고리</button>

		</div>
		</div>

		<input type="hidden" id="page" value="0">

		<div id="auctionItemListDiv"></div>

		</div>

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="js/auction.js"></script>

	</body>

</html>
