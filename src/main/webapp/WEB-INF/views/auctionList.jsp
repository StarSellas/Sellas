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
<link rel="stylesheet" href="../css/auctionList.css">

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
				<div class="back col-auto" onclick="location.href='/'">
				<a href="javascript:history.back()"><i class="xi-angle-left xi-x"></i></a>
				</div>
				<div class="location col">${sessionScope.mnickname}님의 경매내역</div>
			</div>
			
		<div class="index">	
		<ul class="uldix">
			<li class="my showPostList on">판매 내역</li>
			<li class="my showCommentList">구매 내역</li>
		</ul>
		</div>
		<!-- [{ttitle=경매 어떻게돌아가는거냐고, ino=4, timage=20231114101053e707b323756420cf89b21fb09efe397fc36a100d.jpeg.jpg
		tauctionstate=0, tread=6, tdate=2023-11-14T10:10:53, tno=301, ttype=1, displayDate=10시 10분, tauctionstartprice=52000000, tcontent=김민성이자식아, tauctionminbidunit=60000000, muuid=39e0ee63-43ef-4434-b676-3597d28ec217}] -->
			<div class="postList">
			<div class="activities-div">
			<c:forEach items="${aucSellList}" var="row">
			<div class="movedetail" onclick="location.href='./auctionDetail?tno=${p.tno}'">
			<div class="btitle">${row.ttitle}</div>
			<div class="bdate">${row.displayDate}</div>
			<div class="timage"></div>
			<img src="../tradeImgUpload/${row.timage}" alt="물품사진" width="130px" height="130px">
			<div class="row1">
			<div class="setup">
			<c:if test="${row.tauctionstate eq 0}">낙찰</c:if>
			<c:if test="${row.tauctionstate eq 2}">유찰</c:if>
			<c:if test="${row.tauctionstate eq 3}">진행중</c:if>
				</div>
			</div>
			<div class="ttitle">
			${p.ttitle}
			</div>
			<div>시작가
			 <fmt:formatNumber value="${p.tauctionstartprice}" pattern="#,###원"/>
			</div>
			<c:if test="${p.abidprice ne null}">현재 낙찰가
			 <fmt:formatNumber value="${p.abidprice}" pattern="#,###원"/>
			</c:if>
			</div>
			</c:forEach>
				</div>
			</div>
			<div class="commentList">
			<c:forEach items="${aucBuyList}" var="row">
			<div class="movedetail" onclick="location.href='./auctionDetail?tno=${c.tno}'">
			<div class="timage">
				<img src="../tradeImgUpload/${row.timage}" alt="물품사진" width="130px" height="130px">
			</div>
			<div class="auctionInfo">
			<div id="btitle">${row.ttitle}</div>
			<div class="bdate">${row.displayDate}</div>
			<div>
			       <fmt:formatNumber value="${row.abidprice}" pattern="#,###원"/>
			</div>
		
			<div class="setup">
			<c:if test="${row.astate eq 0}">낙찰</c:if>
			<c:if test="${row.astate eq 1}">미낙찰</c:if>
			<c:if test="${row.astate eq 2}">최고가입찰</c:if>
				</div>
			</div>
			</div>
			</c:forEach>
			
			</div>
			</div>


	</section>
	<!-- Footer-->
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script>
	$(function() {
		
		$(".commentList").hide();
	
	$(".my").click(function() {
	
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
