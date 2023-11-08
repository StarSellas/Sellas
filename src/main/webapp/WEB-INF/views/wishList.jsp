<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
    <!-- 추가 스타일 및 스크립트 -->
    <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <link rel="stylesheet" href="./css/mypageList.css">
    <script src="./js/jquery-3.7.0.min.js"></script>
    <script src="../js/wishlist.js"></script>
    <link rel="stylesheet" href="./css/mypageList.css">
</head>
<body>
    <!-- Navigation-->
    <nav class="navbar navbar-expand-lg navbar-light bg-light" style="z-index: 10">
        <div class="container px-4 px-lg-5">
            <a class="navbar-brand" href="#!">SellAS</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                    <li class="nav-item"><a class="nav-link active" aria-current="page" href="#!">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="#!">About</a></li>
                    <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="#!">All Products</a></li>
                            <li><hr class="dropdown-divider" /></li>
                            <li><a class="dropdown-item" href="#!">Popular Items</a></li>
                            <li><a class="dropdown-item" href="#!">New Arrivals</a></li>
                        </ul>
                    </li>
                </ul>
                <form class="d-flex">
                    <button class="btn btn-outline-dark" type="submit">
                        <i class="bi-cart-fill me-1"></i> Cart 
                        <span class="badge bg-dark text-white ms-1 rounded-pill">0</span>
                    </button>
                </form>
            </div>
        </div>
    </nav>
    
    <!-- Header-->
    <header> </header>
    
    <!-- Section-->
    <section class="py-5">
        <div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
            <div class="d-flex inside-bar align-items-center">
                <div class="back col-auto" onclick="location.href='/mypage'">
                    <i class="xi-angle-left xi-x"></i>
                </div>
                <div class="location col">위시리스트</div>
            </div>
            <div class="nav">
                <c:choose>
                    <c:when test="${empty wishList}">
                        위시리스트가 없어요
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${wishList}" var="row">
                            <div class="card mb-3" style="max-width: 400px;">
                                <div class="row g-0" onclick="location.href='./normalDetail?tno=${row.tno}'">
                                    <div class="col-4">
                                        <img src="./tradeImgUpload/${row.timage}" class="img-fluid custom-rounded-start object-fit-cover" alt="...">
                                    </div>
                                    <div class="col-8">
                                        <div class="card-body">
                                            <h5 class="card-title">${row.ttitle}</h5>
                                            <p class="card-text">
                                                <p class="card-text">
                                                    <fmt:formatNumber value="${row.tnormalprice}" pattern="#,###원"/>
                                                </p>
                                                <p class="card-text">
                                                    <small class="text-body-secondary">
                                                    </small>
                                                </p>
                                            </div>
                                        </div>
                                        <input type="hidden" value="${row.tno}" class="normalTno">
                                    	<div class="card-text">
								<c:if test="${row.tnormalstate eq 0 }">판매중</c:if>
								<c:if test="${row.tnormalstate eq 1 }">거래중</c:if>
								<c:if test="${row.tnormalstate eq 2 }">판매완료</c:if>
							</div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${row.wno eq 0 or empty row.wno}">
                                            위시리스트가 없습니다.
                                        </c:when>
                                        <c:otherwise>
                                            <img src="../img/heart.png" id="delWishList" align="left" style="cursor:pointer; width: 20px;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <br>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>
    
    <!-- Footer-->
    <footer id="footer">
        <div class="container">
            <ul class="menubar">
                <li><i class="xi-home xi-2x"></i><div id="menu">홈</div></li>
                <li><i class="xi-message xi-2x"></i><div id="menu">채팅</div></li>
                <li><i class="xi-profile xi-2x"></i><div id="menu">마이페이지</div></li>
            </ul>
        </div>
    </footer>
    
    <!-- Bootstrap core JS-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Core theme JS-->
    <script src="js/scripts.js"></script>
</body>
</html>
