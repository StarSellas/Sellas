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
				<div class="location col">판매내역</div>
			</div>
			<div class="nav">
			
					<div class="index">	
		<ul class="uldix">
			<li class="my showPostList on">판매중</li>
			<li class="my showCommentList">거래완료</li>
		</ul>
		</div>
		
			<c:forEach items="${sellList}" var="row">
<div class="postList">
<c:if test="${row.tnormalstate == 0}">
<div class="card" style="width: 330px;">
  <div class="row g-0" onclick="location.href='./normalDetail?tno=${row.tno}'">
    <div class="col-4">
    <c:choose>
    <c:when test="${row.timage ne null}">
      <img src="./tradeImgUpload/${row.timage}" id="timage" class="custom-rounded-start object-fit-cover" alt="물품이미지">
    </c:when>
    <c:otherwise>
      <img src="./tradeImgUpload/defaultimg.jpg" id="timage" class="custom-rounded-start object-fit-cover" alt="기본이미지" />
    </c:otherwise>
      </c:choose>
    </div>
    <div class="col-8">
      <div class="card-body">
        <input type="hidden" class="tno" value="${row.tno}">
        <h5 class="card-title">${row.ttitle}</h5>
    <p class="card-text">
        <small class="text-body-secondary tdate">
         ${row.displayDate}
        </small>
  <p class="card-text tprice">
        <fmt:formatNumber value="${row.tnormalprice}" pattern="#,###원"/>
    </p>
      </div>
    </div>
  </div>
  <!--버튼공간  -->
   <button id="reviewBtn" value="${row.tno}" class="normalDeleteBtn" type="button">글 숨기기</button>
  </div>
</c:if>
</div>


<!--안녕하세요~~~~거래완료입니다~~~~~~~~  -->
	<div class="commentList">
	<c:choose>
	<c:when test="${row.hastno eq null && row.tnormalstate == 2}">
	<div class="card" style="width: 330px;">
  <div class="row g-0" onclick="location.href='./normalDetail?tno=${row.tno}'">
    <div class="col-4">
    <c:choose>
    <c:when test="${row.timage ne null}">
      <img src="./tradeImgUpload/${row.timage}" id="timage" class="custom-rounded-start object-fit-cover" alt="물품이미지">
    </c:when>
    <c:otherwise>
      <img src="./tradeImgUpload/defaultimg.jpg" id="timage" class="custom-rounded-start object-fit-cover" alt="기본이미지" />
    </c:otherwise>
      </c:choose>
    </div>
    <div class="col-8">
      <div class="card-body">
        <input type="hidden" class="tno" value="${row.tno}">
        <h5 class="card-title">${row.ttitle}</h5>
		<p class="card-text">
    <p class="card-text tdate">
        <small class="text-body-secondary">
         ${row.displayDate}
        </small>
    </p>
  <p class="card-text tprice">
        <fmt:formatNumber value="${row.tnormalprice}" pattern="#,###원"/>
    </p>
      </div>
    </div>
  </div>
<!--   버튼 -->
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
    </c:choose>
</div>

	</c:when>

<c:when test="${row.hastno eq 'Y' && row.writeYN eq 'Y' &&  row.tnormalstate == 2}">
  <div class="card" style="width: 330px;">
        <div class="row g-0" onclick="location.href='./normalDetail?tno=${row.tno}'">
            <div class="col-4">
             <c:choose>
    <c:when test="${row.timage ne null}">
      <img src="./tradeImgUpload/${row.timage}" id="timage" class="img-fluid custom-rounded-start object-fit-cover" alt="물품이미지">
    </c:when>
    <c:otherwise>
      <img src="./tradeImgUpload/defaultimg.jpg" id="timage" class="img-fluid custom-rounded-start object-fit-cover" alt="기본이미지" />
    </c:otherwise>
      </c:choose>
            </div>
            <div class="col-8">
                <div class="card-body">
                    <input type="hidden" class="tno" value="${row.tno}">
                    <h5 class="card-title">${row.ttitle}</h5>
                    <p class="card-text tdate">
                        <small class="text-body-secondary">
                            ${row.displayDate}
                        </small>
                    </p>
                    <p class="card-text tprice">
                        <fmt:formatNumber value="${row.tnormalprice}" pattern="#,###원"/>
                    </p>

                
                </div>
            </div>
        </div>
        <!-- 버튼 -->
        <button id="reviewDetailBtn" class="submitbtn reviewDetailBtn" type="button" onclick="location.href='./reviewDetail?rno=${row.rno}'">후기 보러가기</button>
    </div>
</c:when>
  </c:choose>
	</div>
		</c:forEach>
  </div>
</div>

	</section>
	<!-- Footer-->
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
<script>
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
});


$(".normalDeleteBtn").click(function(){
	
	let tno = $(event.target).val();
	let uuid = '${sessionScope.muuid}';
	
	if(confirm("정말 삭제하시겠습니까?")){
		$.ajax({
			url : "normalDelete",
               type : "post",
               data : {tno : tno , muuid: uuid},
               dataType : "json",
               success:function(data){
            	   if(data.deleteSuccess == 1){
            		   M.pop.instance("삭제가 완료되었습니다.");
            		   window.location.reload();
            	   }
               },
               error:function(error){
            	   alert("실패");
               }
		});
	}
});

</script>
</body>
</html>