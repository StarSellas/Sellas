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
        
        <!-- ******************* 추가 *********************** -->
        <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
        
    </head>
    <body>
    <%@ include file="menubar.jsp" %>

        <!-- Section-->
        <section class="py-5">
        
            <div class="container px-4 px-lg-5 mt-5" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">

					<div class="boardMenuBox">
						<div><a href="/board">게시판</a></div>	
						 <ul class="boardMenu">
		                      <li><a href="/board?cate=1">공지사항</a></li>
		                      <li><a href="/board?cate=2">판매요청</a></li>
		                      <li><a href="/board?cate=3">나눔</a></li>
		                 </ul>
	                 </div>
	                 
	                 <div class="itemcategoryBox">
	                 <div><a href="/">카테고리</a></div>	
						 <ul class="itemcategory">
		                      <li><a href="/">디지털기기 / 가전</a></li>
		                      <li><a href="/">가구 / 인테리어</a></li>
		                      <li><a href="/">생활 / 주방</a></li>
		                      <li><a href="/">도서</a></li>
		                      <li><a href="/">티켓 / 교환권</a></li>
		                      <li><a href="/">의류 / 잡화</a></li>
		                      <li><a href="/">가공식품</a></li>
		                      <li><a href="/">기타</a></li>
		                 </ul>
	                 </div>
	                 
				</div>
            </div>
            
        </section>
       
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
