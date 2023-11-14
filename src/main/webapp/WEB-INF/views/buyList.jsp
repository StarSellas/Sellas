<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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
<link rel="stylesheet" href="./css/mypageList.css">
<script src="./js/jquery-3.7.0.min.js"></script>
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
				<div class="location col">구매내역</div>
			</div>
			<div class="nav">

			<c:forEach items="${buyList}" var="row">
	<c:choose>
<c:when test="${fn:length(buyList) gt 0 && row.hastno eq null}">
<div class="card mb-3" style="width: 330px;">
  <div class="row g-0" onclick="location.href='./normalDetail?tno=${row.tno}'">
    <div class="col-4">
      <img src="./tradeImgUpload/${row.timage}" id="timage" class="img-fluid custom-rounded-start object-fit-cover" alt="물품이미지">
    </div>
    <div class="col-8">
      <div class="card-body">
        <input type="hidden" value="${row.tno}">
        <h5 class="card-title">${row.ttitle}</h5>
		<p class="card-text">
  <p class="card-text">
        <fmt:formatNumber value="${row.tnormalprice}" pattern="#,###원"/>
    </p>
    <p class="card-text">
        <small class="text-body-secondary">
   ${row.displayDate}
        </small>
    </p>
<%--     ${row.hastno}
    ${row.writeYN} --%>
      </div>
    </div>
  </div>
<!--   버튼 -->
<c:choose>
<c:when test="${row.tnormalstate == 2}">
<c:choose>
    <c:when test="${row.rno == null}">
       <button id="reviewBtn" class="submitbtn reviewBtn" type="button" onclick="location.href='./review?tno=${row.tno}'">후기 작성하기</button>
    </c:when>
    <c:when test="${row.rno != null && row.writeYN == 'Y'}">
            <button id="reviewDetailBtn" class="submitbtn reviewDetailBtn" type="button" onclick="location.href='./reviewDetail?rno=${row.rno}'">후기 보러가기</button>
    </c:when>
    <c:when test="${row.rno != null && row.writeYN != 'Y'}">
     <button id="reviewBtn" class="submitbtn reviewBtn" type="button" onclick="location.href='./review?tno=${row.tno}'">후기 작성하기</button>
    </c:when>
    <c:otherwise>
        <button id="reviewBtn" class="submitbtn reviewBtn" type="button" onclick="location.href='./review?tno=${row.tno}'">후기 작성하기</button>
    </c:otherwise>
    </c:choose>
</c:when>
<c:otherwise>
 <button id="reviewBtn" value="${row.tno}" class="submitbtn reviewBtn" type="button">글 숨기기</button>
</c:otherwise>
</c:choose>
</div>
<!--   버튼 -->
	 </c:when>

<c:when test="${fn:length(buyList) gt 0 && row.hastno eq 'Y' && row.writeYN eq 'Y'}">
    <div class="card" style="width: 330px;">
        <div class="row g-0" onclick="location.href='./normalDetail?tno=${row.tno}'">
            <div class="col-4">
                <img src="./tradeImgUpload/${row.timage}" class="img-fluid custom-rounded-start object-fit-cover" alt="...">
            </div>
            <div class="col-8">
                <div class="card-body">
                    <input type="hidden" value="${row.tno}">
                    <h5 class="card-title">${row.ttitle}</h5>
                    <p class="card-text">
                        <fmt:formatNumber value="${row.tnormalprice}" pattern="#,###원"/>
                    </p>
                    <p class="card-text">
                        <small class="text-body-secondary">
                             ${row.displayDate}
                        </small>
                    </p>
                </div>
            </div>
        </div>
        <!-- 버튼 -->
        <button id="reviewDetailBtn" class="submitbtn reviewDetailBtn" type="button" onclick="location.href='./reviewDetail?rno=${row.rno}'">후기보러가기</button>
    </div>
</c:when>
	 <c:when test="${fn:length(buyList) eq 0}">
	 구매 내역이 없어요.
	 </c:when>
	</c:choose>
		</c:forEach>
</div>
  </div>

	</section>

	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
<script>
</script>
</body>
</html>