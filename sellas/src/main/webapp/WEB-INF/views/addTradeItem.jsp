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
	<%@ include file="menubar.jsp" %>
		<!-- Section-->
		<section class="py-5">
			<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
				<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
				</div>
			</div>
		</section>
        
        
        <form action="./addTradeItem" method="post">
        
		<div>
		
			<div>카테고리
				<select name="category">
				<c:forEach var="itemCategory" items="${itemCategory}">
					<option value="${itemCategory.key }">${itemCategory.value}</option>
				</c:forEach>
				</select>
			</div>
			
			<div>제목
				<input type="text" name="title" maxlength="50" required="required">
			</div>
			
			<div>내용
				<textarea name="content" required="required"></textarea>
			</div>
			
			<div>
				<!-- TODO : 이미지 파일 업로드 추가 -->
			</div>
			
			<div>거래타입
				<button type="button" id="type0" onclick="selectTradeType('0')" disabled="disabled">일반</button>
				<button type="button" id="type1" onclick="selectTradeType('1')">경매</button>
				<input type="hidden" id="tradeType" name="tradeType" value="0">
			</div>
			
			<div class="page" id="page0">일반거래
				<div>
					<input type="number" id="normalPrice" name="normalPrice" step="100">
				</div>
			</div>
			
			<div class="page" id="page1" style="display:none">경매거래
				<div>
					<input type="number" id="auctionStartPrice" name="auctionStartPrice" step="100">
					<input type="number" id="auctionMinBidUnit" name="auctionMinBidUnit" step="100">
				</div>
			</div>
			
			<button type="submit">확인</button>
			
		</div>
		
		</form>
        
		<!-- Bootstrap core JS-->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		<!-- Core theme JS-->
		<script src="js/addTradeItem.js"></script>
	</body>
</html>
