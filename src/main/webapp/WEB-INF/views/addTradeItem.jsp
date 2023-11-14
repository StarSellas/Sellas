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
        
		<!-- ******************* 추가 *********************** -->
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="./js/jquery-3.7.0.min.js"></script>
		<script src="./js/wnInterface.js"></script> 
		<script src="./js/mcore.min.js"></script> 
		<script src="./js/mcore.extends.js"></script> 
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

	</head>
	<body>
	<form method="post" name="frm" id="frm" onsubmit="return false;" autocomplete="off"></form>
	<%@ include file="menubar.jsp" %>
		<!-- Section-->
		<section class="py-5">
			<div class="container px-4 px-lg-5 mt-5" style="z-index: 10" >
				<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
				</div>
			</div>
		</section>
        
        
        <form action="./addTradeItem" method="post" id="productContainer">
        
		<div class="page" id="page1">
		
			<div>카테고리
				<select name="category">
				<c:forEach var="itemCategory" items="${itemCategory }">
					<option value="${itemCategory.key }">${itemCategory.value }</option>
				</c:forEach>
				</select>
			</div>
			
			<div>제목
				<input type="text" name="title" maxlength="50" required="required">
			</div>
			
			<div>내용
				<textarea name="content" required="required"></textarea>
			</div>
			
			<button id="addPhotoBtn" type="button">사진 추가하기</button>
			<div id="addPhoto">
				<button id="picker2" type="button">앨범에서 추가</button>
				<button id="camera" type="button">카메라에서 추가</button>
				<div id="box"></div>
				<div id="progress"></div>
				<div id="upload-box"></div>
			</div>
			
			<button type="button" onclick="showPage('page2')">거래 희망 장소 선택하기</button>
			
			<input type="hidden" id="locationLat" name="locationLat">
			<input type="hidden" id="locationLng" name="locationLng">
			
			<div>거래타입
				<button type="button" id="type0" onclick="selectTradeType('0')" disabled="disabled">일반</button>
				<button type="button" id="type1" onclick="selectTradeType('1')">경매</button>
				<input type="hidden" id="tradeType" name="tradeType" value="0">
			</div>
			
			<div id="normalTradeDiv">일반거래
				<div>
					<input type="number" id="normalPrice" name="normalPrice" step="100">
				</div>
			</div>
			
			<div id="auctionTradeDiv" style="display:none">경매거래
				<div>
					<input type="number" id="auctionStartPrice" name="auctionStartPrice" step="100">
					<input type="number" id="auctionMinBidUnit" name="auctionMinBidUnit" step="100">
				</div>
			</div>
			<button type="button" id="addTradeItemBtn">확인</button>
		
		</div>
		
		<div class="page" id="page2">
		
			<div id="map" style="width: 100%; height: 350px"></div>
			<div id="userLocationDiv"></div>
			<div>
				${locationList }
				<c:forEach var="locationList" items="${locationList }">
					<div>
						<button type="button" onclick="selectLocation('${locationList.lname}')">${locationList.lname }</button>
						<input type="hidden" id="${locationList.lname }lat" value="${locationList.llat }">
						<input type="hidden" id="${locationList.lname }lng" value="${locationList.llng }">
					</div>
				</c:forEach>
				<button type="button" onclick="markingCurrentLocation()">현재 위치로 설정하기</button>
				<button type="button" onclick="showPage('page1')">선택 완료</button>
			</div>
			
		</div>
		
		</form>
        
		<!-- Bootstrap core JS-->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		<!-- Core theme JS-->
		<script src="js/addTradeItem.js"></script>
		
	</body>

<script type="text/javascript">

// 모피어스 사진 촬영 및 앨범 사진 업로드
// 작성자 : 이대원 ヽ(´▽`)/

let cameraImagePath ='';
let selectImagePath = [];
let $previewImg = null;
let $uploadImg = null;
let $previewImgArray = [];
let tradeType = 0;
let count = 0;

