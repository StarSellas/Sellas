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

<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"
/>

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
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="../js/wishlist.js"></script>
<script src="../js/normalTrade.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a5bf13cc97cefa4fa07aebcc296ef6b7&libraries=services,clusterer,drawing"></script>
</head>
<body>
   <!-- Navigation-->
   <%@ include file="menubar.jsp" %>
   <!-- Header-->
   <header> </header>
   <!-- Section-->


   <section class="py-5">

      <div class="container px-4 px-lg-5 mt-5 tradecontainter"
         style="z-index: 10" id="productContainer">

            <div id="detail">
               <input type="hidden" value="${detail.mnickname}" class="sellerMnickname">
               <input type="hidden" value="${sessionScope.mnickname }" class="mnickname">
               <input type="hidden" value="${sessionScope.muuid }" class="buyerMuuid">
               <input type="hidden" value="${detail.tno }" class="normalTno">
               <input type="hidden" value="${detail.muuid }" class="normalMuuid">
               <input type="hidden" value="${detail.tnormalprice }" class="tnormalprice">
               <input type="hidden" value="${detail.muuid }" class="sellerMuuid">
               <input type="hidden" value="${detail.tnormalhikeup }" class="tnormalhikeup">
<!-- Slider main container -->
<div class="swiper">
  <!-- Additional required wrapper -->
  <div class="swiper-wrapper">
    <!-- Slides -->
    <c:choose>
     <c:when test="${normalDetailImage ne null}">
         <c:forEach items="${normalDetailImage}" var="i">
            <div class="swiper-slide">
               <img alt="" src="./tradeImgUpload/${i.timage}" style="width:100%; height: 100%">
            </div>
         </c:forEach>
      </c:when>
      <c:otherwise>
      <div class="swiper-slide">
               <img alt="" src="./tradeImgUpload/defaultimg.jpg" style="width:100%; height: 100%">
               
           </div>
      </c:otherwise>
   </c:choose>

  </div>
  <!-- If we need pagination -->
  <div class="swiper-pagination"></div>

  <!-- If we need navigation buttons -->
  <div class="swiper-button-prev">
  <img alt="" src="../img/pre.png" style="width: 30px; height: 30px;">
  </div>
  <div class="swiper-button-next">
   <img alt="" src="../img/next.png" style="width: 30px; height: 30px;">
  </div>

</div>
               <div class="normalDiv">
               
               
               <div class="userDiv">
               <div class="user-img">
               <img src="./userImgUpload/${detail.mphoto}" alt="user-img" class="user-img-img">
            </div>
            <div class="moveprofile">
               <div id="detailID">${detail.mnickname}</div>
               
               <div class="expDiv">
               경험치 ${detail.mpoint}%
                  <div class="progress" role="progressbar"
               aria-label="Example with label"
               aria-valuenow="${(detail.mpoint) * 100}" aria-valuemin="0"
               aria-valuemax="100">
               <div class="progress-bar" style="width: ${detail.mpoint}%; background-color: #88abff; color:black">
               </div>
            </div>
            </div>
                                          <div class="user-level">
            <c:if test="${detail.mpoint < 30}">아기고래</c:if>
                        <c:if test="${detail.mpoint >= 30 && detail.mpoint <= 70}">고래</c:if>
                        <c:if test="${detail.mpoint > 70 }">슈퍼고래</c:if>
            </div>
            </div><!--유저정보담은구역  -->
            </div>
         
            
            <div class="detailDiv">
                              <div class="dtitle">${detail.ttitle}</div>
               <div class="drow">
               <div class="diname">${detail.iname}</div>
               <div id="detailDate">${detail.ttdate}</div>
               </div>
               <div class="dprice">
                 <fmt:formatNumber value="${detail.tnormalprice}" pattern="#,###원"/>
                 </div>
                              <div class="dstate">
                              <c:if test="${detail.tnormalstate eq 0}">판매중</c:if>
                        <c:if test="${detail.tnormalstate eq 1}">거래중</c:if>
                        <c:if test="${detail.tnormalstate eq 2}">거래완료</c:if>
                              </div>
             <div class="dcontent" style="white-space:pre;">
               ${detail.tcontent}
               </div>
               <div>
               거래 희망 장소
               <div id="map" style="width: 100%; height: 200px"></div>
               <input type="hidden" value="${detail.tlocationlat }" id="lat">
               <input type="hidden" value="${detail.tlocationlng }" id="lng">
               </div>
               <br>
               
               <!-- 판매중일때 -->
               <div class="TradeBtnBox">
                  <c:if test="${sessionScope.muuid == detail.muuid && detail.tnormalstate == 0}">
                     <div class="toggleBtnBox"><button id="toggleBtn">+</button></div>
                     <div class="otherBtnBox hide">
                           <button id="normalHikeUpBtn">끌올하기</button>
                           <button id="normalEditBtn">수정하기</button>
                           <button id="normalDeleteBtn">등록 취소</button>
                     </div>
                  </c:if>
               </div>
               
               
               <c:if test="${sessionScope.muuid != detail.muuid &&detail.tnormalstate == 0}">
    <!-- 중복 없으면 빈하트 최지은 -->
                   <c:choose>
                <c:when test="${hasWish eq '0' or empty hasWish}">
                 <img src="../img/heartbin.png" 
             id="addWishList" align="left" style="cursor:pointer; width: 30px;">
          </c:when>
             <c:otherwise>
                 <img src="../img/heart.png" 
              id="delWishList" align="left" style="cursor:pointer; width: 30px;">
             </c:otherwise>
            </c:choose>
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
         </div><!-- 판매상세정보 -->
         
         </div> <!-- 사진제외div -->

   </section>
   <!-- Footer-->

