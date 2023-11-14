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
<link href="css/main.css" rel="stylesheet">

<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
   href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
   
<script src="./js/jquery-3.7.0.min.js"></script>
<style type="text/css">
.loading {
	background-color: white;
	z-index: 9999;
}
#loading {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: white; /* 배경색을 흰색으로 지정 */
    z-index: 8;
    text-align: center;
}

#loading_img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: contain;
    z-index: 8;
    max-width: 100%;
    max-height: 100%;
}
</style>
<script type="text/javascript">
var loading = "";
$(function() {
	loading = $('<div id="loading" class="loading"></div><img id="loading_img" alt="로딩중입니다" src="./tradeImgUpload/movingWhale.gif" />').appendTo(document.body).hide();
	
	// 로딩바 적용
	loading.show();
	
	//로딩바를 위해 1.5초 뒤 ajax 실행
	timer = setTimeout(function(){
        jQuery.ajax({
			type : "POST",
			url : "ajax.php",
			data : $("#frm").serialize(),
			cache: false,
			success : function(data) {
				if(data == "0000"){
					alert("작업성공");
					// 로딩바 해제
					loading.hide();
				} else{
					// 로딩바 해제
					loading.hide();	
				}
			},
			error : function(e) {
				// 로딩바 해제
				loading.hide();
			}, timeout:10000
		});
    },1000);		
});
</script>
   <script type="text/javascript">
   	
   
   $(function() {
	   
	   console.log("tno : " + $(".rowNum:first").attr("data-tno"))
	    let currentPage = 1;
   		let isBottomHandled = false;
   	
   	$(window).on("scroll",function(){

   		let scrollTop=$(window).scrollTop(); 		// 스크롤된 길이
   	    let windowHeight=$(window).height(); 		//웹브라우저의 창의 높이
   	    let documentHeight=$(document).height(); 	//문서 전체의 높이
   	    
   	    let isBottom=scrollTop+windowHeight + 10 >= documentHeight;	// 스크롤완료여부

   	    if(isBottom && !isBottomHandled){	
   	    	
   	    	nextPage(currentPage);	// 다음페이지 불러오는 함수	실행
   	    	currentPage++;
   	    	isBottomHandled = true;
   	    	
   	    } else if (!isBottom) {
   	    	
   	        isBottomHandled = false;
   	    }
	   
	   
	// 다음페이지 불러오는 함수	
 	 function nextPage(currentPage){
		
		 let sort = 0;	// 일단 0로만 가져와보기
         let firsttno = $(".rowNum:first").attr("data-tno");	// 최상단글tno ***** 확인용 *****
         let lastRow = $(".tradeRow:last");	// 최하단row
         let count = $(".tradeRow").attr("data-count");	// 해당 카테고리의 글갯수
         let wholePage = Math.ceil(count/10);	// 전체페이지수(글의갯수/10의 올림) 
         
         //console.log("firsttno : " + firsttno);
         //console.log("count : " + count);
         //console.log("wholePage : " + wholePage);
         //console.log("currentPage : " + currentPage);
         //console.log("nextPage : " + currentPage);
         //lastRow.css("color", "red");
		
         
     	 // 다음페이지가 없다면 진행X
         if(wholePage < currentPage){
       	  	//alert("마지막 페이지 입니다.");
				return false;
         }
     	 
     	 // 다음페이지가 있다면 진행
   		 let newRow = ""; 	// 추가될 tr
         let data = {};		// ajax로 보낼 객체
         
      	 let lasttno = $(".rowNum:last").attr("data-tno"); // 최하단글tno
      	 //console.log("list: " + firsttno + " ~ " + lasttno)
      	 
      	 // 서버로 보낼것들 data에 담기
         data.sort = sort;
         data.lasttno = lasttno;
         data.count = count;
         
         //console.log("lasttno : " + data.lasttno);
         //console.log("count : " + data.count);
     	 
         $.ajax({
             url: './nextTradePage',
             type: 'post',
             data: data,
             dataType: 'json',
             success: function(data) {
           	  
           	    if (data.list != null) { // 데이터가 있다면 뽑아내기
           	        //alert("데이터와");
           	       	
           	     $(data).each(function() {
           	    	 //alert(data.list[0].tno);
           	    	 
           	    	for (let i = 0; i < this.list.length; i++) {
           	    		
           	    		newRow = '<div class="col mb-5 tradeRow normalTradeDetail" data-count="' + this.list[i].count + '">'
	           	            + '<div class="card h-100"><img class="card-img-top" src="' + (this.list[i].thumbnail ? './tradeImgUpload/' + this.list[i].thumbnail : './tradeImgUpload/defaultimg.jpg') + '" alt="thumbnail" />'
	           	            + '<div class="card-body p-4">'
	           	            + '<div class="text-center;">'
	           	            + '<h5 class="fw-bolder normalTtitle">' + this.list[i].title + '</h5>'
	           	            + '작성자 : ' + this.list[i].mnickname + '<br>' + this.list[i].tnormalprice + ' 웨일페이<br>'
	           	            + '</div>'
	           	            + '<input type="hidden" class="rowNum" data-tno="' + this.list[i].tno + '">' + this.list[i].tno
	           	            + '</div>'
	           	            + '<div class="card-footer p-4 pt-0 border-top-0 bg-transparent">'
	           	            + '<div style="text-align: center;">'
	           	            + (this.list[i].tnormalstate == 0 ? '판매중' : (this.list[i].tnormalstate == 1 ? '거래중' : '판매완료'))
	           	            + '</div>'
	           	            + '<div class="text-center">'
	           	            + '<a class="btn btn-outline-dark mt-auto" href="./normalDetail?tno=' + this.list[i].tno + '">상품 보러가기</a>'
	           	            + '</div>'
	           	            + '</div>'
	           	            + '</div>'
	           	            + '</div>';
           	    	
	           	         	lastRow.after(newRow); // lastRow 뒤에 추가
	           	         	
	           	       		lastRow = $(".tradeRow:last");   // 최하단row
	           	      	 	//console.log("lastRow :" + i + "번째");
	           	       		
           	    	} // for
           	    	 
           	  	}); // .each
           	    
           	    
           	    } // if(data != null)
           	    	
           	},	// success
             
           	error: function(error) {
                 //alert("에러남");
             }
             
         }); // ajax
     	 
	}	// nextPage
	
	});	// 스크롤

});    
   </script>
   
               		<!---------------- 검색 ------------------>
					<script type="text/javascript">
					
						$(function(){
							
							$(".dropdown-menu a").click(function() {
	   							 // 클릭된 항목에 active 클래스 추가
	    						$(this).addClass("active");
	    						// 다른 항목에서 active 클래스 제거
	   							$(".dropdown-menu a").not(this).removeClass("active");
	    						
	    						let searchCate = $(".active").text();
	    						console.log(searchCate);
	    						$("#navbarDropdown").text(searchCate);	// 선택한 카테고리 보여주기
							});
							
							// 검색버튼 클릭
							$(".swriteButton").click(function(){
								
								if($(".dropdown-menu a").hasClass("active")){
									let selectedOption = $(".dropdown-menu a.active").data("option");
									$(".searchCate").val(selectedOption);	// searchCate 서버로 보낼 input창에 넣기
									console.log(selectedOption)
								} 
								
								$(".searchFrom").submit();	// form 제출
							});
							
							
							// 검색카테고리 & 검색단어 검색창에 남기기
			            	let searchCate = "${param.searchCate}";
			            	let search = "${param.search}";
			            	
			        		let firstOption = $(".searchCate option:first").val();
			        		$(".searchCate").val(firstOption);
			            	
			            	if (searchCate != ""){
			            		let pick = $("a.dropdown-item[data-option="+searchCate+"]").text();
								console.log("선택한카테 : " + pick);
								$("#navbarDropdown").text(pick);
			            		$(".swrite").val(search);
			            	}
							
						})
					</script>
   
   
   
