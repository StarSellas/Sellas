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
		<link href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css" rel="stylesheet" >
		<link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet"  />
		<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a5bf13cc97cefa4fa07aebcc296ef6b7&libraries=services,clusterer,drawing"></script>
	</head>
	<body>
	<%@ include file="menubar.jsp" %>


		<div class="page" id="page1">

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

		<div class="swiper">
			<div class="swiper-wrapper">
				<c:choose>
				<c:when test="${auctionImageList ne null}">
					<c:forEach items="${auctionImageList }" var="i">
						<div class="swiper-slide text-center">
							<img class="rounded" src="./tradeImgUpload/${i.timage}" alt="detailImage" width="275px" height="275px">
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="swiper-slide">
						<div class="text-center">
							<img class="rounded" src="./tradeImgUpload/defaultimg.jpg" alt="" width="275px" height="275px">
						</div>
					</div>
				</c:otherwise>
				</c:choose>
			</div>	
			<div class="swiper-pagination"></div>
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
				<div id="">${auctionItemDetail.minBidPrice }</div>
			</div>
		</div>

		<c:if test="${sessionScope.muuid ne null }">
			<c:if test="${auctionItemDetail.isItemSeller eq false}">
				<c:choose>
				<c:when test="${auctionItemDetail.isCurrentBidder eq false}">

					<input type="hidden" id="tno" value="${auctionItemDetail.tno }">

					<div class="form-floating">
						<input class="form-control" type="number" id="bidPrice" name="bidPrice" placeholder="입찰가격" min="${auctionItemDetail.minBidPrice }" max="999999999">
						<label for="bidPrice">입찰가격</label>
					</div>
					<div class="form-floating" id="errorDiv">
						<div id="errorMessage"><span style="visibility: hidden;">:</span></div>
					</div>
					<div class="form-floating" id="guideDiv">
						<div id="guideMessage"><a id="guideText" href="./fillPay" style="visibility: hidden;">충전하기</a></div>
					</div>
					<div class="form-floating">
						<button id="biddingButton" onclick="bidding()" disabled="disabled">입찰</button>
					</div>

				</c:when>
				<c:otherwise>

					<div class="form-floating">
						<div class="stateMessage">최고가 입찰중인 물품입니다.</div>
					</div>
					
				</c:otherwise>
				</c:choose>
			</c:if>
		</c:if>
		
		
		<button onclick="showPage('page0')">0000</button>
		<button onclick="showPage('page2')">2222</button>
		<button onclick="showPage('page3')">3333</button>
		<button onclick="showPage('page4')">4444</button>
		

		</div>

		<div class="page resultPage" id="page0" style="display:none">
			<div class="form-floating">
				<a href="#" onclick="window.location.reload();"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
			</div>

			<div class="form-floating">
				<div class="resultTitleT">입찰성공</div>
			</div>		
			<!-- div class="form-floating textDiv">
				<div class="resultText">입찰에 성공했습니다.</div>
			</div -->
			<div class="form-floating bidSuccessInfo">
				<div class="form-floating textDiv bidITemInfo">
						입찰물품 : ${auctionItemDetail.ttitle }
				</div>
				<div class="form-floating textDiv bidITemInfo" id="bidPriceDiv">
				</div>
			</div>
			<div class="form-floating">
				<button class="endTypeButton" onclick="window.location.href = '/auctionDetail?tno='+${auctionItemDetail.tno }">확인</button>
			</div>
		</div>

		<div class="page resultPage" id="page2" style="display:none">
			<div class="form-floating">
				<a href="./login"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
			</div>

			<div class="form-floating">	
				<div class="resultTitleF">입찰실패</div>
			</div>
			<div class="form-floating textDiv">
				<div class="resultText">로그인 세션이 만료되었습니다.</div>
			</div>
			<div class="form-floating textDiv">
				<div class="resultText">로그인 후 다시 시도해주세요.</div>
			</div>
			<div class="form-floating">
				<button class="endTypeButton" onclick="window.location.href = '/login'">확인</button>
			</div>
		</div>

		<div class="page resultPage" id="page3" style="display:none">

			<div class="form-floating">
				<a href="#" onclick="window.location.reload();"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
			</div>

			<div class="form-floating">
				<div class="resultTitleF">입찰실패</div>
			</div>
			<div class="form-floating textDiv">
				<div class="resultText">입찰 가격은 최소입찰가보다 높아야 합니다.</div>
			</div>
			<div class="form-floating">
				<button class="endTypeButton" onclick="window.location.href = '/auctionDetail?tno='+${auctionItemDetail.tno }">확인</button>
			</div>
		</div>

		<div class="page resultPage" id="page4" style="display:none">
			<div class="form-floating">
				<a href="#" onclick="window.location.reload();"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
			</div>

			<div class="form-floating">
				<div class="resultTitleF">입찰실패</div>
			</div>
			<div class="form-floating textDiv">
				<div class="resultText">잔액이 부족합니다.</div>
			</div>
			<div class="form-floating textDiv">
				<div class="resultText">충전 후 다시 시도해주세요.</div>
			</div>
			<div class="form-floating">
				<button class="endTypeButton" onclick="window.location.href = '/fillPay'">확인</button>
			</div>
		</div>

		

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="js/auctionDetail.js"></script>
	
		<script type="text/javascript">
		/* 이미지 */
		document.addEventListener('DOMContentLoaded', function() {
			const swiper = new Swiper('.swiper', {
				pagination: {
					el: '.swiper-pagination',
				},
				navigation: {
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',
				},
			});
		});
		</script>

	</body>

</html>
