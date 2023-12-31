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
		<link href="css/addTradeItem.css" rel="stylesheet" />

		<!-- ******************* 추가 *********************** -->
		<link href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css" rel="stylesheet" >
		<link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet"  />
		<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a5bf13cc97cefa4fa07aebcc296ef6b7&libraries=services,clusterer,drawing"></script>
		<style type="text/css">
		.loading {
			background-color: white;
			z-index: 999;
		}
		#loading {
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			background-color: white; /* 배경색을 흰색으로 지정 */
			z-index: 999;
			text-align: center;
		}
		#loading_img {
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			object-fit: contain;
			z-index: 999;
			max-width: 100%;
			max-height: 100%;
		}
		</style>

<!--
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
	},3000);      
});
</script>
-->

	</head>
	<body>
	<%@ include file="menubar.jsp" %>
	
	<form method="post" name="frm" id="frm" onsubmit="return false;" autocomplete="off"></form>

	<form action="./addTradeItem" method="post" id="productContainer">

	<div class="page" id="page1">
         
		<div class="form-floating">
			<input class="form-control" type="text" id="title" name="title" placeholder="제목" maxlength="50" required="required">
			<label for="title">제목</label>
		</div>

		<div class="form-floating">
			<textarea class="form-control" id="content" name="content" placeholder="내용" required="required"></textarea>
			<label for="content">내용</label>
		</div>

		<input type="hidden" id="category" name="category" value="">
		<div id="categoryDiv">
			<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">카테고리</a>
					<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
						<c:forEach var="itemCategory" items="${itemCategory }">
							<li><div class="dropdown-item" id="category${itemCategory.key }" onclick="setCategory(${itemCategory.key })">${itemCategory.value }</div></li>
							<li><hr class="dropdown-divider" /></li>
						</c:forEach>
					</ul>
				</li>
			</ul>
		</div>

		<div class="accordion form-floating" id="accordion">
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePhoto" aria-expanded="false" aria-controls="collapsePhoto">
						사진 추가하기
					</button>
				</h2>
				<div id="collapsePhoto" class="accordion-collapse collapse">
					<div class="accordion-body">
						<button id="picker2" type="button"><img src="../img/image.png" width="38"></button>
						<button id="camera" type="button"><img src="../img/camera.png" width="38"></button>
					</div>
					<div class="swiper">
						<div class="swiper-wrapper"></div>
						<div class="swiper-pagination" id="paginationDiv"></div>
					</div>
					<div id="progress"></div>
					<div id="upload-box"></div>
				</div>
			</div>
		</div>

		<div class="form-floating">
			<button type="button" onclick="showPage('page2')">거래 희망 장소 선택하기</button>
		</div>

		<input type="hidden" id="locationLat" name="locationLat">
		<input type="hidden" id="locationLng" name="locationLng">

		<div class="form-floating">
			<button type="button" id="type0" onclick="selectTradeType('0')" class="selectedType">일반</button>
			<button type="button" id="type1" onclick="selectTradeType('1')">경매</button>
			<input type="hidden" id="tradeType" name="tradeType" value="0">
		</div>

		<div id="normalTradeDiv">
			<div class="form-floating">
				<input class="form-control ceiledNumber" type="number" id="normalPrice" name="normalPrice" placeholder="가격">
				<label for="normalPrice">가격</label>
			</div>
		</div>

		<div id="auctionTradeDiv" style="display:none">
			<div class="form-floating">
				<input class="form-control ceiledNumber" type="number" id="auctionStartPrice" name="auctionStartPrice" placeholder="경매시작가격">
				<label for="auctionStartPrice">경매시작가격</label>
			</div>
			<div class="form-floating">
				<input class="form-control ceiledNumber" type="number" id="auctionMinBidUnit" name="auctionMinBidUnit" placeholder="최소입찰단위">
				<label for="auctionMinBidUnit">최소입찰단위</label>
			</div>
		</div>

		<div class="form-floating">
			<button class="endTypeButton" type="button" id="addTradeItemBtn">확인</button>
		</div>

	</div>

	<div class="page" id="page2">
      
		<div id="map" style="width: 100%; height: 350px"></div>
		<div id="userLocationDiv"></div>
		<div>
			<!-- ${locationList } -->
			<div class="accordion form-floating" id="accordion">
				<div class="accordion-item">
					<h2 class="accordion-header">
						<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseLocaiton" aria-expanded="false" aria-controls="collapseLocaiton">
							내 장소 선택하기
						</button>
					</h2>
					<div id="collapseLocaiton" class="accordion-collapse collapse">
						<div class="accordion-body">
							<c:forEach var="locationList" items="${locationList }">
								<div>
									<div class="locationButtonDiv">
										<div class="locationNameDiv"><div>${locationList.lname }</div></div>
										<button class="locationButton" type="button" onclick="selectLocation('${locationList.lname}')">선택<!-- img src="../img/location.png" width="25" --></button>
										<input type="hidden" id="${locationList.lname }lat" value="${locationList.llat }">
										<input type="hidden" id="${locationList.lname }lng" value="${locationList.llng }">
									</div>
								</div>
							</c:forEach>
							<div class="addLocationDiv">
								<a class="text" href="./addTradeLocation">내 장소 등록하기</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="form-floating">
				<button type="button" onclick="markingCurrentLocation()">현재 위치로 설정하기</button>
			</div>
			<div class="form-floating">
				<button class="endTypeButton" type="button" onclick="showPage('page1')">선택 완료</button>
			</div>
		</div>

	</div>

	</form>

	<!-- Core theme JS-->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="js/addTradeItem.js"></script>