</body>

<script type="text/javascript">

   $(function() {
      $("#toggleBtn").click(function() {

			//$(".otherBtnBox").toggle(800); // 속도조절
			$(".toggleBtnBox").toggleClass("btnClicked"); // 버튼위로이동
			$(".otherBtnBox").toggleClass("hide");

         if ($(".toggleBtnBox").hasClass("btnClicked")) {
            $(".otherBtnBox").addClass("tBtnBox");

         } else {
            $(".otherBtnBox").removeClass("tBtnBox");
         }
      })
   });
   
</script>

<script type="text/javascript">
   
let lat = document.getElementById("lat").value;
let lng = document.getElementById("lng").value;

var markerPosition  = new kakao.maps.LatLng(lat, lng); 

var marker = {
   position: markerPosition
};

var staticMapContainer  = document.getElementById('map'), 
   staticMapOption = { 
      center: new kakao.maps.LatLng(lat, lng),
      level: 3,
      marker: marker
    }; 

var staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
   
   $(function(){
      let tno = $(".normalTno").val();
      let mnickname = $(".mnickname").val();
      let tnormalprice = $(".tnormalprice").val();
      let sellerMnickname = $(".sellerMnickname").val();
      let sellerMuuid = $(".sellerMuuid").val();
      let tnormalhikeup = parseInt($(".tnormalhikeup").val(), 10);
      let buyerMuuid = '${sessionScope.muuid}';
      
   //끌올
        $("#normalHikeUpBtn").click(function(){
           if(tnormalhikeup >= 3){
              alert("더이상 끌올을 사용할 수 없습니다.");
              return false;
           }
           
           
          if(confirm("끌어올리기는 게시글당 3번만 가능합니다. 게시글을 끌어올릴까요?")){
             $.ajax({
               url : "./normalHikeUp",
               type : "post",
               data : {tno : tno, tnormalhikeup : tnormalhikeup},
               dataType : "json",
               success : function(data){
                  if(data.noNeedToHikeUp ==1){
                     alert("이미 제일 최근 게시판입니다.");
                     return false;
                  }
                  
                  
                  if(data.tnormalhikeupok == 1){
                     tnormalhikeup = tnormalhikeup + 1;
                     hikeupresult = 3-tnormalhikeup;
                     alert("끌올이 성공적으로 완료되었습니다.\n남은 끌올 횟수는 "+hikeupresult+"회 입니다.");
                     
                     
                     location.href='/redirectnormalDetail?tno='+data.tno;
                  }
               },
               error : function(error){
                  alert("에러가 발생했습니다.");
               }
                
             });
             
          }
          
        });
   
      $("#normalEditBtn").click(function(){
         if(confirm("수정하시겠습니까?")){
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
                  }else{
                     return false;
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
      

      /*       최지은이건드림 */
       $('.moveprofile').click(function() {
           var muuid = '${detail.muuid}';
           window.location.href = '/profileMember?muuid=' + muuid;
       });
      

      
/*       $("#requestChatBtn").click(function(){
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