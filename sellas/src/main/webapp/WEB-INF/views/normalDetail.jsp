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
<title>일반거래 디테일</title>
<!-- Favicon-->
<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />

<!-- Bootstrap icons-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"
	rel="stylesheet" />
<!-- Core theme CSS (includes Bootstrap)-->
<link href="css/styles.css" rel="stylesheet" />
<link rel="stylesheet" href="../css/tradeDetail.css">
<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
	href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<script src="./js/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

</head>
<body>
	<!-- Navigation-->
	<nav class="navbar navbar-expand-lg navbar-light bg-light"
		style="z-index: 10">
		<div class="container px-4 px-lg-5">
			<a class="navbar-brand" href="">SellAS</a>
			<button class="navbar-toggler" type="button" data-bs-target=""
				aria-controls="navbarSupportedContent">
				<img src="../img/menuIcon.png" id="menuIcon" alt="menuIcon">
			</button>
		</div>
	</nav>
	<!-- Header-->
	<header> </header>
	<!-- Section-->


	<section class="py-5">

		<div class="container px-4 px-lg-5 mt-5 tradecontainter"
			style="z-index: 10" id="productContainer">
			<div
				class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">

				<div id="detail">
					<input type="hidden" value="${detail.mnickname}" class="sellerMnickname">
					<input type="hidden" value="${sessionScope.mnickname }" class="mnickname">
					<input type="hidden" value="${sessionScope.muuid }" class="buyerMuuid">
					<input type="hidden" value="${detail.tno }" class="normalTno">
					<input type="hidden" value="${detail.muuid }" class="normalMuuid">
					<input type="hidden" value="${detail.tnormalprice }" class="tnormalprice">
					<input type="hidden" value="${detail.muuid }" class="sellerMuuid">
					
				
					세션값이오나용 ${sessionScope.mnickname } 여기에 수정삭제를 만들까 아래에 수정삭제를 만들까 고민해봅시다

					<h2>제목 : ${detail.ttitle} , 상태 : ${detail.tnormalstate}</h2>
					<br>
					가격 : ${detail.tnormalprice } 웨일 페이
					<h6>카테고리 : ${detail.iname }</h6>


					<div id="detailID">${detail.mnickname}</div>
					<div id="detailDate">${detail.tdate}&nbsp;
						&nbsp;&nbsp;&nbsp;작성자: ${detail.mnickname}</div>

					<c:if test="${normalDetailImage ne null }">
						<c:forEach items="${normalDetailImage }" var="i">
							<img alt="" src="./tradeImgUpload/${i.timage }"
								style="width: 200px; height: 200px;">
						</c:forEach>
					</c:if>

					${detail.tcontent}
					<br>
					
					<!-- 판매중일때 -->
					
					<c:if test="${sessionScope.muuid == detail.muuid && detail.tnormalstate == 0}">
						<button id="normalEditBtn">수정하기</button>
						<button id="normalDeleteBtn">등록 취소</button>
					</c:if>
					<c:if test="${sessionScope.muuid != detail.muuid &&detail.tnormalstate == 0}">
						<button id="addWishList">찜하기☆</button>
						<button id="requestChatBtn">채팅 신청</button>
					</c:if>
						
						
						<!-- 거래중일때 -->
					<c:if test="${sessionScope.muuid != detail.muuid &&detail.tnormalstate == 1}">
							거래중입니다.
					</c:if>
					
					
						<!-- 판매완료일때 -->
						<c:if test="${sessionScope.muuid != detail.muuid &&detail.tnormalstate == 2}">
							거래가 완료된 물품입니다.
					</c:if>
				</div>
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
	
	$(function(){
		let tno = $(".normalTno").val();
		let mnickname = $(".mnickname").val();
		let tnormalprice = $(".tnormalprice").val();
		let sellerMnickname = $(".sellerMnickname").val();
		let sellerMuuid = $(".sellerMuuid").val();
		let buyerMuuid = '${sessionScope.muuid}';
		$("#normalEditBtn").click(function(){
			alert(tno);
			if(confirm("수정하시겠습니까?")){
				alert("ㅎㅎ");
				location.href='./normalEdit?tno='+tno;
			}
		});//수정 버튼 눌렀을 때 끝
		
		$("#normalDeleteBtn").click(function(){
			if(confirm("정말 삭제하시겠습니까?")){
				$.ajax({
					url : "normalDelete",
		               type : "post",
		               data : {tno : tno , muuid: sellerMuuid},
		               dataType : "json",
		               success:function(data){
		            	   if(data.deleteSuccess == 1){
		            		   alert("삭제가 완료되었습니다.");
		            		   location.href='/';
		            	   }
		               },
		               error:function(error){
		            	   alert("ㅠㅠ");
		               }
				});
			}
		});//삭제 버튼 눌렀을 때 끝
		
		
		
		
		//거래 신청을 했을 때 실행합니다.
		//채팅과 성공적으로 연결된 이후 사용하겠습니다.
		$("#requestChatBtn").click(function(){
			if(confirm("채팅 신청 하시겠습니까?")){

			$.ajax({
				
				url : "./checkTnormalstate",
				type : "post",
				data : {tno : tno, mnickname : mnickname, tnormalprice : tnormalprice, sellerMnickname : sellerMnickname},
				dataType : "json",
				success : function(data){
					if(data.emptySession == 1){
						alert("로그인이 필요한 서비스입니다.");
						location.href='./login';
						return false;
					}
					//오는 데이터 : tnormalstate , mamount, 
					
					if(data.paymentCount > 0){
						alert("이미 진행중인 채팅방이 있거나 실패한 거래입니다.");
						return false;
					}
					
					if(data.nomoney == 1){
						alert("잔액이 부족합니다.");
						if(confirm("현재 보고 계신 물품의 가격보다 가지고 있는 잔액이 부족합니다.\n그래도 채팅방을 개설할까요?")){
							//location.href='./fillPay';
							
						}
					}
					
					
					if(data.success == 1){
						alert("거래 신청이 완료되었습니다.");
						//가상 form 만들어서  submit하기
						   var form = $("<form></form>").attr({
      						   action: "./chat/onlyalarm",
        					   method: "post",
  							    });

						// 필요한 hidden input 추가
						      form.append($("<input>").attr({ type: "hidden", name: "tno", value: tno }));
						      form.append($("<input>").attr({ type: "hidden", name: "obuyer", value: buyerMuuid }));
						      form.append($("<input>").attr({ type: "hidden", name: "oseller", value: sellerMuuid }));
						      form.append($("<input>").attr({ type: "hidden", name: "tnormalprice", value: tnormalprice }));
						      
						      // 폼을 body에 추가하고 자동으로 submit
						      form.appendTo("body").submit();
					}
					
				},
				error : function(error){
					alert("ㅠㅠ");
				}
			});//ajax 끝
			}
		});// 거래 신청 버튼 끝
		
		
/* 		$("#requestChatBtn").click(function(){
			alert("!");
			if(confirm(sellerMnickname + "에게 채팅을 거시겠습니까?")){
				alert("채팅을 걸자!");
				//거래 신청 버튼은 채팅창 안으로 넣겠습니다.
				$.ajax({
					url : "./requestChat",
					type : "get",
					data : { oseller : sellerMuuid, tno:tno },
					dataType : "json",
					success : function(data){
						alert("ㅎㅎ");
					},
					error : function(error){
						alert("ㅠㅠ");
					}
					
				});
			}
		});
		 */
		
		
	});
	 
	
	</script>
</html>