</body>

<script type="text/javascript">

// 모피어스 사진 촬영 및 앨범 사진 업로드
// 작성자 : 이대원 ヽ(´▽`)/

/* 이미지 */

let swiper = null;

function pagination() {
	if (swiper) {
		swiper.destroy();
		swiper = null;
		document.getElementById("paginationDiv").innerHTML = "";
	} 
	swiper = new Swiper(".swiper", {
		pagination: {
			el: ".swiper-pagination",
		},
		navigation: {
			nextEl: ".swiper-button-next",
			prevEl: ".swiper-button-prev",
		},
	});

}

$(function(){
let cameraImagePath ='';
let selectImagePath = [];
let $previewImg = null;
let $uploadImg = null;
let $previewImgArray = [];
let tradeType = 0;
let count = 0;

const $box = $('.swiper-wrapper');
const $uploadBox = $('#upload-box');
const $progress = $('#progress');
const $picker = $('#picker');
const $upload = $('#upload');
const $camera = $('#camera');
const $picker2 = $('#picker2');

$("#camera").click(function(){
   if ($box.find('img').length >= 4) {
	   M.pop.instance('더 이상 이미지를 추가할 수 없습니다.');
      return false;
   }

	/* 업로드 이미지 미리보기 슬라이드 적용 */
	selectImagePath = [];
	M.media.camera({
		path: "/media",
		mediaType: "PHOTO",
		saveAlbum: true,
		callback: function(status, result, option) {
			if (status == 'SUCCESS') {
              
				var photo_path = result.fullpath;
				$previewImgArray[count] = result.path;
				selectImagePath[0] = result.path;
				$.convertBase64ByPath2(selectImagePath)
				.then(({ status, result }) => {
					if (status === 'SUCCESS') {
						$previewImg = $(document.createElement('img'));
						$previewImg.attr('height', '275px');
						$previewImg.attr('width', '275px');
						$previewImg.attr('src', "data:image/png;base64," + result[0].data);
						$previewImg.attr('class','rounded');
						
						$slide = $(document.createElement('div'));
						$slide.attr('class', 'swiper-slide');
						$slide.append($previewImg);
						$box.append($slide);
						pagination();
						count++;
					} else {
						return Promise.reject('BASE64 변환 실패')
					}
				})
				.catch((err) => {
					if (typeof err === 'string') alert(err)
					console.error(err)
				})
				//  return $.uploadImageByPath(selectImagePath); 이거 쓰면 업로드됩니당
			}
		}
	});
}); 

$picker2.on('click', () => {
   if ($box.find('img').length >= 4) {
      alert('더 이상 이미지를 추가할 수 없습니다.');
      return false;
   }

   
   if ($previewImgArray[0] === ''){
           $previewImg.remove();
           $previewImg = null;
   }
     
   selectImagePath = [];
   $.imagePicker2()
   .then(({ status, result }) => {
      if (status === 'SUCCESS') {
         for (let i = 0; i < result.length; i++) {
            $previewImgArray[count] = result[i].path;
            selectImagePath[i] = result[i].path;
            if(count > 3){
               $previewImgArray[count] = null;
            }
            
            count++;
         }
         return $.convertBase64ByPath2(selectImagePath)
      } else {
         return Promise.reject('이미지 가져오기 실패')
      }
   })
   .then(({ status, result }) => {
      if (status === 'SUCCESS') {
         for (let i = 0; i < result.length; i++) {
            if ($box.find('img').length >= 4) {
               continue;
            }
            
            $previewImg = $(document.createElement('img'));
			$previewImg.attr('height', '275px');
			$previewImg.attr('width', '275px');
			$previewImg.attr('src', "data:image/png;base64," + result[i].data);
			$previewImg.attr('class','rounded');
			
			$slide = $(document.createElement('div'));
			$slide.attr('class', 'swiper-slide');
			$slide.append($previewImg);
			$box.append($slide);
         }
         //alert($('.swiper-wrapper').children().length);
         pagination();
      } else {
         return Promise.reject('이미지 가져오기 실패');
      }
   })
   .catch((err) => {
	   M.pop.instance(err);
      if (typeof err === 'string') alert(err);
      
         console.error(err);
   });
});

$.imagePicker2 = function () {
   return new Promise((resolve) => {
      M.media.picker({
         mode: "MULTI",
         media: "PHOTO",
         maxCount : 4,
         //path: "/media",
         column: 3,
         callback: (status, result) => {
            resolve({ status, result })             
         }
      });
   })
}
             
$.convertBase64ByPath2 = function ($previewImgArray) {
   if (!Array.isArray($previewImgArray)) {
      throw new Error('$previewImgArray must be an array');
   }

   return new Promise((resolve) => {
      const results = [];

      const readNextFile = (index) => {
         if (index < $previewImgArray.length) {
            M.file.read({
               path: $previewImgArray[index],
               encoding: 'BASE64',
               indicator: true,
               callback: function (status, result) {
                  if (status === 'SUCCESS') {
                     results.push(result);
                     readNextFile(index + 1);
                  } else {
                     // Handle error
                     results.push(null); // Push null for failed file
                     readNextFile(index + 1);
                  }
               }
            });
         } else {
            resolve({ status: 'SUCCESS', result: results });
         }
      };

      readNextFile(0);
   });
};
             
$.uploadImageByPath2 = function ($previewImgArray, tno, progress) {
   return new Promise((resolve) => {
      const _options = {
         url: 'http://172.30.1.67:8080/file/upload2',
         header: {},
         params: { tno: tno },
         body: $previewImgArray.map((filePath) => ({
         name: 'file',
         content: filePath,
         type: 'FILE',
      })),
      encoding: 'UTF-8',
      finish: (status, header, body, setting) => {
         resolve({ status, header, body });
      },
      progress: function (total, current) {
         progress(total, current);
      },
   };

   M.net.http.upload(_options);
   });
};
             
   $("#addPhoto").hide();
   $("#addPhotoBtn").click(function(){
      $("#addPhoto").show();
   });
             

   $("#addTradeItemBtn").click(function(){
         let category = $("input[name='category']").val();
         let title = $("input[name='title']").val();
         let content = $("textarea[name='content']").val();
         let locationLat = $("input[name='locationLat']").val();
         let locationLng = $("input[name='locationLng']").val();
         let tradeType = $("input[name='tradeType']").val();
         let normalPrice = $("input[name='normalPrice']").val();
         let auctionStartPrice = $("input[name='auctionStartPrice']").val();
         let auctionMinBidUnit = $("input[name='auctionMinBidUnit']").val();
         let auctionDeposit = 0;
         if(tradeType === "1"){
        	auctionDeposit = (parseFloat(auctionStartPrice) + parseFloat(auctionMinBidUnit)) * 0.1;
         	$.ajax({
         		url : "/checkBalance",
         		method : "get",
         		data : {price : auctionDeposit},
         		success : function(result){
         			if(result){
         				// 등록 가능
         			} else{
         				M.pop.instance("보증금이 부족합니다.");
         				return false;
         			}
         		},
         		error : function(error){
         			//alert("ERROR : " + JSON.stringify(error));
         		}
         	});
         }
         
         if(title.length < 5){
        	 M.pop.instance("제목은 5글자 이상 작성해주세요.");
        	 $("#title").focus();
        	 return false;
         }
         if(content.length < 5){
        	 M.pop.instance("내용은 5글자 이상 작성해주세요.");
        	 $("#content").focus();
        	 return false;
         }
         
         if(tradeType == 0){
        	 if(normalPrice == 0 || normalPrice == null || normalPrice == ''){
        		 M.pop.instance("가격을 입력해주세요.");
        		 return false;
        	 }
        	 if(normalPrice < 1000){
        		 M.pop.instance("최소 등록가격은 1000웨일 페이 이상입니다.");
        		 return false;
        	 }
         }
        if(tradeType == 1){
        	if(auctionStartPrice == 0 || auctionStartPrice == null || auctionStartPrice == ''){
        		M.pop.instance("시작 가격을 입력해주세요.");
        		return false;
        	}if(auctionMinBidUnit == 0 || auctionMinBidUnit == null || auctionMinBidUnit == ''){
        		M.pop.instance("최소 입찰단위를 입력해주세요.");
        		return false;
        	}
        }
         if(category == null || category == ''){
        	 M.pop.instance("카테고리를 선택해주세요.");
        	 return false;
         }
         if($previewImgArray.length == 0){
        	 M.pop.instance("사진을 추가해주세요.");
        		 return false;
         }
      $.ajax({
         url : "./addTradeItem",
         type : "post",
         data : {category : category, title : title, content : content, tradeType : tradeType,
                  locationLat : locationLat, locationLng : locationLng, normalPrice : normalPrice, 
                  auctionStartPrice: auctionStartPrice, auctionMinBidUnit : auctionMinBidUnit, auctionDeposit : auctionDeposit},
         dataType : "json",
         success : function(data){
            tradeType = data.tradeType;
            if(data.addSuccess == 1){
               
               let tno = data.tno;

               if($previewImgArray.length > 0){
               
                  if ($previewImgArray[0] === ''){
                     if ($uploadImg) {
                        $uploadImg.remove();
                        $uploadImg = null;
                     }
                  }
                              
                  $progress.text('')
                  $.uploadImageByPath2($previewImgArray,tno, (total, current) => {
                     console.log(`total: ${total} , current: ${current}`)
                     $progress.text(`${current}/${total}`)
                  })
                  .then(({
                     status, header, body
                  }) => {
                     // status code
                     if (status === '200') {
                        $progress.text('업로드 완료')
                        const bodyJson = JSON.parse(body)
                        $uploadImg = $(document.createElement('img'))
                        $uploadImg.attr('height', '200px')
                        $uploadImg.attr('src', bodyJson.fullpath)
                        $uploadBox.append($uploadImg)
                     } else {
                        return Promise.reject(status)
                     }
                  })
                  .catch((err) => {
                     if (typeof err === 'string') M.pop.instance(err)
                     console.error(err)
                  })
                           
               }
               M.pop.instance("작성이 완료되었습니다.");
               
               var form = document.createElement("form");
               form.method = "GET";
               if(tradeType == 0){
               form.action = "./normalDetail"; // 컨트롤러 경로 설정
               }
               if(tradeType == 1){
                  form.action = "./auctionDetail";
               }
               var input = document.createElement("input");
               input.type = "hidden"; // 숨겨진 필드
               input.name = "tno"; // 파라미터 이름
               input.value = tno; // 파라미터 값

               // input을 form에 추가
               form.appendChild(input);
                        
               document.body.appendChild(form);

               // 폼 전송
               form.submit();
                           
            }
         },
         error : function(error){
        	 M.pop.instance("오류가 발생했습니다.");
         }   
      });
   });
});
                
</script>

</html>