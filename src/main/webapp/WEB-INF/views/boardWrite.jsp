<%@page import="java.util.Map"%>
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
        <link href="css/boardWrite.css" rel="stylesheet" />
        
        <!-- ******************* 추가 *********************** -->
        <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
        <script src="./js/jquery-3.7.0.min.js"></script>
        
        <script type="text/javascript">
        	$(function(){
        		
        		// 게시판 카테고리 클릭
				$(".cateForWrite").click(function(){
					
					// 여기에다가 관리자 grade 아니면 클릭 못하게 막기 
					
					let cate = $(this).text().trim();	// 선택한 카테고리 이름
					console.log("바꿀카테고리 : "+ cate);
					$(".changeCateName").text(cate);	// 선택한 카테고리이름으로 변경
					
					let sname = $(".cateWrite").val();
					console.log("현재 sno: " + sname);	// 현재 카테고리 번호
					let sno = $(this).siblings(".changeCate").val();
					console.log("바꿀 sno :" + sno)
					
					let result = $(".cateWrite").val(sno);	// 선택한 카테고리 번호로 변경 (db로 가는 cate)
					console.log("최종 저장될 cate : " + result.val());
					
				})
				
				
				// 글쓰기 유효성 검사 (로그인&빈칸)
        		$(".bwriteButton").click(function(){
        			
        			let muuid = $(this).parent().siblings(".muuid").val();
        			let btitle = $(this).parent().siblings(".btitleBox").children(".btitle").val();
        			let bcontent = $(this).parent().siblings(".bcontentBox").children(".bcontent").val();
        			
        			alert(muuid + "제목 : " + btitle + "내용 : " + bcontent);
					
					if(btitle.length < 3){
						alert("제목을 입력하세요.");
						return false;
					}
					
					if(bcontent.length < 3){
						alert("내용을 입력하세요.");
						return false;
					}					
        			
        		});
				
        	});
        	
        	// 이미지 업로드
        	  $(function() {
  	        	
  	            var maxPhotos = 3;
  	            var nextPhotoId = 1;
  	
  	            $("#addPhotoButton").click(function () {
  	                
  	            	//console.log("떠라");
  	            	
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
        
            <div class="container mt-5" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">

					<!-- 게시판 카테고리 드롭다운 -->
					<div class="cateBox">
			            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4 align-items-end" id="cateBar">
			               <li class="nav-item dropdown">
			               <c:choose>
			                  <c:when test="${empty param}">
			                     <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
			                     role="button" data-bs-toggle="dropdown" aria-expanded="false">
			                     게시판
			                     </a>
			                  </c:when>
			                  <c:otherwise>
			                     <c:forEach items="${board}" var="board">
			                        <c:if test="${param.cate eq board.sno}">
			                           <a class="nav-link dropdown-toggle changeCateName" id="navbarDropdown" href="#"
			                           role="button" data-bs-toggle="dropdown" aria-expanded="false">
			                           ${board.sname }
			                           </a>
			                         </c:if> 
			                     </c:forEach>
			                  </c:otherwise>
			               </c:choose>
			               
			                  <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
								<c:forEach items="${board}" var="board">
									<li class="cateChange" >
										<a	class="dropdown-item cateForWrite" href="#"> ${board.sname }</a> 
										<input type="hidden" class="changeCate" value="${board.sno }">
									</li>
								</c:forEach>
							</ul>
			               </li>
			            </ul>
		            </div>
				
					<!-------------------- 글쓰기창 -------------------->
					<div class="bwriteContainer">
						<form action="./boardWrite"  class="bwriteForm" method="post" enctype="multipart/form-data">
							<div class="btitleBox">
								<input type="text" class="btitle" id="btitle" name="btitle" placeholder="제목을 입력해주세요">
							</div>
							
							<div class="bcontentBox">
								<textarea id="bcontent" class="bcontent" name="bcontent" placeholder="내용을 입력해주세요"></textarea>
							</div>
							
							<div class="bimageBox">
								<div id="photoInputs">
                    				<div id="imagePreviews"></div>
                    			</div>
                    			<div class="addPhotoBtnBox">
									<button id="addPhotoButton" type="button">사진 추가하기</button>
								</div>
							</div>
							<input type="hidden" name="muuid" class="muuid" value="${sessionScope.muuid }">
							<input type="hidden" class="cateWrite" name="cate" value="${param.cate}">
							
							<div class="bwriteBtnBox">
								<button type="submit" class="bwriteButton">글쓰기</button>
							</div>
						</form>
					</div>
					
				</div>
            </div>
            
        </section>
    </body>
</html>
