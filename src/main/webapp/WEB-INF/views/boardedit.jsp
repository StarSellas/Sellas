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
        <link href="css/boardWrite.css" rel="stylesheet">
        <script src="./js/jquery-3.7.0.min.js"></script>
        <script src="./js/wnInterface.js"></script> 
		<script src="./js/mcore.min.js"></script> 
		<script src="./js/mcore.extends.js"></script> 
        
    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
        <!-- Section-->
        <section class="py-5">
        
        	<div class="cateName mt-4"><a href="/board?cate=${bdetail.sno }">${bdetail.sname } (${bdetail.bno })</a></div>
            <div class="container mt-5" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">
                    
                    <!-------------------- 글수정창 -------------------->
                    
                   <div class="beditContainer justify-content-center">
						
							<div class="titleBox">
								<input type="text" class="btitle" id="btitle" name="btitle" value="${bdetail.btitle }">
							</div>
							
							<div class="contentBox">
								<textarea class="bcontent" name="bcontent">${bdetail.bcontent }</textarea>
								<input type="hidden" class="bno" name="bno" value="${bdetail.bno }">
								<input type="hidden" class="cate" name="cate" value="${param.cate}">
								<input type="hidden" class="bimagecount" name="bimagecount" value="${bdetail.bimagecount}">
								
							</div>

							<div class="bimageBox">
									<!--<span>이미지 갯수 : ${bdetail.bimagecount}</span>-->
									<c:if test="${imageList ne null && bdetail.bimagecount ne 0}">
										<c:forEach items="${imageList}" var="imageList">
											<div class="boardImgBox editImgBox">
												<img class="boardImg" src="/boardImgUpload/${imageList.bimage}">
												<button class="imgEditbtn" type="button" data-image-name="${imageList.bimage}">수정</button>
												<button class="imgDelbtn" type="button" data-image-name="${imageList.bimage}">삭제</button>
												<div class="box"></div>
											</div>
										</c:forEach>
									</c:if>
									
									<div id="photoInputs">
	                    				<div id="imagePreviews"></div>
	                    			</div>
										<div id="box"></div>
	                    			
	                    			<div class="addPhotoBtnBox">
										<button id="addPhotoButton" type="button">사진 추가하기</button>
									</div>
									<div class="otherBtnBox hide" id="addPhoto">
										<button id="picker2" type="button">앨범에서 추가</button>
										<button id="camera" type="button">카메라에서 추가</button>
										<div id="progress"></div>
										<div id="upload-box"></div>
									</div>
							</div>
							
							<div class="buttonBox">
								<button type="button" class="editbtn">수정하기</button>
								<button type="button"  onclick="history.back()" class="editCancelbtn">취소</button>
								<a href="javascript:history.back()"></a>
							</div>
					
					</div>
                   
                </div>
            </div>
            
        </section>
        
        <script type="text/javascript">
			 
               $(function(){
            	   
                  $(".addPhotoBtn").click(function(){
                     
                     //$(".otherBtnBox").toggle(800);   // 속도조절
                     $(".addPhotoBtnBox").toggleClass("btnClicked");   // 버튼위로이동
                     $(".otherBtnBox").toggleClass("hide");
                     
                     if($(".addPhotoBtnBox").hasClass("btnClicked")){
                        $(".otherBtnBox").addClass("tBtnBox");
                        
                     } else {
                        $(".otherBtnBox").removeClass("tBtnBox");
                     }
                  })
               });
               
    </script>
        
        
	<script type="text/javascript">
     
	//모피어스를 이용한 카메라 사진 및 앨범 사진 수정 by 대원
	
	 $(function () {
		 
	        $(".imgEditbtn").click(function () {
	            var imageName = $(this).data("image-name"); // 선택한 이미지 이름 가져오기
	            var container = $(this).closest(".boardImgBox");
	            container.find("input[type=hidden]").val(imageName); // hidden input의 값을 설정
	        });
	    });

	 
	 $(function () {
	        let bimagecount = $(".bimagecount").val();
		    var maxPhotos = 4;
		    var nextPhotoId = 1 + bimagecount;
		    let $previewImgArray = [];
		    let count = 0;
		    let selectImagePath = '';
		    let $previewImg = null;
			let OriginalImgArray = {};
			let addCount = 0;
	        let deleteCount = 0;
	        const $picker2 = $('#picker2');
	        const $box = $('#box');
	        const $camera = $('#camera');
	        
	        $("#addPhoto").hide();
	         $("#addPhotoButton").click(function(){
	            alert("사진은 앨범과 카메라 중 하나만 선택 가능합니다.");
	            $("#addPhoto").show();
	         });
	        
	         
	         $("#camera").click(function(){
	        		if ($box.find('img').length + bimagecount >= 4) {
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
	        						$previewImg.attr('width', '250px');
	        						$previewImg.attr('src', "data:image/png;base64," + result[count].data)
	        	           
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
	             if ($box.find('img').length + bimagecount >= 4) {
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
	                       if ($box.find('img').length + bimagecount >= 4) {
	                          
	                          $previewImgArray[i] = null;
	                          continue;
	                          }
	                       let imageSrc = "data:image/png;base64," + result[i].data;
	                       let $previewImg = $(document.createElement('img'));
	                       $previewImg.attr('width', '250px');
	                       $previewImg.attr('src', imageSrc);
	                       $box.append($previewImg);
	                       count++;
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
	           
	           //사진 삭제하기
	           $(".imgDelbtn").click(function(){
	               var imageName = $(this).data("image-name");
	                   var container = $(this).closest(".boardImgBox");
	                   OriginalImgArray[deleteCount] = imageName;
	                   deleteCount++;
	                   bimagecount--;
	                   container.remove();
	           });
   
	         
		    $(".imgEditbtn").click(function () {
		        // 선택한 이미지 이름 가져오기
		        var imageName = $(this).data("image-name");
		        var container = $(this).closest(".boardImgBox");
		        // hidden input의 값을 설정
		        container.find("input[type=hidden]").val(imageName);
		    });

		    
		    $(".imgEditbtn").each(function (index) {
		        // 현재 .normalTradeChangeBtn에 대한 상위 .image-container 찾기
		        var container = $(this).closest(".boardImgBox");
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
		                        $previewImg.attr('width', '250px');
		                        container.find(".boardImg").attr('src', imageSrc);
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
	    	
	    	$.uploadImageByPath2 = function ($previewImgArray, bno,cate, progress) {
		    	  return new Promise((resolve) => {
		    	    const _options = {
		    	      url: 'http://172.30.1.4:8080/fileUpload',
		    	      header: {},
		    	      params: { bno: bno, cate: cate },
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

			
			
			$(".editbtn").click(function(){
				let muuid = $(this).parent().siblings(".contentBox").children(".cno").val();
				let cate = $(this).parent().siblings(".contentBox").children(".cate").val();
    			let btitle = $(this).parent().siblings(".titleBox").children(".btitle").val();
    			let bcontent = $(this).parent().siblings(".contentBox").children(".bcontent").val();
    			let bno = $(this).parent().siblings(".contentBox").children(".bno").val();	
				 
				
				//카테고리 설정 안 했을 때
				
				if(btitle.length < 3){
					alert("제목을 입력하세요.");
					return false;
				}
				
				if(bcontent.length < 3){
					alert("내용을 입력하세요.");
					return false;
				}	
		
				if(confirm("글을 수정하시겠습니까?")){
					let  OriImgMap = {};
					for (let i = 0; i < OriginalImgArray.length; i++) {
						OriImgMap[i] = OriginalImgArray[i];
					}
					$.ajax({
						url : "./boardEdit",
						type : "post",
						data : {bno : bno, cate : cate, btitle : btitle, bcontent : bcontent, muuid : muuid, OriginalImgArray : OriginalImgArray},
						dataType : "json",
						success : function(data){
							
							if(data.ImgdeleteSuccess==1 || $previewImgArray.length > 0){
								if($previewImgArray.length > 0){
									$.uploadImageByPath2($previewImgArray,bno, cate,(total, current) => {
										console.log(`total: ${total} , current: ${current}`)
									})
									.then(({
										status, header, body
									}) => {
										// status code
										if (status === '200') {
											alert("성공!!");
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
							form.action = "./boardDetail"; // 컨트롤러 경로 설정
							var inputForbno = document.createElement("input");
							inputForbno.type = "hidden"; // 숨겨진 필드
							inputForbno.name = "bno"; // 파라미터 이름
							inputForbno.value = bno; // 파라미터 값
							var inputForcate = document.createElement("input");
							inputForcate.type = "hidden"; // 숨겨진 필드
							inputForcate.name = "cate"; // 파라미터 이름
							inputForcate.value = cate; // 파라미터 값

							// input을 form에 추가
							form.appendChild(inputForbno);
							form.appendChild(inputForcate);
							
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
