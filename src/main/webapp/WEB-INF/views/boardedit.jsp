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
								<input type="hidden" class="bno" name="bno" value="${bdetail.bno}">
								<input type="hidden" class="cate" name="cate" value="${param.cate}">
							</div>

							<div class="bimageBox">
									<!--<span>이미지 갯수 : ${bdetail.bimagecount}</span>-->
									<c:if test="${imageList ne null && bdetail.bimagecount ne 0}">
										<c:forEach items="${imageList}" var="imageList">
											<div class="boardImgBox editImgBox">
												<img class="boardImg" src="/boardImgUpload/${imageList.bimage}">
												<button class="imgEditbtn" type="button">수정</button>
											</div>
										</c:forEach>
									</c:if>
									
									<div id="photoInputs">
	                    				<div id="imagePreviews"></div>
	                    			</div>
	                    			
	                    			<div class="addPhotoBtnBox">
										<button id="addPhotoButton" type="button">사진 추가하기</button>
									</div>
								</div>
							
							<div class="buttonBox">
								<button type="button" class="editbtn">수정하기</button>
							</div>
					
					</div>
                   
                </div>
            </div>
            
        </section>
        
        <script type="text/javascript">
	
	//모피어스를 이용한 카메라 사진 및 앨범 사진 넣기 by 대원
	let cameraImagePath ='';
	let selectImagePath = [];
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
    	
    	$("#picker2").hide();
    	
   	 if ($previewImg !== null) {
		        $previewImg.remove();
		        $previewImg = null;
		      }
		      selectImagePath = [];
	M.media.camera({
       path: "/media",
       mediaType: "PHOTO",
       saveAlbum: true,
       callback: function(status, result, option) {
           if (status == 'SUCCESS') {
        	   //alert("뜨나?11")
               var photo_path = result.fullpath;
               selectImagePath[0] = result.path;
               
                $.convertBase64ByPath2(selectImagePath)
                .then(({ status, result }) => {
         if (status === 'SUCCESS') {
        	 //alert("뜨나?22")
           $previewImg = $(document.createElement('img'))
           $previewImg.attr('height', '200px')
           $previewImg.attr('src', "data:image/png;base64," + result[0].data)
           
           $box.append($previewImg);
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
   				 $("#camera").hide();
   				 if ($box.find('img').length >= 5) {s
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
		    	
		    	$.uploadImageByPath2 = function ($previewImgArray, bno, cate, progress) {
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
   			 
			  $(function(){
				  $("#addPhoto").hide();
				  $("#addPhotoBtn").click(function(){
					  alert("사진은 앨범과 카메라 중 하나만 선택 가능합니다.");
					  $("#addPhoto").show();
				  });
				  
				  
				  $(".editbtn").click(function(){
					  
					let muuid = $(this).parent().siblings(".contentBox").children(".cno").val();
					let cate = $(this).parent().siblings(".contentBox").children(".cate").val();
        			let btitle = $(this).parent().siblings(".titleBox").children(".btitle").val();
        			let bcontent = $(this).parent().siblings(".contentBox").children(".bcontent").val();
        			
        			alert(muuid + "제목 : " + btitle + "내용 : " + bcontent);
					
        			// 글쓰기 유효성 검사 (로그인&빈칸)
					if(btitle.length < 3){
						alert("제목을 입력하세요.");
						return false;
					}
					
					if(bcontent.length < 3){
						alert("내용을 입력하세요.");
						return false;
					}		
					
					$.ajax({
						url : "./boardEdit",
						type : "post",
						data : {cate : cate, btitle : btitle, bcontent : bcontent, muuid : muuid},
						dataType : "json",
						
						success : function(data){
							if(data.addSuccess == 1){
								
								let bno = data.bno;
								let cate = data.cate;
								
								alert("이건? : "+ bno);
								
								if($previewImgArray[0].length > 0){
									if ($previewImgArray[0] === ''){
											 if ($uploadImg) {
											        $uploadImg.remove();
											        $uploadImg = null;
											}
									 }
								      
								      $progress.text('')
								      $.uploadImageByPath2($previewImgArray, bno, cate, (total, current) => {
								        console.log(`total: ${total} , current: ${current}`)
								        $progress.text(`${current}/${total}`)
								      })
								        .then(({
								          status, header, body
								        }) => {
								          // status code
								          if (status === '200') {
								        	  alert("떠라");
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
									
							}
						},
						error : function(error){
							alert("흑흑");
						}
						
					});
					
				  });
			  });
			    	
	</script>

    </body>
</html>
