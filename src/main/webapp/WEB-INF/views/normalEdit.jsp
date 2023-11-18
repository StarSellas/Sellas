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
<link href="css/normalEdit.css" rel="stylesheet" />

<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
   href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
      <script src="./js/jquery-3.7.0.min.js"></script>
      <script src="./js/wnInterface.js"></script> 
      <script src="./js/mcore.min.js"></script> 
      <script src="./js/mcore.extends.js"></script> 
      
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
      
</head>

<body>
 <%@ include file="menubar.jsp" %>
   <!-- Section-->
	<section class="py-5">

		<div class="container mt-5"	style="z-index: 10" id="productContainer">
			<div class="justify-content-center">
			
			<div class="tradecontainter">
				<form action="./normalEdit" method="post" enctype="multipart/form-data" class="normalEditFrm">
					<input type="hidden" value="${detail.tno }" name="tno" id="tno">
					<input type="hidden" value="${muuid }" name="muuid"> 
					
						<div id="ncategoryBox">
							<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
								<li class="nav-item dropdown">
								<a class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
									role="button" data-bs-toggle="dropdown" aria-expanded="false" data-ino="${detail.ino }">${detail.iname}</a>
								
									<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
										<c:forEach items="${categoryList }" var="i" varStatus="loop">
											<li class="category"><div class="dropdown-item" id="cate" data-ino="${i.ino }">
											${i.iname }
											<input type="hidden" id="ino" name="ino" value="${i.ino }">
											</div></li>
											<li class="division${loop.index }"><hr class="dropdown-divider" /></li>
										</c:forEach>
									</ul>
								</li>
							</ul>
						</div>
				
					<div class="form-floating titleBox">
						<input type="text" class="form-control" placeholder="제목" name="ttitle" required="required" value="${detail.ttitle }" maxlength="30" id="ttitle"><br>
						<label for="title">제목</label>
					</div>
					<div class="form-floating">
						<textarea class="form-control" placeholder="내용" name="tcontent" id="tcontent" >${detail.tcontent }</textarea>
						<label for="tcontent">내용</label>
					</div>
					<div class="form-floating priceBox">
						<input class="form-control" placeholder="가격" type="number" name="tnormalprice" value="${detail.tnormalprice }" id="tnormalprice" placeholder="가격">
						<label for="tnormalprice">가격</label>
					</div>
					
					<c:if test="${normalDetailImage ne null }">
						<c:forEach items="${normalDetailImage }" var="i" varStatus="loop">
							<div class="image-container">
								<div class="normalTradeImgBox"><img alt="" src="./tradeImgUpload/${i.timage }" class="normalTradeImg"></div>
									<div class="photoBtnBox">
										<button type="button" class="normalTradeChangeBtn" data-image-name="${i.timage}">사진 변경하기</button>
										<button type="button" class="normalTradeImageDeleteBtn" data-image-name="${i.timage}">사진 삭제하기</button>
									</div>
								<input type="hidden" name="selectedImage${loop.index}" value="" id="selectedImageInput">
								<div class="box"></div>
							</div>
						</c:forEach>
					</c:if>
					
						<div class="accordion form-floating" id="accordion">
							<div class="accordion-item">
								<h2 class="accordion-header">
									<button class="accordion-button collapsed" id="addPhotoBtn" type="button"
										data-bs-toggle="collapse" data-bs-target="#collapsePhoto"
										aria-expanded="false" aria-controls="collapsePhoto">
										사진 추가하기</button>
								</h2>
								<div id="collapsePhoto" class="accordion-collapse collapse">
									<div class="accordion-body">
										<button id="picker2" type="button">
											<img src="../img/image.png" width="38">
										</button>
										<button id="camera" type="button">
											<img src="../img/camera.png" width="38">
										</button>
									</div>
									<div id="box"></div>
									<div id="progress"></div>
									<div id="upload-box"></div>
								</div>
							</div>
						</div>

						<div class="nEditBtnBox">
					<button type="button" id="normalEditBtn">수정하기</button>
					<button type="button" id="normalEditCBtn" onclick="location.href='./normalDetail?tno=${detail.tno}'">취소</button>
				</div>
				</form>


