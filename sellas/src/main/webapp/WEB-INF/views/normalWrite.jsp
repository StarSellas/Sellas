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

		<div class="container px-4 px-lg-5 mt-5 tradecontainter"
			style="z-index: 10" id="productContainer">
			<div
				class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
				<form action="./normalWirte" method="post"
					enctype="multipart/form-data">
					<input type="hidden" value="${muuid }" name="muuid"> <input
						type="text" placeholder="제목을 입력해주세요" name="ttitle" id="ttitle" maxlength="30"><br>
					<br> 이 사이에 카테고리 설정해야징 <select name="category">
						<c:forEach items="${categoryList }" var="i">
							<option value="${i.ino }">${i.iname }</option>
						</c:forEach>
					</select> <br> <br> <br>
					<div>
						<textarea placeholder="내용을 입력해주세요." name="tcontent" id="tcontent"></textarea>
					</div>
					<br> <br> 가격 : <input type="number" name="tnormalprice"
						id="tnormalprice">원 <br>
					<button id="addPhotoButton" type="button">사진 추가하기</button>
					<br> 최대 3장
					<div id="photoInputs">
						<div id="imagePreviews"></div>
					</div>
					<br> <br> <br> <br> <br> <br>

					<button type="submit" id="normalWriteBtn">글쓰깅</button>
					<button type="button" onclick="location.href='./'">취소</button>
				</form>

				제이쿼리를 사용해서 유효성을 검사하고 카테고리 값도 ino로 바꾼 후 잘못된 값이 없으면 서브밋하게 만들어야지

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

        
        $(function () {
            var maxPhotos = 3;
            var nextPhotoId = 1;

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
                }
            });
        });

        
        //유효성 검사를 시작해볼까...
		$(function(){
			
			
			//가격으로 장난치지 않게 10원이랑 1원단위 자르기
			$("#tnormalprice").on("change", function() {
			    var priceValue = $(this).val();


			        let priceCut = priceValue % 100;
			        if (priceCut !== 0) {
			        	priceValue -= priceCut;
			            $(this).val(priceValue);
			        }
			    
			});
			
			
			
			$("#normalWriteBtn").click(function(){
				
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
					alert("작성이 완료되었습니다.");
				}
			});
		});




        
        
        
        
     
        </script>

</body>
</html>
