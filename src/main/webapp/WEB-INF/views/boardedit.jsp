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
        <link href="css/detail.css" rel="stylesheet">
        <script src="./js/jquery-3.7.0.min.js"></script>
        
        <script type="text/javascript">
        
        	$(function(){
        		
        		let bno = ${bdetail.bno};
        		let count = 0;
        		let noEditList = [];
        		let nameToRemove = [];	// delete할 bimage들
        		let data = {};	// delete할 bimage들 (ajax전송을 위한 객체)
        		
        		// 기존게시글 이미지 추출
        		$('.boardImgBox').each(function(){
        			bimageName = $(this).text();
        			//console.log("이미지들:" + bimageName);
        			noEditList.push(bimageName);
        			console.log("noEditList : " + noEditList);
        		})
        				
        		// 이미지 수정 버튼 클릭
        		$(".imgEditbtn").click(function(){
        			
        			count++;
        			// 이미지박스
        			let boardImgBox = $(this).parents(".boardImgBox");
        			// 이미지이름
        			let bimage = $(this).parents(".boardImgBox").text().trim();
        			// 이미지 수정 버튼 클릭 => 기존img 이름 nameToRemove 배열에 추가
        			nameToRemove.push(bimage);
        			console.log("nameToRemove : " + nameToRemove)
        			
        			//noEditList = noEditList.filter(item => !nameToRemove.includes(item));
        			//console.log("지운 후 noEditList : " + noEditList);
        			
        			// nameToRemove 배열을  data 객체로 변환(키값은 imgDel1, imgDel2....)
        			for (let i = 0; i < nameToRemove.length; i++) {
  						data["imgDel" + i] = nameToRemove[i];
        			}
        			// data에 bno추가
        			data.bno = bno;
	        		//console.log(data);
        			// {imgDel0: '20231031095234num0라이언2.png', imgDel1: '20231031095234num1라이언2.png'}
        			
	        		// 수정이미지 첨부박스
        			let imgInputBox = "";
        			imgInputBox += '<div class="boardimgBox">'
        						+  '<input type="file" name="boardimg" class="boardimg" id="boardimg">';
        						+  '<button id="addPhotoButton" type="button">사진 추가하기</button>';
        						+  '<div id="photoInputs"><div id="imagePreviews"></div></div>';
        			
        			boardImgBox.after(imgInputBox);
        			boardImgBox.hide();
        			
        		});
        		
        		// 글수정 버튼 클릭 => data(삭제할이미지)를 매개변수로 imgDelete 실행
        		$(".editbtn").click(function(){
        			imgDelete(data);
        		});
        		
        		// 이미지 삭제함수
        		function imgDelete(data){
        			
        			console.log("ajax로 보낼 data : " + JSON.stringify(data, null, 2));
        			
        			$.ajax({
						url : "./imgDelete",
						type : "post",
						data : data,
							dataType : "json",
							success : function(data) {
								
								// 이미지 삭제 성공 시 form 제출
								if(data.result == 1){
									formsubmit();  
								}
							},
							error : function(error) {
								alert("에러발생");
								}
						});
        		}
        		
        		//form 최종제출
		 		function formsubmit(){
					alert("form제출");
		 			document.getElementById('form').submit();
				}
        		
        	});
        
        </script>
        <script type="text/javascript">
        
      	  $(function() {
	        	
      		  	var bimagecount = ${bdetail.bimagecount}
	            var maxPhotos = 3-bimagecount;
      		  	console.log("이미지갯수:"+bimagecount);
      		  	console.log("최대:"+maxPhotos);
	            var nextPhotoId = 1;
	
	            $("#addPhotoButton").click(function () {
	                
	            	if (nextPhotoId <= maxPhotos) {
	                    var newInput = $("<input type='file' name='boardimg' class='boardimg' id='boardimg" + nextPhotoId + "'>");
	                    //var newPreview = $("<img class='imagePreview' id='imagePreview" + nextPhotoId + "' src='' alt='미리보기 이미지'>");
	                    $("#photoInputs").append(newInput);
	                    //$("#imagePreviews").append(newPreview);
							
	                       newInput.change(function () {
	                        resizeImage(this, 200, 200, function (resizedDataUrl) {
	                            var previewId = this.id.replace("boardimg", "imagePreview");
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
        
        
    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
        <!-- Section-->
        <section class="py-5">
        
            <div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
                <div class="justify-content-center">
                    
                 <div>글수정페이지</div>
                    
                   <div>
						<form action="./boardEdit" method="post" id="form" enctype="multipart/form-data">
							<div class="titleBox">
								<input type="text" class="" id="btitle" name="btitle" value="${bdetail.btitle }">
							</div>
							<div class="contentBox">
								<textarea class="contentBox" name="bcontent">${bdetail.bcontent }</textarea>
								<input type="hidden" name="bno" value="${bdetail.bno}">
								<input type="hidden" name="cate" value="${param.cate}">
							</div>
							
							<div class="bimageBox">
								<span>이미지 갯수 : ${bdetail.bimagecount}</span>
								<c:if test="${imageList ne null && bdetail.bimagecount ne 0}">
									<c:forEach items="${imageList}" var="imageList">
										<div class="boardImgBox"><img class="boardImg" src="/boardImgUpload/${imageList.bimage}">
										${imageList.bimage}<button class="imgEditbtn" type="button"></button></div>
									</c:forEach>
								</c:if>
								<div id="photoInputs">
                    				<div id="imagePreviews"></div>
                    			</div>
								<button id="addPhotoButton" type="button">사진 추가하기</button>
							</div>
						
						<div class="buttonBox">
							<button type="button" class="editbtn">수정하기</button>
						</div>
						</form>
					</div>
                   
                   
                </div>
            </div>
            
        </section>
   
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
