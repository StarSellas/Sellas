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
		<link href="css/addTradeLocation.css" rel="stylesheet" />

		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="./js/jquery-3.7.0.min.js"></script>

		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a5bf13cc97cefa4fa07aebcc296ef6b7&libraries=services,clusterer,drawing"></script>
	</head>
	<body>
	<%@ include file="menubar.jsp" %>


		<div class="page" id="page1">
			<div class="form-floating">
				<div id="map" style="width: 380px; height: 350px;"></div>
			</div>

			<div class="form-floating">
				<button type="button" onclick="markingCurrentLocation()">현재 위치로 설정하기</button>
			</div>

			<input type="hidden" id="locationLat">
			<input type="hidden" id="locationLng">

			<div class="form-floating">
				<input class="form-control" id="locationName" placeholder="장소 이름" maxlength="10" required="required">
				<label for="locationName">장소 이름</label>
			</div>

			<div class="form-floating">
				<button class="endTypeButton" type="button" onclick="addTradeLocation()">확인</button>
			</div>
			
			
		</div>

		<div class="page resultPage" id="page2" style="display:none">
			<div class="form-floating">
				<a href="#" onclick="window.location.reload();"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
			</div>
			<div class="form-floating">
				<div class="resultTitleT">정상적으로 등록되었습니다.</div>
			</div>
			<div class="form-floating">
				<div id="resultMap" style="width: 380px; height: 220px;"></div>
			</div>
			<div class="form-floating">
				<div id="resultName"></div>
			</div>
			<div class="form-floating">
				<button class="endTypeButton" type="button" onclick="javascript:history.back()">확인</button>
			</div>
		</div>

		<div class="page resultPage" id="page3" style="display:none">
			<div class="form-floating">
				<a href="#" onclick="window.location.reload();"><img src="./img/sellastext.png" class="sellasText" alt=""></a>
			</div>
			<div class="form-floating">
				<div class="resultTitleF">등록이 실패했습니다.</div>
			</div>
			<div class="form-floating">
				<button class="endTypeButton resultButton" type="button" onclick="showPage('page1')">확인</button>
			</div>
		</div>


		<!-- Core theme JS-->
		<script src="js/addTradeLocation.js"></script>

	</body>

</html>
