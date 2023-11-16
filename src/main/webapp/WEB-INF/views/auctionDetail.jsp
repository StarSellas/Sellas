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
		<link href="css/auctionDetail.css" rel="stylesheet" />

		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">

		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a5bf13cc97cefa4fa07aebcc296ef6b7&libraries=services,clusterer,drawing"></script>
	</head>
	<body>
	<%@ include file="menubar.jsp" %>


		<div class="page" id="page0">

		<div class="form-floating">
			<div id="title">${auctionItemDetail.ttitle }</div>
			<div>
				<div id="category">${auctionItemDetail.iname }</div>
				<div id="read">${auctionItemDetail.tread }</div>
			</div>
		</div>

		<div class="form-floating">
			<div id="nickname">${auctionItemDetail.mnickname }</div>
			<div id="date">${auctionItemDetail.startDate }</div>
		</div>
		
		<div class="form-floating">
			<div class="divider"></div>
		</div>

		<div class="form-floating">
			<div>사진</div>
		</div>

		<div class="form-floating">
			<div id="content">${auctionItemDetail.tcontent }</div>
		</div>


		<div class="form-floating">
			<div id="map" style="width: 100%; height: 200px"></div>
			<input type="hidden" id="lat" value="${auctionItemDetail.tlocationlat }">
			<input type="hidden" id="lng" value="${auctionItemDetail.tlocationlng }">
		</div>
		
		<div class="form-floating">
			<div class="divider"></div>
		</div>

		<div class="form-floating">
			<div id="startPrice">
				<div id="">경매시작가</div>
				<div id="">${auctionItemDetail.tauctionstartprice }</div>
			</div>
			<div id="currentPrice">
				<div id="">현재입찰가</div>
				<div id="">${auctionItemDetail.abidprice }</div>
			</div>
			<div id="minimumPrice">
				<div id="">최소입찰가</div>
				<div id="">${auctionItemDetail.minbidprice }</div>
			</div>
		</div>

		<c:if test="${sessionScope.muuid ne null }">
			<c:if test="${auctionItemDetail.isItemSeller eq false}">
				<c:if test="${auctionItemDetail.isCurrentBidder eq false}">

					<input type="hidden" id="tno" value="${auctionItemDetail.tno }">

					<div class="form-floating">
						<input class="form-control" type="number" id="bidPrice" name="bidPrice" placeholder="${auctionItemDetail.minBidPrice }">
						<label for="bidPrice">입찰가격</label>
					</div>

					<div class="form-floating">
						<button class="endTypeButton" id="biddingButton" onclick="bidding()" disabled="disabled">입찰</button>
					</div>

				</c:if>
			</c:if>
		</c:if>

		</div>

		<div class="page" id="page1" style="display:none">
			<h1>입찰성공</h1>
			<button onclick="window.location.href = '/auctionDetail?tno='+${auctionItemDetail.tno }">확인</button>
		</div>

		<div class="page" id="page2" style="display:none">
			<h1>로그인 세션 만료</h1>
			<button onclick="window.location.href = '/auctionDetail?tno='+${auctionItemDetail.tno }">확인</button>
		</div>

		<div class="page" id="page3" style="display:none">
			<h1>최소입찰가격 확인</h1>
			<button onclick="window.location.href = '/auctionDetail?tno='+${auctionItemDetail.tno }">확인</button>
		</div>

		<div class="page" id="page4" style="display:none">
			<h1>잔액부족</h1>
			<button onclick="window.location.href = '/auctionDetail?tno='+${auctionItemDetail.tno }">확인</button>
		</div>


		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="js/auctionDetail.js"></script>
	</body>
</html>
