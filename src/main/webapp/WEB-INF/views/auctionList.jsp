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
<script src="./js/jquery-3.7.0.min.js"></script>


<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
   href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet" href="../css/auctionList.css">

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
            <div class="location col">${sessionScope.mnickname}님의 경매내역</div>
         </div>
         
      <div class="index">   
      <ul class="uldix">
         <li class="my showPostList on">판매 내역</li>
         <li class="my showCommentList">구매 내역</li>
      </ul>
      </div>
         <div class="postList">
         <div class="activities-div">
         <c:forEach items="${aucSellList}" var="row">
         <div class="movedetail" onclick="location.href='./auctionDetail?tno=${row.tno}'">
         <div class="timage">
             <c:choose>
    <c:when test="${row.timage ne null}">
      <img src="../tradeImgUpload/${row.timage}" alt="물품사진" width="130px" height="130px">
    </c:when>
    <c:otherwise>
      <img src="../tradeImgUpload/defaultimg.jpg"  alt="기본사진" width="130px" height="130px" />
    </c:otherwise>
      </c:choose>
         </div>
         <div class="auctionInfo">
         <div class="btitle">${row.ttitle}</div>
         <div class="bdate">${row.displayDate}</div>
         <div class="price">
         <div class="startprice">시작가
         <div>
          <fmt:formatNumber value="${row.tauctionstartprice}" pattern="#,###원"/>
         </div>
         </div>
      <div class="lastprice">현재 입찰가
         <c:if test="${row.abidprice ne null}">
         <div>
          <fmt:formatNumber value="${row.abidprice}" pattern="#,###원"/>
          </div>
         </c:if>
         <c:if test="${row.abidprice eq null}">
          <div>입찰이 없어요</div>
         </c:if>
         </div>
            </div> <!--price 끝  -->
      <div class="setup">
    <c:choose>
        <c:when test="${row.tauctionstate eq 0}">
            <span style="color: #88abff;">낙찰</span>
        </c:when>
        <c:when test="${row.tauctionstate eq 1}">
            <span style="color: gray;">유찰</span>
        </c:when>
        <c:when test="${row.tauctionstate eq 2}">
            <span style="color: green;">진행중</span>
        </c:when>
    </c:choose>
</div>
         </div>
         </div><!--경매정보info  -->
         </c:forEach>
            </div>
         </div>
         <div class="commentList">
         <c:forEach items="${aucBuyList}" var="row">
         <div class="movedetail" onclick="location.href='./auctionDetail?tno=${row.tno}'">
            <div class="timage">
             <c:choose>
    <c:when test="${row.timage ne null}">
      <img src="../tradeImgUpload/${row.timage}" alt="물품사진" width="130px" height="130px">
    </c:when>
    <c:otherwise>
      <img src="../tradeImgUpload/defaultimg.jpg"  alt="기본사진" width="130px" height="130px" />
    </c:otherwise>
      </c:choose>
         </div>
         <div class="auctionInfo">
         <div class="btitle">${row.ttitle}</div>
         <div class="bdate">${row.displayDate}</div>
         <div class="price2">
         <fmt:formatNumber value="${row.abidprice}" pattern="#,###원"/>
         </div>
         <div class="setup">
         <c:if test="${row.astate eq 0}">
          <span style="color: #88abff;">낙찰</span>
         </c:if>
         <c:if test="${row.astate eq 1}">
          <span style="color: tomato;">미낙찰</span>
         </c:if>
         <c:if test="${row.astate eq 2}">
          <span style="color: green;">최고가입찰</span>
         </c:if>
            </div>
         </div>
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
   $(function() {
      
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
   })
   });
   </script>
</body>
</html>