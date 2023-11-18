<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="initial-scale=1, width=device-width, user-scalable=no"/> 
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
<script src="./js/wnInterface.js"></script> 
      <script src="./js/mcore.min.js"></script> 
      <script src="./js/mcore.extends.js"></script> 
<style type="text/css">
.loading {
   background-color: white;
   z-index: 8000;
}
#loading {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: white; /* 배경색을 흰색으로 지정 */
    z-index: 8000;
    text-align: center;
}

#loading_img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: contain;
    z-index: 8000;
    max-width: 100%;
    max-height: 100%;
}
</style>
<script type="text/javascript">
var loading = "";
$(function() {
   loading = $('<div id="loading" class="loading"></div><img id="loading_img" alt="로딩중입니다" src="./tradeImgUpload/movingWhale.gif" />').appendTo(document.body).hide();
   
   // 로딩바 적용
   //loading.show();
   
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
      
         let search = "${param.search }";
         let searchCate = "${param.searchCate }";
       let currentPage = 1;
         let isBottomHandled = false;
      
      $(window).on("scroll",function(){

         let scrollTop=$(window).scrollTop();       // 스크롤된 길이
          let windowHeight=$(window).height();       //웹브라우저의 창의 높이
          let documentHeight=$(document).height();    //문서 전체의 높이
          
          let isBottom=scrollTop+windowHeight + 10 >= documentHeight;   // 스크롤완료여부

          if(isBottom && !isBottomHandled){   
             
             nextPage(currentPage);   // 다음페이지 불러오는 함수   실행
             currentPage++;
             isBottomHandled = true;
             
          } else if (!isBottom) {
             
              isBottomHandled = false;
          }
      
      
   // 다음페이지 불러오는 함수   
     function nextPage(currentPage){
      
         let firsttno = $(".rowNum:first").attr("data-tno");   // 최상단글tno ***** 확인용 *****
         let lastRow = $(".tradeRow:last");   // 최하단row
         let count = $(".tradeRow").attr("data-count");   // 해당 카테고리의 글갯수
         let startpage = currentPage * 10;
         let pageCount = 10;
         let wholePage = Math.ceil(count/10);   // 전체페이지수(글의갯수/10의 올림) 
         
         //console.log("firsttno : " + firsttno);
         //console.log("count : " + count);
         //console.log("wholePage : " + wholePage);
         //console.log("currentPage : " + currentPage);
         //console.log("startpage : " + startpage);
         //console.log("nextPage : " + currentPage);
         //lastRow.css("color", "red");
      
         
         // 다음페이지가 없다면 진행X
         if(wholePage < currentPage){
               //alert("마지막 페이지 입니다.");
            return false;
         }
         
         // 다음페이지가 있다면 진행
          let newRow = "";    // 추가될 tr
         let data = {};      // ajax로 보낼 객체
         
          let lasttno = $(".rowNum:last").attr("data-tno"); // 최하단글tno
          //console.log("list: " + firsttno + " ~ " + lasttno)
          
          // 서버로 보낼것들 data에 담기
         data.lasttno = lasttno;
         data.count = count;
         data.search = search;
         data.startpage = startpage;
         data.pageCount = pageCount;
         data.searchCate = searchCate;
         
         //console.log("lasttno : " + data.lasttno);
         //console.log("search : " + data.search);
         
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
                        
                        newRow = $('<div class="col mb-5 tradeRow normalTradeDetail" data-count="' + this.list[i].count + '" data-scount="' + this.list[i].scount + '">' +
                                '<div class="card h-100" onclick="location.href=\'./normalDetail?tno=' + this.list[i].tno + '\'">' +
                                '<img class="card-img-top" src="' + (this.list[i].thumbnail ? './tradeImgUpload/' + this.list[i].thumbnail : './tradeImgUpload/defaultimg.jpg') + '" alt="thumbnail" />' +
                                '<div class="card-body p-4">' +
                                '<div class="text-center">' +
                                '<h6 class="fw-bolder normalTtitle">' + this.list[i].ttitle + '</h6>' +
                                '<div class="mickname">' + this.list[i].mnickname + '</div> <div style="font-size: large;"> ' + this.list[i].tnormalprice + ' WP</div>' +
                                '<div style="font-size: small;">' + this.list[i].ttdate + '</div>' +
                                '</div>' +
                                '<input type="hidden" class="rowNum" data-tno="' + this.list[i].tno + '">' +
                                '<div class="tradeState">' +
                                (this.list[i].tnormalstate == 0 ? '<span class="state_selling">판매중</span>' : (this.list[i].tnormalstate == 1 ? '<span class="state_ing">거래중</span>' : '<span class="state_done">판매완료</span>')) +
                                '</div>' +
                                '</div>' +
                                
                                '<div class="text-center">' +
                               
                                '</div>' +
                                '</div>' +
                                '</div>');

                            lastRow.after(newRow); // lastRow 뒤에 추가
                            lastRow = $(".tradeRow:last"); // 최하단 row
                            cutTitle();
                     } // for
                      
                   }); // .each
                  
                  
                  } // if(data != null)
                     
              },   // success
             
              error: function(error) {
                 //alert("에러남");
             }
             
         }); // ajax
         
   }   // nextPage
   
   });   // 스크롤

});    
   </script>
   
                     <!---------------- 검색 ------------------>
               <script type="text/javascript">
               
                  $(function(){
                     
                     let selectedOption;
                     let searchCate = "${param.searchCate}";
                        let search = "${param.search}";
                     
                        $(".searchA").click(function() {
                            // 클릭된 항목에 active 클래스 추가
                         $(this).addClass("active");
                         // 다른 항목에서 active 클래스 제거
                           $(".searchA").not(this).removeClass("active");
                         
                         let searchCate = $(this).text();
                         console.log(searchCate);
                         $("#navbarDropdown").text(searchCate);   // 선택한 카테고리 보여주기
                        
                         if($(".searchA").hasClass("active")){
                           let selectedOption = $(".searchA.active").data("option");
                           $(".searchCate").val(selectedOption);   // searchCate 서버로 보낼 input창에 넣기
                           console.log(selectedOption)
                        } 
                      
                     });
                     
                     // 검색버튼 클릭
                     $(".swriteButton").click(function(){
                        $(".searchFrom").submit();   // form 제출
                     });
                     
                     
                     // 검색카테고리 & 검색단어 검색창에 남기기
                        
                       let firstOption = $(".searchCate option:first").val();
                       $(".searchCate").val(firstOption);
                        
                        if (searchCate != ""){
                           let pick = $("a.dropdown-item[data-option="+searchCate+"]").text();
                        console.log("선택한카테 : " + pick);
                        $("#navbarDropdown").text(pick);
                           $(".swrite").val(search);
                        }
                        
                        console.log("검색이후 value값 : " + $(".ReSearchCate").val())
                        
                  })
               </script>
   
   
   
