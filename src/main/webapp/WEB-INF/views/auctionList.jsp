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
<link rel="stylesheet" href="../css/myActivities.css">

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
		
			<div class="postList">
			<div class="activities-div">
<c:forEach items="${aucSellList}" var="p">
			<div class="movedetail" onclick="location.href='./auctionDetail?tno=${p.tno}'">
			<div class="btitle">${p.ttitle}</div>
			<div class="bdate">${p.displayDate}</div>
			<div class="timage"></div>
			<img src="../tradeImgUpload/${p.timage}" alt="sssdsd" class="sdsd" width="100px">
			<div class="row1">
			<div class="setup">
			<c:if test="${p.tauctionstate eq 0}">낙찰</c:if>
			<c:if test="${p.tauctionstate eq 2}">유찰</c:if>
			<c:if test="${p.tauctionstate eq 3}">진행중</c:if>
				</div>
			</div>
			<div class="ttitle">
			${p.ttitle}
			</div>
			</div>
			</c:forEach>
				</div>
			</div>
			
			<div class="commentList">
			<c:forEach items="${myComment}" var="c">
			<div class="movedetail" onclick="location.href='./boardDetail?cate=${p.sno}&bno=${c.bno }'">
			
			<div class="btitle">${c.ccontent}</div>
			<div class="bdate">${c.cdate}</div>
			<div class="row1">
			<div id="commentcount">${c.btitle}</div>
			<div class="setup">
			<c:if test="${c.sno eq 1}">공지사항</c:if>
			<c:if test="${c.sno eq 2}">판매요청</c:if>
			<c:if test="${c.sno eq 3}">나눔</c:if>
				</div>
			</div>
				</div>
			</c:forEach>
			</div>
			
			<c:if test="${exp < 15}">아기고래</c:if>
								<c:if test="${exp >= 15 && exp <= 20}">고래</c:if>
								<c:if test="${exp > 20 }">슈퍼고래</c:if>
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
