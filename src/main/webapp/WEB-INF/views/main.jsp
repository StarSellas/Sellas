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
<script src="./js/jquery-3.7.0.min.js"></script>
</head>
<body>
	<!-- Navigation-->
  <nav class="navbar navbar-expand-lg navbar-light bg-light" style="z-index: 10">
           <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="./">SellAS</a>
				<button class="navbar-toggler" type="button" data-bs-target="" aria-controls="navbarSupportedContent"><a href="/menu"><img src="../img/menuIcon.png" id="menuIcon" alt="menuIcon"></a></button>
           </div>
        </nav>
	<!-- Header-->
	<header class="bg-dark py-5">
		<div class="container px-4 px-lg-5 my-5">
			<div class="text-center text-white">
				<h1 class="display-4 fw-bolder"></h1>
				<c:choose>
					<c:when test="${memberInfo != null }">
						<p class="lead fw-normal text-white-50 mb-0">안녕하세요
							${memberInfo.mnickname }님!!</p>
						<br> 현재 남은 잔액 : ${memberInfo.mamount } 웨일페이

					</c:when>
					<c:otherwise>
						<p class="lead fw-normal text-white-50 mb-0">로그인 해주세요</p>
						<a href="./login">로그인</a>
					</c:otherwise>
				</c:choose>

			</div>
		</div>
	</header>
	<!-- Section-->



	<section class="py-5">
		<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
			<li class="nav-item dropdown">
				<div class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
					role="button" data-bs-toggle="dropdown" aria-expanded="false">${sortList }</div>
				<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
					<li><div class="dropdown-item sortOption sortLowPrice" onclick="location.href='/?sort=1'">가격
							낮은 순</div></li>
					<li><hr class="dropdown-divider" /></li>
					<li><div class="dropdown-item sortOption sortHighPrice"  onclick="location.href='/?sort=2'">가격
							높은 순</div></li>
					<li><hr class="dropdown-divider" /></li>
					<li><div class="dropdown-item sortOption sortPopularity"  onclick="location.href='/?sort=3'">인기순</div></li>
					<li><hr class="dropdown-divider" /></li>
					<li><div class="dropdown-item sortOption sortRecent"  onclick="location.href='/'">최신순</div></li>
					<!--  => 기준 : 조회수 =1 , 찜 = 5? 두 개 더해서 -->
				</ul>
			</li>
		</ul>
		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10"
			id="productContainer">
			<div style="text-align: center;">

				<button onclick="location.href='./normalWrite'"
					style="background-color: red; width: 50px; height: 50px;">물품
					등록</button>
				<button onclick="location.href='./fillPay'"
					style="background-color: yellow; width: 50px; height: 50px;">머니
					충전</button>
				<br>
			</div>
			<div
				class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center"
				id="sortContainer">
				<c:forEach items="${normalBoardList }" var="i" varStatus="loop">
					<div class="col mb-5 normalTradeDetail${loop.index }">
						<div class="card h-100">
							<!-- Product image-->
							<c:choose>
								<c:when test="${i.thumbnail ne null }">
									<img class="card-img-top"
										src="./tradeImgUpload/${i.thumbnail }" alt="thumbnail" />
								</c:when>
								<c:otherwise>
									<img class="card-img-top" src="./tradeImgUpload/defaultimg.jpg"
										alt="..." />
								</c:otherwise>
							</c:choose>
							<!-- Product details-->
							<div class="card-body p-4">
								<div class="text-center">
									<!-- Product name-->
									<h5 class="fw-bolder normalTtitle">${i.ttitle }</h5>
									<!-- Product price-->
									작성자 : ${i.mnickname }<br> ${i.tnormalprice } 웨일페이<br>

								</div>
							</div>
							<!-- Product actions-->
							<div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
								<div style="text-align: center;">
									<c:if test="${i.tnormalstate ==0 }">
                            	판매중
                            	</c:if>
									<c:if test="${i.tnormalstate ==1 }">
                            	거래중
                            	</c:if>
									<c:if test="${i.tnormalstate ==2 }">
                            	판매완료
                            	</c:if>
								</div>
								<div class="text-center">
									<a class="btn btn-outline-dark mt-auto"
										href="./normalDetail?tno=${i.tno }">상품 보러가기</a>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>

			</div>
		</div>
	</section>

	<!-- Footer-->
	<footer id="footer">
		<div class="container">
			<ul class="menubar">
				<li onclick="location.href='./'"><i class="xi-home xi-2x"></i>
					<div id="menu">홈</div></li>
				<li><i class="xi-message xi-2x"></i>
					<div id="menu">채팅</div></li>
				<li><i class="xi-profile xi-2x"></i>
					<div id="menu">마이페이지</div></li>
			</ul>
		</div>
	</footer>
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/scripts.js"></script>
</body>


<script type="text/javascript">
	$(function() {
		function sortNormalTradeList(sortBy, inOrder) {

			$.ajax({
				url : "./sortNormalTradeList",
				type : "get",
				data : {
					sortBy : sortBy,
					inOrder : inOrder
				},
				dataType : "json",
				success : function(data) {
					var newItems = "";
					   
					   
					   
					   
					for (var i = 0; i < data.sortNormalBoradList.length; i++) {
						let item = data.sortNormalBoradList[i];

						 // 데이터에서 필요한 속성 추출
						let ttitle = item.ttitle;
						let mnickname = item.mnickname;
						let tnormalprice = item.tnormalprice;
						console.log(ttitle);
						// 새로운 아이템을 생성하거나 기존 아이템을 업데이트
						let selector = ".normalTradeDetail" + i;
						
						
						let element = $(selector);
						let newContent = data.sortNormalBoradList[i].ttitle; // 변경하고자 하는 텍스트나 HTML
						let titleClass = ".normalTtitle";
						let contentClass ="";
						let nicknameClass = "";
						let normalpriceClass = "";
						let tnoClass = "";
						let stateClass = "";
						element.find(titleClass).text(newContent);
						
						

					}

				 
				 },
				error : function(error) {
					// 오류 처리
				}
			});
		}

		$('.sortLowPrice').on('click', function() {

			sortNormalTradeList('tnormalprice', 'asc');
			$('.dropdown-toggle').text('가격 낮은 순');
			// 추가적인 동작을 수행하거나 AJAX 요청을 보낼 수 있습니다.
		});

		// 가격 낮은 순을 선택한 경우
		$('.sortHighPrice').on('click', function() {
			sortNormalTradeList('tnormalprice', 'desc');
			$('.dropdown-toggle').text('가격 높은 순');
			// 추가적인 동작을 수행하거나 AJAX 요청을 보낼 수 있습니다.
		});

		// 인기순을 선택한 경우
		$('.sortPopularity').on('click', function() {
			sortNormalTradeList('tread', 'desc');
			$('.dropdown-toggle').text('인기순');
			// 추가적인 동작을 수행하거나 AJAX 요청을 보낼 수 있습니다.
		});
		$('.sortRecent').on('click', function() {
			sortNormalTradeList('tno', 'desc');
			$('.dropdown-toggle').text('최신순');
			// 추가적인 동작을 수행하거나 AJAX 요청을 보낼 수 있습니다.
		});

	});
</script>
</html>
