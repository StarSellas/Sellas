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
<link rel="stylesheet" href="./css/mypage.css">

</head>
<body>
<script>
    $(document).ready(function() {
        let error = '${error}';
        if (error !== '') {
            alert(error);
        }
    });
</script>
	<!-- Navigation-->
	 <%@ include file="menubar.jsp" %>
	<!-- Header-->
	<header> </header>
	<!-- Section-->
	<section class="py-5">

		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">

			<div class="nav">
				<div class="user-img">
					<img src="../userImgUpload/${mphoto}" alt="user-img" class="user-img-img">
				</div>
				<div class="user-nickname">${nickname}</div>
				<div class="user-level">
				<c:if test="${exp < 30}">아기고래</c:if>
								<c:if test="${exp >= 30 && exp <= 70}">고래</c:if>
								<c:if test="${exp > 70 }">슈퍼고래</c:if>
				</div>
<div class="profilediv">
				<button class=profile onclick="window.location.href='profile'">프로필보기</button>
			</div>
			</div>
		</div>
		    <div class="card pay">
            <div class="payname">WhalePay</div>
        <div class="row1">
            <div class="balance"><fmt:formatNumber value="${mbalance}" pattern="#,###원"/></div>
                 <button class="movefill" onclick="location.href='./fillPay'"> 충전</button>
        </div>
        </div>
 
		        <h6>나의 거래</h6>
		<div class="movedetail">
<div class="listdiv" onclick="location.href='./getwish'">
❤️ 위시리스트
</div>
<div class="listdiv" onclick="location.href='./getsell'">
📃 판매내역
</div>
<div class="listdiv" onclick="location.href='./getbuy'">
🧺 구매내역
</div>
<div class="listdiv" onclick="location.href='./getauction'">
⌛ 경매내역
</div>
</div>
		        <h6>나의 활동</h6>
		<div class="movedetail">
<div class="listdiv" onclick="location.href='./myActivities'">
📝 활동내역
</div>
</div>


  <h6 class="logout" onclick="location.href='./logout'">로그아웃</h6>





	</section>
	<!-- Footer-->

	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/scripts.js"></script>
</body>
</html>
