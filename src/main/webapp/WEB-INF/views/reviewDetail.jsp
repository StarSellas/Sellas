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
<link rel="stylesheet" href="../css/reviewDetail.css">

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
				<div class="location col">거래후기</div>
				</div>
			</div>
			
	<div class="review-box">
    <img src="../img/흰배경셀라스.jpg" alt="logo" class="logo">
    <c:choose>
<c:when test="${reviewDetail.mwriter != null && reviewDetail.mtarget != null}">
    <c:if test="${reviewDetail.mtarget eq sessionScope.muuid}">
    <div><h5>${reviewDetail.writer_nickname}님이 보낸 후기</h5></div>
    </c:if>
    <c:if test="${reviewDetail.mtarget ne sessionScope.muuid}">
    <div><h5>내가 ${reviewDetail.target_nickname}님에게 보낸 후기</h5></div>
    </c:if>
    <br>
    <div>
        <c:if test="${reviewDetail.mtarget eq sessionScope.muuid}">
        <h6>${reviewDetail.writer_nickname}님과 거래한 물품은</h6>
        <h6>[${reviewDetail.ttitle}]입니다</h6>
           </c:if>
             <c:if test="${reviewDetail.mtarget ne sessionScope.muuid}">
                <h6>${reviewDetail.target_nickname}님과 거래한 물품은</h6>
        <h6>[${reviewDetail.ttitle}]입니다</h6>
        </c:if>
    </div>
       <br>
    <div class="card">
        <div class="card-body">
            <p class="card-text">${reviewDetail.rcontent}</p>
        </div>
    </div>
    </c:when>
    <c:otherwise>
    <div class="notYet">
    아직 후기를 받지 않았어요. 기다려주세요.
    </div>
    </c:otherwise>
    </c:choose>
<div>
  <c:if test="${reviewDetail.mtarget eq sessionScope.muuid && reviewDetail.hastno == 'Y'}">
<button id="reviewBtn" class="submitbtn" type="button"
onclick="location.href='./reviewDetailByMe?rno=${reviewDetail.rno}'">내가 쓴 후기 보러가기</button>
</c:if>
  <c:if test="${reviewDetail.mtarget eq sessionScope.muuid && reviewDetail.hastno != 'Y'}">
<button id="reviewBtn" class="submitbtn" type="button"
onclick="location.href='./review?tno=${reviewDetail.tno}'">나도 후기 쓰러가기</button>
</c:if>
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
