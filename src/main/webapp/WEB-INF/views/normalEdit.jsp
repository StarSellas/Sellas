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
		<script src="./js/wnInterface.js"></script> 
		<script src="./js/mcore.min.js"></script> 
		<script src="./js/mcore.extends.js"></script> 
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
		<script type="text/javascript">
		function resizeImage(input, maxWidth, maxHeight, callback) {
		    if (input.files && input.files[0]) {
		        var reader = new FileReader();

		        reader.onload = function (e) {
		            var image = new Image();
		            image.src = e.target.result;

		            image.onload = function () {
		                var width = image.width;
		                var height = image.height;

		                if (width > maxWidth || height > maxHeight) {
		                    var ratio = Math.min(maxWidth / width, maxHeight / height);
		                    width *= ratio;
		                    height *= ratio;
		                }

		                var canvas = document.createElement("canvas");
		                canvas.width = width;
		                canvas.height = height;
		                var ctx = canvas.getContext("2d");
		                ctx.drawImage(image, 0, 0, width, height);

		                var resizedDataUrl = canvas.toDataURL("image/jpeg");
		                callback(resizedDataUrl);
		            };
		        };

		        reader.readAsDataURL(input.files[0]);
		    }
		}

		</script>



		<div class="container px-4 px-lg-5 mt-5 tradecontainter"
			style="z-index: 10" id="productContainer">
			<div
				class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
				<form action="./normalEdit" method="post"
					enctype="multipart/form-data">
					<input type="hidden" value="${detail.tno }" name="tno" id="tno">
					<input type="hidden" value="${muuid }" name="muuid"> <input
						type="text" placeholder="제목을 입력해주세요" name="ttitle" value="${detail.ttitle }" maxlength="30" id="ttitle"><br>
					<br>카테고리
					 <select name="category" >
						<c:forEach items="${categoryList }" var="i">
							<option value="${i.ino }" id="ino">${i.iname }</option>
						</c:forEach>
					</select> <br><br><br>
					내용
					<div>
						<textarea placeholder="내용을 입력해주세요." name="tcontent" id="tcontent" >${detail.tcontent }</textarea>
					</div>
					<br> <br> 가격 : <input type="number" name="tnormalprice" value="${detail.tnormalprice }" id="tnormalprice">원


					<br>
					
					
					
					<c:if test="${normalDetailImage ne null }">
					현재 사진입니다.
					<c:forEach items="${normalDetailImage }" var="i" varStatus="loop">
					<div  class="image-container">
					<img alt="" src="./tradeImgUpload/${i.timage }" width="200px" height="200px" class="normalTradeImg"><br>
					<button type="button" class="normalTradeChangeBtn" data-image-name="${i.timage}">사진 변경하기</button>
					<input type="hidden" name="selectedImage${loop.index}" value="" id="selectedImageInput">
					<div class="box"></div>
					</div>
					</c:forEach>
					</c:if>
					<br>
					<br>

					<br> <br> <br> <br> <br> <br>

					<button type="button" id="normalEditBtn">수정하기</button>
					<input type="button" onclick="location.href='./normalDetail?tno=${detail.tno}'" value="취소"/>
				</form>





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
	<script type="text/javascript">
        
	 $(function () {
		 
		 
		 
	        $(".normalTradeChangeBtn").click(function () {
	            var imageName = $(this).data("image-name"); // 선택한 이미지 이름 가져오기
	            var container = $(this).closest(".image-container");
	            container.find("input[type=hidden]").val(imageName); // hidden input의 값을 설정
	        });
	    });
	
	
	
       
        
	 $(function () {
		    var editPhotoSize = ${normalDetailCount};
		    var maxPhotos = 3;
		    var nextPhotoId = 1 + editPhotoSize;
		    let $previewImgArray = [];
		    let count = 0;
		    let selectImagePath = '';
		    let $previewImg = null;
			let OriginalImgArray = {};
		    $(".normalTradeChangeBtn").click(function () {
		        // 선택한 이미지 이름 가져오기
		        var imageName = $(this).data("image-name");
		        var container = $(this).closest(".image-container");
		        // hidden input의 값을 설정
		        container.find("input[type=hidden]").val(imageName);
		    });

		    $(".normalTradeChangeBtn").each(function (index) {
		        // 현재 .normalTradeChangeBtn에 대한 상위 .image-container 찾기
		        var container = $(this).closest(".image-container");
		        // .box 엘리먼트 찾기
		        var boxElement = container.find(".box");
		        var imageName = $(this).data("image-name");
		        $(this).click(function () {
		            // 이미 미리보기가 있으면 제거
		            if ($previewImg !== null) {
		                $previewImg.remove();
		                $previewImg = null;
		            }
		            selectImagePath = '';
		            OriginalImgArray[count] = imageName;
		            // 이미지 피커 열기
		            $.imagePicker()
		                .then(({ status, result }) => {
		                    if (status === 'SUCCESS') {
		                        // 선택한 이미지 경로 저장
		                        $previewImgArray[count] = result.path;
		                        return $.convertBase64ByPath2($previewImgArray);
		                    } else {
		                    	OriginalImgArray[count] = null;
		                        return Promise.reject('이미지 가져오기 실패')
		                    }
		                })
		                .then(({ status, result }) => {
		                    if (status === 'SUCCESS') {
		                        // 이미지를 Base64로 변환하여 프리뷰 이미지 만들기
		                        let imageSrc = "data:image/png;base64," + result[count].data;
		                        let $previewImg = $(document.createElement('img'));
		                        $previewImg.attr('height', '200px');
		                        container.find(".normalTradeImg").attr('src', imageSrc);
		                        // .box 엘리먼트에 프리뷰 이미지 추가
		                        //boxElement.append($previewImg);
		                        count++;
		                    } else {
		                        return Promise.reject('이미지 가져오기 실패');
		                    }
		                })
		                .catch((err) => {
		                    if (typeof err === 'string') alert(err);
		                    console.error(err);
		                });
		        });
		    });
        
        
        $.imagePicker = function () {
		      return new Promise((resolve) => {
		        M.media.picker({
		          mode: "SINGLE",
		          media: "PHOTO",
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
		    	      url: 'http://172.30.1.52:8080/file/upload2',
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
        
        //유효성 검사를 시작해볼까...


			//가격으로 장난치지 않게 10원이랑 1원단위 자르기
			$("#tnormalprice").on("change", function() {
			    var priceValue = $(this).val();


			        let priceCut = priceValue % 100;
			        if (priceCut !== 0) {
			        	priceValue -= priceCut;
			            $(this).val(priceValue);
			        }
			    
			});
			
			
			
			$("#normalEditBtn").click(function(){
				let tnormalprice = 	$("#tnormalprice").val();
				let muuid = $("#muuid").val();
				let ino = $("#ino").val();
				let tno = $("#tno").val();

				//제목 안 썼을 때
				let ttitle = $("#ttitle").val();
				if(ttitle.length < 5){
					alert("제목은 5글자 이상 작성해주세요.");
					 $("#ttitle").focus();
					return false;
				}
				//카테고리 설정 안 했을 때
				
				//내용 안 썼을 때
				let tcontent = $("#tcontent").val();
				if(tcontent.length < 5){
					alert("내용은 5글자 이상 작성해주세요.");
					 $("#tcontent").focus();
					return false;
				}
				//가격 안 적었을 때
				if($("#tnormalprice").val() == null || $("#tnormalprice").val() == 0){
					alert("가격을 입력해주세요.");
					$("#tnormalprice").focus();
					return false;
				}
				if($("#tnormalprice").val() < 1000){
					alert("최소가격은 1000 웨일페이 이상입니다.");
					$("#tnormalprice").focus();
					return false;
				}
				//1의 자리랑 10의 자리에 장난쳤을 때
		
				if(confirm("글을 작성하시겠습니까?")){
					let  OriImgMap = {};
					for (let i = 0; i < OriginalImgArray.length; i++) {
						OriImgMap[i] = OriginalImgArray[i];
					}
					$.ajax({
						url : "./normalEdit",
						type : "post",
						data : {ttitle : ttitle, tcontent: tcontent, ino : ino, muuid : muuid, tnormalprice: tnormalprice,
							 tno : tno, OriginalImgArray : OriginalImgArray},
						dataType : "json",
						success : function(data){
							if(data.ImgdeleteSuccess==1){
								if($previewImgArray.length > 0){

									$.uploadImageByPath2($previewImgArray,tno, (total, current) => {
										console.log(`total: ${total} , current: ${current}`)
									})
									.then(({
										status, header, body
									}) => {
										// status code
										if (status === '200') {
											const bodyJson = JSON.parse(body)
											
										} else {
											return Promise.reject(status)
										}
									})
									.catch((err) => {
										if (typeof err === 'string') alert(err)
										console.error(err)
									})
												
								}
							}
						},
						error : function(error){
							
						}
					});
					
					
					alert("작성이 완료되었습니다.");
					var form = document.createElement("form");
					form.method = "GET";
					form.action = "./normalDetail"; // 컨트롤러 경로 설정
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
			});
	 });
     
        </script>
</body>
</html>
