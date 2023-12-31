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
        <script src="./js/wnInterface.js"></script> 
      <script src="./js/mcore.min.js"></script> 
      <script src="./js/mcore.extends.js"></script> 
        
        <script type="text/javascript">
           $(function(){
              
              // 게시판 드롭다운 스타일조정
            $(".division2").hide();
              
              // 게시판 카테고리 클릭
            $(".cateForWrite").click(function(){
               
               let cate = $(this).text().trim();   // 선택한 카테고리 이름
               //console.log("바꿀카테고리 : "+ cate);
               $(".changeCateName").text(cate);   // 선택한 카테고리이름으로 변경
               
               let sname = $(".cateWrite").val();
               //console.log("현재 sno: " + sname);   // 현재 카테고리 번호
               let sno = $(this).siblings(".changeCate").val();
               //console.log("바꿀 sno :" + sno)
               
               let result = $(".cateWrite").val(sno);   // 선택한 카테고리 번호로 변경 (db로 가는 cate)
               //console.log("최종 저장될 cate : " + result.val());
               
            })
           });
           
          
        </script>
        
    </head>
    <body>
   <%@ include file="menubar.jsp" %>
   
        <!-- Section-->
        <section class="py-5 WholeContainer">
        
            <div class="container mt-5" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">

                <div class="backButton"><a href="javascript:history.back()"><i class="xi-angle-left xi-x"></i></a></div>

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
                        <c:forEach items="${board}" var="board" varStatus="loop">
                           <c:if test="${board.sno gt 1}">
                              <li class="cateChange" >
                                 <a   class="dropdown-item cateForWrite" href="#"> ${board.sname }</a> 
                                 <input type="hidden" class="changeCate" value="${board.sno }">
                              </li>
                              <li class="division${loop.index }"><hr class="dropdown-divider" /></li>
                           </c:if>
                        </c:forEach>
                     </ul>
                        </li>
                     </ul>
                  </div>
            
               <!-------------------- 글쓰기창 -------------------->
               <div class="bwriteContainer">
               
                     <div class="form-floating btitleBox">
                        <input type="text" class="form-control" id="btitle" name="btitle" placeholder="제목">
                     	<label for="title">제목</label>
                     </div>
                     
                     <div class="form-floating bcontentBox">
                        <textarea id="bcontent" class="form-control" name="bcontent" placeholder="내용"></textarea>
                     	<label for="tcontent">내용</label>
                     </div>
               <!-------------------- 이미지업로드  -------------------->

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
						

                     <input type="hidden" name="muuid" class="muuid" value="${sessionScope.muuid }">
                     <input type="hidden" class="cateWrite" name="cate" value="${param.cate}">
                     
                     <div class="bwriteBtnBox">
                        <button type="button" class="bwriteButton">글쓰기</button>
                     </div>
               </div>
               
            </div>
            </div>
            
        </section>

	<script type="text/javascript">
    $(function(){
   
   //모피어스를 이용한 카메라 사진 및 앨범 사진 넣기 by 대원
   let cameraImagePath ='';
   let selectImagePath = [];   //저장할 사진이 담길 배열
    let $previewImg = null;
    let $uploadImg = null;
    let $previewImgArray = [];   //미리보기 사진이 담길 배열
    let count = 0;
   
    
    const $box = $('#box');
    const $uploadBox = $('#upload-box');
    const $progress = $('#progress');
    const $picker = $('#picker');
    const $upload = $('#upload');
    const $camera = $('#camera');
    const $picker2 = $('#picker2');
    
    $("#camera").click(function(){
       if(selectImagePath.length >= 4){
    	   M.pop.instance("더 이상 사진을 추가할 수 없습니다.");
          return false;
       }
       
            
   M.media.camera({
       path: "/media",
       mediaType: "PHOTO",
       saveAlbum: true,
       callback: function(status, result, option) {
           if (status == 'SUCCESS') {
               var photo_path = result.fullpath;
               selectImagePath[count] = result.path;
               $previewImgArray[0] = result.path;
                $.convertBase64ByPath2($previewImgArray)
                .then(({ status, result }) => {
         if (status === 'SUCCESS') {
            //alert("뜨나?22")
           $previewImg = $(document.createElement('img'))
           $previewImg.attr('height', '200px')
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
               if(selectImagePath.length >= 4){
            	   M.pop.instance("더 이상 사진을 추가할 수 없습니다.");
                   return false;
                }
               
               $.imagePicker2()
                 .then(({ status, result }) => {
                   if (status === 'SUCCESS') {
                      for (let i = 0; i < result.length; i++) {
                         $previewImgArray[i] = result[i].path;
                        selectImagePath[count] = result[i].path;
                        if(count > 3){
                           selectImagePath[count] = null;
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
                  if ($box.find('img').length >= 4) {
                       
                       continue;
                    }

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
                      //path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
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
                      url: 'http://172.30.1.40:8080/fileUpload',
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
             
              
              $(".bwriteButton").click(function(){
                 
            	  let muuid = $(this).parent().siblings(".muuid").val();
                  let cate = $(this).parent().siblings(".cateWrite").val();
                  let btitle = $(this).parent().siblings(".btitleBox").children("#btitle").val();
                  let bcontent = $(this).parent().siblings(".bcontentBox").children("#bcontent").val();
                 
                 //alert(muuid + "제목 : " + btitle + "내용 : " + bcontent);
               
                 // 글쓰기 유효성 검사 (로그인&빈칸)
               if(btitle.length < 3){
            	   M.pop.instance("제목을 입력하세요.");
                  return false;
               }
               
               if(bcontent.length < 3){
            	   M.pop.instance("내용을 입력하세요.");
                  return false;
               }      
               
               $.ajax({
                  url : "./boardWrite",
                  type : "post",
                  data : {cate : cate, btitle : btitle, bcontent : bcontent, muuid : muuid},
                  dataType : "json",
                  
                  success : function(data){
                     if(data.addSuccess == 1){
                        
                        let bno = data.bno;
                        let cate = data.cate;
                        
                        //alert("이건? : "+ bno);
                        
                        if(selectImagePath.length > 0){
                           if (selectImagePath[0] === ''){
                                  if ($uploadImg) {
                                         $uploadImg.remove();
                                         $uploadImg = null;
                                 }
                            }
                              
                              $progress.text('')
                              $.uploadImageByPath2(selectImagePath, bno, cate, (total, current) => {
                                console.log(`total: ${total} , current: ${current}`)
                                $progress.text(`${current}/${total}`)
                              })
                                .then(({
                                  status, header, body
                                }) => {
                                  // status code
                                  if (status === '200') {
                                     //alert("떠라");
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
                        
                        M.pop.instance("작성이 완료되었습니다.");
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
                     alert("error");
                  }
                  
               });
               
              });
           });
                
   </script>

</body>

</html>