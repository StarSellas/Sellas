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
					<input type="hidden" value="${detail.tno }" name="tno">
					<input type="hidden" value="${muuid }" name="muuid"> <input
						type="text" placeholder="제목을 입력해주세요" name="ttitle" value="${detail.ttitle }" maxlength="30"><br>
					<br>카테고리
					 <select name="category" >
						<c:forEach items="${categoryList }" var="i">
							<option value="${i.ino }" >${i.iname }</option>
						</c:forEach>
					</select> <br><br><br>
					내용
					<div>
						<textarea placeholder="내용을 입력해주세요." name="tcontent" >${detail.tcontent }</textarea>
					</div>
					<br> <br> 가격 : <input type="number" name="tnormalprice" value="${detail.tnormalprice }">원


					<br>
					
					
					
					<c:if test="${normalDetailImage ne null }">
					현재 사진입니다.
					<c:forEach items="${normalDetailImage }" var="i" varStatus="loop">
					<div  class="image-container">
					<img alt="" src="./tradeImgUpload/${i.timage }" width="200px" height="200px" class="normalTradeImg"><br>
					<button type="button" class="normalTradeChangeBtn" data-image-name="${i.timage}">사진 변경하기</button>
					<input type="hidden" name="selectedImage${loop.index}" value="" id="selectedImageInput">
					<input type="file" style="display: none;" >
					</div>
					</c:forEach>
					</c:if>
					<br>
					<button id="addPhotoButton" type="button">사진 추가하기</button>
					<br> 최대 3장
					<div id="photoInputs">
						<div id="imagePreviews"></div>
					</div>
					<br> <br> <br> <br> <br> <br>

					<button type="submit" id="normalEditBtn">수정하기</button>
					<button onclick="href='./normalDetail?tno=${detail.tno}'">취소</button>
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
        	
        		var editPhotoSize =${normalDetailCount};
        	
            var maxPhotos = 3;
            var nextPhotoId = 1+editPhotoSize;

            $("#addPhotoButton").click(function () {
                if (nextPhotoId <= maxPhotos) {
                    var newInput = $("<input type='file' name='tradeimg' class='photoInput' id='tradeimg" + nextPhotoId + "'>");
                    var newPreview = $("<img class='imagePreview' id='imagePreview" + nextPhotoId + "' src='' alt='미리보기 이미지'>");
                    $("#photoInputs").append(newInput);
                    $("#imagePreviews").append(newPreview);

                    // 이미지를 선택하면 크기를 조정하여 미리보기 업데이트
                    newInput.change(function () {
                        resizeImage(this, 200, 200, function (resizedDataUrl) {
                            var previewId = this.id.replace("tradeimg", "imagePreview");
                            var preview = $("#" + previewId);
                            preview.attr("src", resizedDataUrl);
                        }.bind(this));
                    });

                    nextPhotoId++;
                } else {
                    alert("더 이상 사진을 추가할 수 없습니다.");
                    $("#addPhotoButton").hide();
                }
            });
        });

        $(".normalTradeChangeBtn").click(function () {
            // 해당 버튼와 상위 div 요소 선택
            var container = $(this).closest(".image-container");

            // 이미지 미리보기를 만들고 이미지 경로 설정
            var preview = $("<img class='imagePreview'>");
            preview.attr("src", container.find(".normalTradeImg").attr("src"));

            // 파일 업로드 입력 만들기
            var fileInput = $("<input type='file' class='fileInput' name='tradeimg'>");

            // 이미지와 파일 업로드 입력을 동적으로 추가
            container.append(preview);
            container.append(fileInput);

            // 이미지 숨기기, 수정 버튼 숨기기
            container.find(".normalTradeImg").hide();
            $(this).hide();
            // 이미지 선택하면 크기를 조정하여 미리보기 업데이트
            fileInput.change(function () {
                resizeImage(this, 200, 200, function (resizedDataUrl) {
                    preview.attr("src", resizedDataUrl);
                });
            });
        });
        
        
        
        //유효성 검사를 시작해볼까...
		$(function(){
			$("#normalEditBtn").click(function(){
				
				//제목 안 썼을 때
				
				//카테고리 설정 안 했을 때
				
				//내용 안 썼을 때
				
				//가격 안 적었을 때
				
				
				
				
				
				if(confirm("수정하시겠습니까?")){
					alert("수정이 완료되었습니다.");
				}
				
			});
		});

     
        </script>
</body>
</html>