</head>
<body>
   <%@ include file="menubar.jsp" %>
   
   <!-- Header-->
   <header class="bg-dark py-5">
      <div class="container px-4 px-lg-5 my-5">
         <div class="text-center text-white">
            <h1 class="display-4 fw-bolder"></h1>
            <c:choose>
               <c:when test="${memberInfo != null }">
                  <p class="lead fw-normal text-white-50 mb-0">안녕하세요
                     ${memberInfo.mnickname }님!!</p>
                  <br> 현재 남은 잔액 : ${memberInfo.mbalance } 웨일페이

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

   <section class="py-3">

<%--   정렬부분 주석처리 했슴다 *************************************

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
       --%>
      
      <div class="container px-4 px-lg-5 mt-5" style="z-index: 10" id="productContainer">
         
         <div class="searchBox justify-content-center">

					<form action="./" method="get" class="searchFrom">

						<ul class="navbar-nav">
							<li class="nav-item dropdown"><a
								class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">검색</a>
								<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
									<li><a class="dropdown-item title" href="#"	data-option="title">제목</a></li>
									<li><hr class="dropdown-divider" /></li>
									<li><a class="dropdown-item content" href="#" data-option="content">내용</a></li>
									<li><hr class="dropdown-divider" /></li>
									<li><a class="dropdown-item writer" href="#" data-option="writer">글쓴이</a></li>
								</ul>
							</li>
						</ul>

						<input type="text" name="search" class="swrite"> 
						<input type="hidden" name="searchCate" class="searchCate" value="title">
						<button type="button" class="swriteButton"><img src="../img/searchIcon.png" id="searchIcon" alt="searchIcon"></button>

					</form>
		</div>
         
         <div style="text-align: center;">

				<button onclick="location.href='./addTradeItem'"
               style="background-color: red; width: 50px; height: 50px;">물품
               등록</button>
            엌ㅋㅋ 이대원 머니충전 내가 가져간다
            <br>
         </div>
         <div
            class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center"
            id="sortContainer">
            
            <!---------------- 메인화면(검색X) ------------>
            <c:if test="${param.search eq null}">
            
	            <c:forEach items="${normalBoardList }" var="i" varStatus="loop">
	            
	               <div class="col mb-5 tradeRow normalTradeDetail${loop.index }" data-count="${i.count}">
	                  <div class="card h-100">
	                     <!-- Product image-->
	                     <c:choose>
	                        <c:when test="${i.thumbnail ne null }">
	                           <img class="card-img-top" src="./tradeImgUpload/${i.thumbnail }" alt="thumbnail" />
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
	                           <h6 class="fw-bolder normalTtitle">${i.ttitle }</h5>
	                           <!-- Product price-->
	                           작성자 : ${i.mnickname }<br> ${i.tnormalprice } 웨일페이<br>
	                        </div>
	                        <input type="hidden" class="rowNum" data-tno="${i.tno }">${i.tno }
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
	            
            </c:if>
            
			 <!---------------- 메인화면(검색O) ------------>
			<c:if test="${param.search ne null && param.searchCate ne null}">
			
				<c:forEach items="${normalSearchList }" var="s" varStatus="loop">
	            
	               <div class="col mb-5 tradeRow normalTradeDetail${loop.index }" data-count="${s.count}">
	                  <div class="card h-100">
	                     <!-- Product image-->
	                     <c:choose>
	                        <c:when test="${s.thumbnail ne null }">
	                           <img class="card-img-top" src="./tradeImgUpload/${s.thumbnail }" alt="thumbnail" />
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
	                           <h5 class="fw-bolder normalTtitle">${s.ttitle }</h5>
	                           <!-- Product price-->
	                           작성자 : ${s.mnickname }<br> ${s.tnormalprice } 웨일페이<br>
	                        </div>
	                        <input type="hidden" class="rowNum" data-tno="${s.tno }">${s.tno }
	                     </div>
	                     <!-- Product actions-->
	                     <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
	                        <div style="text-align: center;">
	                           <c:if test="${s.tnormalstate ==0 }">
	                               판매중
	                               </c:if>
	                           <c:if test="${s.tnormalstate ==1 }">
	                               거래중
	                               </c:if>
	                           <c:if test="${s.tnormalstate ==2 }">
	                               판매완료
	                               </c:if>
	                        </div>
	                        <div class="text-center">
	                           <a class="btn btn-outline-dark mt-auto"
	                              href="./normalDetail?tno=${s.tno }">상품 보러가기</a>
	                        </div>
	                     </div>
	                  </div>
	               </div>
	               
	            </c:forEach>
			
			</c:if>
			
         </div>
      </div>
   </section>

   <!-- Footer-->

   <!-- Core theme JS-->
   <script src="js/scripts.js"></script>
   
