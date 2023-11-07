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
        
    </head>
    <body>
    <%@ include file="menubar.jsp" %>
    

		<!-- Section-->
		<section class="py-5">
			<div class="container px-4 px-lg-5 mt-5" style="z-index: 10" id="productContainer">
				<div class="justify-content-center">
				</div>
			</div>
		</section>
        
        
        <div class="page" id="page0">
        ${auctionItemDetail }
        <c:if test="${auctionItemDetail.isItemSeller eq false}">
        <c:if test="${auctionItemDetail.isCurrentBidder eq false}">

        	<input type="hidden" id="tno" value="${auctionItemDetail.tno }">

        	<div>
	        	<input type="number" id="bidPrice" name="bidPrice" placeholder="${auctionItemDetail.minBidPrice }">
    		</div>
			<div>
				<button id="biddingButton" onclick="bidding()" disabled="disabled">입찰</button>
			</div>

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
