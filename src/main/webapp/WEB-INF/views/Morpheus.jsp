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
	
			<div class="container px-4 px-lg-5 mt-5 tradecontainter"
				style="z-index: 10" id="productContainer">
				<div
					class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
					<div>
						<input type="hidden" value="${muuid }" name="muuid" id="muuid"> 
						<input type="text" placeholder="제목을 입력해주세요" name="ttitle" id="ttitle" maxlength="30"><br>
						<br> 이 사이에 카테고리 설정해야징 <select name="category">
							<c:forEach items="${categoryList }" var="i">
								<option id="itemcategory" value="${i.ino }">${i.iname }</option>
							</c:forEach>
						</select> <br> <br> <br>
						<div>
							<textarea placeholder="내용을 입력해주세요." name="tcontent" id="tcontent"></textarea>
						</div>
						<br> <br> 가격 : <input type="number" name="tnormalprice"
							id="tnormalprice">원 <br>
						</div>
						<br> <br> <br> 
						<br> <br> <br>
	
	  <div>
	    <button id="picker" type="button">모바일 사진 추가하기</button>
	  </div>
	  
	  
	  <div>
	    <button id="picker2" type="button">사진분신술!!</button>
	  </div>
	  <br>
	  <div id="box"></div>
	  <br>
	  
	  
	  <div>
	    <button id="camera" type="button">카메라</button>
	  </div>
	  
	  
	  <br>
	  
	  
	  <div>
	    <button id="location" type="button">내위치(위도경도)</button>
	  </div>
	  
	  
	  <div id="progress"></div>
	  <div id="upload-box"></div>
						
	
	
						<button type="submit" id="normalWriteBtn">글쓰기</button>
						<button type="button" onclick="location.href='./'">취소</button>
						<br> <br> <br> <br> <br>
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
	
	        
	        //유효성 검사를 시작해볼까...
			$(function(){
				
				
				let cameraImagePath ='';
				let selectImagePath = '';
			    let $previewImg = null;
			    let $uploadImg = null;
			    let $previewImgArray = [];
			    
			    
			    const $box = $('#box');
			    const $uploadBox = $('#upload-box');
			    const $progress = $('#progress');
			    const $picker = $('#picker');
			    const $upload = $('#upload');
			    const $camera = $('#camera');
			    const $picker2 = $('#picker2');
			    
			    $("#camera").click(function(){
			    	 if ($previewImg !== null) {
					        $previewImg.remove();
					        $previewImg = null;
					      }
					      selectImagePath = '';
		    	M.media.camera({
		            path: "/media",
		            mediaType: "PHOTO",
		            saveAlbum: true,
		            callback: function(status, result, option) {
		                if (status == 'SUCCESS') {
		                    var photo_path = result.fullpath;
		                    selectImagePath = result.path;
		                    
		                     $.convertBase64ByPath(selectImagePath)
		                     .then(({ status, result }) => {
			          if (status === 'SUCCESS') {
			        	  

			            $previewImg = $(document.createElement('img'))
			            $previewImg.attr('height', '200px')
			            $previewImg.attr('src', "data:image/png;base64," + result.data)
			            
			            $box.append($previewImg);
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
			    
			    
			    
			    $("#location").click(function(){
			    	M.plugin("location").current({
			    	    timeout: 10000,
			    	    maximumAge: 1,
			    	    callback: function( result ) {
			    	        if ( result.status === 'NS' ) {
			    	            alert('This Location Plugin is not supported');
			    	        }
			    	        else if ( result.status !== 'SUCCESS' ) {
			    	            if ( result.message ) {
			    	                alert( result.status + ":" + result.message );
			    	            }
			    	            else {
			    	                alert( 'Getting GPS coords is failed' );
			    	            }
			    	        }
			    	        else {
			    	            if ( result.coords ) {
			    	                alert( JSON.stringify(result.coords) );
			    	            }
			    	            else {
			    	               alert( 'It cann\'t get GPS Coords.' );
			    	            }
			    	        }
			    	    }
			    	});
			    	
			    });
	
			    $picker.on('click', () => {
			      if ($previewImg !== null) {
			        $previewImg.remove();
			        $previewImg = null;
			      }
			      selectImagePath = '';
			      $.imagePicker()
			        .then(({ status, result }) => {
			          if (status === 'SUCCESS') {
			            selectImagePath = result.path;
			            return $.convertBase64ByPath(selectImagePath)
			          } else {
			            return Promise.reject('이미지 가져오기 실패')
			          }
			        })
			        .then(({ status, result }) => {
			          if (status === 'SUCCESS') {

			        	  
			            $previewImg = $(document.createElement('img'))
			            $previewImg.attr('height', '200px')
			            $previewImg.attr('src', "data:image/png;base64," + result.data)
			            
			            $box.append($previewImg);
			          } else {
			            return Promise.reject('BASE64 변환 실패')
			          }
			        })
			        .catch((err) => {
			          if (typeof err === 'string') alert(err)
			          console.error(err)
			        })
			    })
	
	
			    $picker2.on('click', () => {
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
				//임시로 만듬
			    $.imagePicker2 = function () {
				      return new Promise((resolve) => {
				        M.media.picker({
				          mode: "MULTI",
				          media: "PHOTO",
				          maxCount : 5,
				          // path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
				          column: 3,
				          callback: (status, result) => {
				            resolve({ status, result })
				            
				          
				          }
				        });
				      })
				    }
			    
			    
			    $.convertBase64ByPath = function (imagePath) {
			        if (typeof imagePath !== 'string') throw new Error('imagePath must be string')
			        return new Promise((resolve) => {
			          M.file.read({
			            path: imagePath,
			            encoding: 'BASE64',
			            indicator: true,
			            callback: function (status, result) {
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
			    
			    
			    $.uploadImageByPath = function (targetImgPath, tno, progress) {
			      return new Promise((resolve) => {
			        const _options = {
			          url: 'http://172.30.1.52:8080/file/upload',
			          header: {},
			          params: {tno : tno},
			          body: [
			            // multipart/form-data 바디 데이터
			            { name: "file", content: targetImgPath, type: "FILE" },
			          ],
			          encoding: "UTF-8",
			          finish: (status, header, body, setting) => {
			            resolve({ status, header, body })
			          },
			          progress: function (total, current) {
			            progress(total, current);
			          }
			        }
			        M.net.http.upload(_options);
			      })
			    }
			    
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
				let tnormalprice = 	$("#tnormalprice").val();
				let muuid = $("#muuid").val();
				let ino = $("#itemcategory").val();
				let tno = '';
			
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
		
					
					//ajax
					
					
					
					
					
					if(confirm("글을 작성하시겠습니까?")){
						
						$.ajax({
							url : "./normalWirteAjax",
							type : "post",
							data : {ttitle : ttitle, tcontent: tcontent, ino : ino, muuid : muuid, tnormalprice: tnormalprice},
							dataType : "json",
							success : function(data){
								tno = data.tno;
							if($previewImgArray[0].length > 0){
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
							          if (typeof err === 'string') alert(err)
							          console.error(err)
							        })
								
							}
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
								
							},
							error : function(error){
								alert("ㅠㅠ");
							}
							
						});
						
						
						
						 

					}
						
				});
			});

	        </script>
	
	</body>
	</html>
