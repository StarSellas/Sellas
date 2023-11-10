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
<link rel="stylesheet" href="../css/profile.css">

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
				<div class="back col-auto" onclick="location.href='/mypage'">
					<i class="xi-angle-left xi-x"></i>
				</div>
				<div class="location col">프로필</div>
			</div>
			<div class="nav">
				<div class="user-img">
					<img src="../img/흰배경셀라스.jpg" alt="user-img" class="user-img-img">
				</div>
				<div class="user-nickname">${nickname}</div>
				<div class="user-level">
					<c:if test="${exp < 30}">아기고래</c:if>
					<c:if test="${exp >= 30 && exp <= 70}">고래</c:if>
					<c:if test="${exp > 70}">슈퍼고래</c:if>
				</div>
				<button class=profile onclick="window.location.href='profileEdit/${sessionScope.muuid}'">프로필수정</button>
	
			
			
			</div>
			<div class="experience-section"
				style="position: relative; margin-top: 100px;">
				<span class="rabel">🐳경험치</span>
				<div class="progress" role="progressbar"
					aria-label="Example with label"
					aria-valuenow="${(exp) * 100}" aria-valuemin="0"
					aria-valuemax="100">
					<div class="progress-bar" style="width: ${exp}%; background-color: #88abff;">${exp}%</div>
				</div>
			</div>
			
			<div class="reviewList">
			<div class="rabel">받은 거래 후기</div>
			<div class="review-div">
			<div>
			<c:forEach items="${profileReview}" var="review">
			<div class="movedetail" onclick="location.href='./reviewDetail?rno=${review.rno}'">
							<div class="reviewimg">
					<img src="../img/흰배경셀라스.jpg" alt="user-img" class="user-img-img">
				</div>
			<div class=nickname>${review.mnickname}</div>
			<div class="content">${review.rcontent}</div>
			<div class="date">${review.rdate}</div>
			</div>
			</c:forEach>
				</div>
			</div>
		</div>
		</div>

	</section>
	<!-- Footer-->
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/scripts.js">
		
	</script>
</body>
</html>