const $box = $('#box');
const $uploadBox = $('#upload-box');
const $progress = $('#progress');
const $picker = $('#picker');
const $upload = $('#upload');
const $camera = $('#camera');
const $picker2 = $('#picker2');
    
$("#camera").click(function(){
	if ($box.find('img').length >= 4) {
		alert('더 이상 이미지를 추가할 수 없습니다.');
		return false;
	}
	$("#picker2").hide();
   	 
	selectImagePath = [];
	M.media.camera({
		path: "/media",
		mediaType: "PHOTO",
		saveAlbum: true,
		callback: function(status, result, option) {
			if (status == 'SUCCESS') {
        	   
				var photo_path = result.fullpath;
				$previewImgArray[count] = result.path;
               
				$.convertBase64ByPath2($previewImgArray)
				.then(({ status, result }) => {
				if (status === 'SUCCESS') {
					$previewImg = $(document.createElement('img'))
					$previewImg.attr('height', '200px')
					$previewImg.attr('width', '200px');
					$previewImg.attr('src', "data:image/png;base64," + result[0].data)
           
					$box.append($previewImg);
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
	$("#camera").hide();
	if ($box.find('img').length >= 4) {
		alert('더 이상 이미지를 추가할 수 없습니다.');
		return false;
	}
	 
	if ($previewImg !== null) {
		$previewImg.remove();
		$previewImg = null;
	}
	selectImagePath = '';
	$.imagePicker2()
	.then(({ status, result }) => {
		if (status === 'SUCCESS') {
			for (let i = 0; i < result.length; i++) {
				$previewImgArray[i] = result[i].path;
			}
			return $.convertBase64ByPath2($previewImgArray)
		} else {
			return Promise.reject('이미지 가져오기 실패')
		}
	})
	.then(({ status, result }) => {
		if (status === 'SUCCESS') {
			for (let i = 0; i < result.length; i++) {
    	        	
				let imageSrc = "data:image/png;base64," + result[i].data;
				let $previewImg = $(document.createElement('img'));
				$previewImg.attr('height', '200px');
				$previewImg.attr('width', '200px');
				$previewImg.attr('src', imageSrc);
				$box.append($previewImg);
			}
		} else {
			return Promise.reject('이미지 가져오기 실패');
		}
	})
	.catch((err) => {
		if (typeof err === 'string') alert(err);
			console.error(err);
	});
})

$.imagePicker2 = function () {
	return new Promise((resolve) => {
		M.media.picker({
			mode: "MULTI",
			media: "PHOTO",
			maxCount : 4,
			// path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
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
			url: 'http://172.30.1.02:8080/file/upload2',
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
   			 
$(function(){
	$("#addPhoto").hide();
	$("#addPhotoBtn").click(function(){
		alert("사진은 앨범과 카메라 중 하나만 선택 가능합니다.");
		$("#addPhoto").show();
	});
				  
				  
				  
	$("#addTradeItemBtn").click(function(){
	      let category = $("select[name='category']").val();
	      let title = $("input[name='title']").val();
	      let content = $("textarea[name='content']").val();
	      let locationLat = $("input[name='locationLat']").val();
	      let locationLng = $("input[name='locationLng']").val();
	      let tradeType = $("input[name='tradeType']").val();
	      let normalPrice = $("input[name='normalPrice']").val();
	      let auctionStartPrice = $("input[name='auctionStartPrice']").val();
	      let auctionMinBidUnit = $("input[name='auctionMinBidUnit']").val();

			
		$.ajax({
			url : "./addTradeItem",
			type : "post",
			data : {category : category, title : title, content : content, tradeType : tradeType,
	               locationLat : locationLat, locationLng : locationLng, normalPrice : normalPrice, 
	               auctionStartPrice: auctionStartPrice, auctionMinBidUnit : auctionMinBidUnit},
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
								alert("업로드!!!!");
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
							if (typeof err === 'string') alert(err)
							console.error(err)
						})
									
					}
					alert("작성이 완료되었습니다.");
					
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
				alert("오류가 발생했습니다"+error);
			}	
		});
	});
});
			    	
</script>

</html>