</head>
<body>
   <%@ include file="menubar.jsp" %>
   
   <!-- Header-->
   <header class="storyhead">
      <div class="container px-4 px-lg-5 my-5">
         <div class="text-center">
            <h1 class="display-4 fw-bolder"></h1>
            <c:choose>
               <c:when test="${memberInfo != null }">
                  <p class="lead fw-normal text-white-50 mb-0">안녕하세요
                     ${memberInfo.mnickname }님!!</p>
                  <br> <fmt:formatNumber value="${memberInfo.mbalance }" pattern="#,### 웨일페이"/>
                여기서부터 시작하겠습니다.
	
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
      <div class="container px-4 px-lg-5 mt-5" style="z-index: 10" id="productContainer">
         <div class="searchBox justify-content-center">
         
               <form action="./" method="get" class="searchFrom" id="searchFromM">
                  <div class="searchCateBox" id="searchCateBox">
                     <ul class="navbar-nav">
                        <li class="nav-item dropdown"><a
                           class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">검색</a>
                           <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                              <li><a class="dropdown-item searchA" href="#" data-option="title">제목</a></li>
                              <li><hr class="dropdown-divider" /></li>
                              <li><a class="dropdown-item searchA" href="#" data-option="content">내용</a></li>
                              <li><hr class="dropdown-divider" /></li>
                              <li><a class="dropdown-item searchA" href="#" data-option="writer">글쓴이</a></li>
                           </ul>
                        </li>
                     </ul>
                  </div>
                     <input type="text" name="search" class="swrite" id="swriteM"> 
                     <input type="hidden" name="searchCate" class="searchCate" value="title">
                     <button type="button" class="swriteButton" id="swriteButtonM"><img src="../img/searchIcon.png" id="searchIcon" alt="searchIcon"></button>
               </form>
               
               <input type="hidden" class="ReSearchCate" value="${searchCate }">
      </div>
         
         <div
            class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center"
            id="sortContainer">
            
            <!---------------- 메인화면(검색X) ------------>
            <c:if test="${param.search eq null}">
            
               <c:forEach items="${normalBoardList }" var="i" varStatus="loop">
               
                  <div class="col mb-5 tradeRow normalTradeDetail${loop.index }" data-count="${i.count}" data-scount="${i.scount}">
                     <div class="card h-100" onclick="location.href='./normalDetail?tno=${i.tno }'">
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
                              <h6 class="fw-bolder normalTtitle">${i.ttitle }</h6>
                              <!-- Product price-->
                             <div class="mickname">${i.mnickname }</div> <div style="font-size: large;"> ${i.tnormalprice } WP</div>
                               <div style="font-size: small;">${i.ttdate }</div>
                           </div>
                           <input type="hidden" class="rowNum" data-tno="${i.tno }">
                        <div class="card-footer border-top-0 bg-transparent">
                        <!-- Product actions-->
                           <div class="tradeState">
                              <c:if test="${i.tnormalstate ==0 }">
                                  <span class="state_selling">판매중</span>
                              </c:if>
                              <c:if test="${i.tnormalstate ==1 }">
                                  <span class="state_ing">거래중</span>
                              </c:if>
                              <c:if test="${i.tnormalstate ==2 }">
                                 <span class="state_done">판매완료</span>
                              </c:if>
                           </div>
                           <div class="text-center">
                           </div>
                        </div>
                        </div>
                     </div>
                  </div>
                  
               </c:forEach>
               
            </c:if>
            
          <!---------------- 메인화면(검색O) ------------>
         <c:if test="${param.search ne null && param.searchCate ne null}">
         
            <c:forEach items="${normalSearchList }" var="s" varStatus="loop">
               
                  <div class="col mb-5 tradeRow normalTradeDetail${loop.index }" data-count="${s.count}" data-scount="${s.scount}">
                     <div class="card h-100" onclick="location.href='./normalDetail?tno=${s.tno }'">
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
                              <h6 class="fw-bolder normalTtitle">${s.ttitle }</h6>
                              <!-- Product price-->
                             <div class="mickname">${s.mnickname }</div> <div style="font-size: large;"> ${s.tnormalprice } WP</div>
                               <div style="font-size: small;">${s.ttdate }</div>
                           </div>
                           <input type="hidden" class="rowNum" data-tno="${s.tno }">
                        <div class="card-footer border-top-0 bg-transparent">
                        <!-- Product actions-->
                           <div class="tradeState">
                              <c:if test="${s.tnormalstate ==0 }">
                                  <span class="state_selling">판매중</span>
                              </c:if>
                              <c:if test="${s.tnormalstate ==1 }">
                                  <span class="state_ing">거래중</span>
                              </c:if>
                              <c:if test="${s.tnormalstate ==2 }">
                                 <span class="state_done">판매완료</span>
                              </c:if>
                           </div>
                           <div class="text-center">
                           </div>
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
<script type="text/javascript">
   function cutTitle(){
        $(".normalTtitle").each(function() {
            let title = $(this).text();
            console.log(title);
            console.log(title.length);
            
            if(title.length > 10){
               titlecut = title.substring(0, 9) + "...";
               console.log("titlecut : " + titlecut);
               $(this).text(titlecut);
            }
        });
    }   



$(function(){
   
   cutTitle();

});
</script>
</html>