</body>

<script
   src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script
   src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script type="text/javascript">

   let sock = new SockJS("/ws/chat");
   let ws = Stomp.over(sock);
   let oseller = '${sessionScope.muuid}';
   //console.log("alarmcount" + '${alarmcount}');
   $(function() {
      ws.connect({}, function(frame) {
         //console.log(frame); 
         ws.subscribe("/sub0/ws/chat/user/" + oseller, function(message) {
            //console.log(message);
            let recv = JSON.parse(message.body);
            //console.log("recv" + recv); 정상적으로 들어옵니다.
            if (recv.type == 'ALARM') {
               // Change the color of elements with class "xi-message" to black
               let xiMessageElements = document
                     .querySelectorAll(".xi-message");
               xiMessageElements.forEach(function(element) {
                  element.style.color = "black";
               });
            } else {
               return false;
            }

         });
         startPing();
      });
   });
   
      


   function startPing() {
      let oseller = "${sessionScope.muuid}"
      let imessage = "INTERVAL";
      ws.send("/pub/ws/chat/alarmmessage", {}, JSON.stringify({
         type : 'INTERVAL',
         sender : oseller,
         message : imessage
      }));
      setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
   };

   $(function() {

      $(".xi-message").click(function() {

         window.location.href = "/chat/alarm";

      });

   });

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
                  let contentClass = "";
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
>>>>>>> branch 'master' of https://github.com/StarSellas/Sellas.git