</div>
			</div>
		</div>

	</section>

   <script type="text/javascript">
        
   
   $(function(){
		
		
	});
   
    $(function () {
           $(".normalTradeChangeBtn").click(function () {
               var imageName = $(this).data("image-name"); // 선택한 이미지 이름 가져오기
               var container = $(this).closest(".image-container");
               container.find("input[type=hidden]").val(imageName); // hidden input의 값을 설정
           });
       });
   
        
    $(function () {
          var editPhotoSize = ${normalDetailCount};
          var maxPhotos = 4;
          var nextPhotoId = 1 + editPhotoSize;
          let $previewImgArray = []; //미리보기 이미지가 담기는 배열
          let addPhotoArray = []; //추가 및 변경되는 이미지가 담기는 배열
          let count = 0;
          let selectImagePath = '';
          let $previewImg = null;
         let OriginalImgArray = []; //삭제할 값이 담기는 배열
         let addCount = 0;
         let deleteCount = 0;
         const $picker2 = $('#picker2');
         const $box = $('#box');
         const $camera = $('#camera');
         
         
          $("#camera").click(function(){
                if ($box.find('img').length + editPhotoSize >= 4) {
                   alert('더 이상 이미지를 추가할 수 없습니다.');
                   return false;
                }
                if ($previewImgArray[0] === ''){
                  if ($uploadImg) {
                     $uploadImg.remove();
                     $uploadImg = null;
                  }
               }
            M.media.camera({
                path: "/media",
                mediaType: "PHOTO",
                saveAlbum: true,
                callback: function(status, result, option) {
                    if (status == 'SUCCESS') {
                       //alert("뜨나?11")
                        var photo_path = result.fullpath;
                        $previewImgArray[0] = result.path;
                        addPhotoArray[count] = result.path;
                         $.convertBase64ByPath2($previewImgArray)
                         .then(({ status, result }) => {
                  if (status === 'SUCCESS') {
                     //alert("뜨나?22")
                    $previewImg = $(document.createElement('img'))
                    $previewImg.attr('width', '250px')
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
                        
                     // return $.uploadImageByPath2(selectImagePath); 이거 쓰면 업로드됩니당
                        
                    }
                }
              
                });
           }); 

         
         $picker2.on('click', () => {
            if ($box.find('img').length + editPhotoSize >= 4) {
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
                   let resultCount = 0;
                         let beforeCount = count;
                      for (let i = 0; i < result.length; i++) {
                         $previewImgArray[i] = result[i].path;
                         addPhotoArray[count] = result[i].path;
                         if(count+editPhotoSize >= 4){
                            addPhotoArray[count] = null;
                            continue;
                         }
                        count++;
                      }

                  return $.convertBase64ByPath2($previewImgArray)
               } else {
                  return Promise.reject('이미지 가져오기 실패')
               }
            })
            .then(({ status, result }) => {
               if (status === 'SUCCESS') {
                   for (let i = 0; i < result.length; i++) {
                           if ($box.find('img').length + editPhotoSize >= 4) {
                              $previewImgArray[i] = null;
                              continue;
                              }

                     let imageSrc = "data:image/png;base64," + result[i].data;
                     let $previewImg = $(document.createElement('img'));
                     $previewImg.attr('width', '250px');
                     $previewImg.attr('src', imageSrc);
                     $box.append($previewImg);
                  }
                   count = $previewImgArray.length;
               } else {
                  return Promise.reject('이미지 가져오기 실패');
               }
            })
            .catch((err) => {
               if (typeof err === 'string') alert(err);
                  console.error(err);
            });
         })
         
         //사진 삭제하기
         $(".normalTradeImageDeleteBtn").click(function(){
             var imageName = $(this).data("image-name");
                 var container = $(this).closest(".image-container");
                 OriginalImgArray[deleteCount] = imageName;
                 console.log("OriginalImgArray : " + OriginalImgArray);
                 deleteCount++;
                 console.log("deleteCount : " + deleteCount);
                 editPhotoSize--;
                 container.remove();
         });
         
         
         
         
          $(".normalTradeChangeBtn").click(function () {
        	  $(this).hide();
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
                  OriginalImgArray[deleteCount] = imageName;
                  // 이미지 피커 열기
                  $.imagePicker()
                      .then(({ status, result }) => {
                          if (status === 'SUCCESS') {
       
                              // 선택한 이미지 경로 저장
                              addPhotoArray[count] = result.path;
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
                              $previewImg.attr('width', '250px');
                              
                              container.find(".normalTradeImg").attr('src', imageSrc);
                              // .box 엘리먼트에 프리뷰 이미지 추가
                              //boxElement.append($previewImg);
                              
                              count++;
                              deleteCount++;
                              
                              
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
                path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
                column: 3,
                callback: (status, result) => {
                  resolve({ status, result })
                  
                }
              });
            })
          }
        
        $.imagePicker2 = function () {
           return new Promise((resolve) => {
              M.media.picker({
                 mode: "MULTI",
                 media: "PHOTO",
                 maxCount : 4,
                 path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
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
         
      	// 카테고리 드롭다운 스타일조정
 		$(".division7").hide();
      	
 		// 선택한 카테고리 보이도록 지정
 		
 		let selectedNum;
 		let cateChange = false;
 		
 		$(".category").click(function(){
 			
 			let selected = $(this).children("#cate").text().trim();
 			selectedNum = $(this).children("#cate").attr("data-ino");
 			$("#navbarDropdown").text(selected);
 			cateChange = true;	// 카테고리 변경여부
 		});
        
         $("#normalEditBtn").click(function(){
        	
        	let tnormalprice = $("#tnormalprice").val();
            let muuid = $("#muuid").val();
            let tno = $("#tno").val();
            
            let ino;
			if(cateChange){ // 카테고리 바꾼경우
				ino =  selectedNum;	
			} else { // 카테고리 안바꾼경우
				ino = $("#navbarDropdown").attr("data-ino");	
			}
            
            //제목 안 썼을 때
            let ttitle = $("#ttitle").val();
            if(ttitle.length < 5){
            	M.pop.instance("제목은 5글자 이상 작성해주세요.");
                $("#ttitle").focus();
               return false;
            }
            //카테고리 설정 안 했을 때
            
            //내용 안 썼을 때
            let tcontent = $("#tcontent").val();
            if(tcontent.length < 5){
            	M.pop.instance("내용은 5글자 이상 작성해주세요.");
                $("#tcontent").focus();
               return false;
            }
            //가격 안 적었을 때
            if($("#tnormalprice").val() == null || $("#tnormalprice").val() == 0){
            	M.pop.instance("가격을 입력해주세요.");
               $("#tnormalprice").focus();
               return false;
            }
            if($("#tnormalprice").val() < 1000){
            	M.pop.instance("최소 가격은 1000원 이상입니다.");
               $("#tnormalprice").focus();
               return false;
            }
            //1의 자리랑 10의 자리에 장난쳤을 때
      
            if(confirm("글을 수정하시겠습니까?")){
               let  OriImgMap = {};
               for (let i = 0; i < OriginalImgArray.length; i++) {
                  OriImgMap[i] = OriginalImgArray[i];
               }
               $.ajax({
                  url : "./normalEdit",
                  type : "post",
                  data : {ttitle : ttitle, tcontent: tcontent, ino : ino, muuid : muuid, tnormalprice: tnormalprice,
                      tno : tno, OriImgMap : OriImgMap},
                  dataType : "json",
                  success : function(data){
                     if(data.ImgdeleteSuccess==1 ||addPhotoArray.length > 0){
                        if(addPhotoArray.length > 0){
                           $.uploadImageByPath2(addPhotoArray,tno, (total, current) => {
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
                     setTimeout(function() {
                         form.submit();
                     }, 3000);
                  },
                  error : function(error){
                     
                  }
               });
               
               
               
            }
         });
    });
     
        </script>
</body>
</html>