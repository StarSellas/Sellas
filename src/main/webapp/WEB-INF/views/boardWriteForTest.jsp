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
        
        <!-- ******************* 추가 *********************** -->
        <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
          <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        
         <!-- ******************* 모피어스 *********************** -->
		<script src="./js/wnInterface.js"></script> 
		<script src="./js/mcore.min.js"></script> 
		<script src="./js/mcore.extends.js"></script> 



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
        			let bcontent = $(this).parent().siblings(".bcontent").val();
        			
        			//alert(muuid + "제목 : " + btitle + "내용 : " + bcontent);
					
        			if(muuid == "" || muuid == null){
	        			alert("로그인이 필요한 서비스입니다.");
	        			return false;
        			}
        			
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
  
          
        </script>

    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
        <!-- Section-->
        <section class="py-5">
        
            <div class="container px-4 px-lg-5 mt-5" style="z-index: 10" id="productContainer">
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
									<li class="cateChange">
										<a	class="dropdown-item cateForWrite" href="#"> ${board.sname }</a> 
										<input type="hidden" class="changeCate" value="${board.sno }">
									</li>
								</c:forEach>
							</ul>
			               </li>
			            </ul>
		            </div>
				
					<!-------------------- 글쓰기창 -------------------->
					<div>
						<form action="./boardWrite" method="post" enctype="multipart/form-data">
							<div class="btitleBox">
								<input type="text" class="btitle" id="btitle" name="btitle" placeholder="제목을 입력해주세요">
							</div>
							
							<textarea id="bcontent" class="bcontent" name="bcontent" placeholder="내용을 입력해주세요"></textarea>

						
						<input type="hidden" name="muuid" class="muuid" value="${sessionScope.muuid }">
							<input type="hidden" class="cateWrite" name="cate" value="${param.cate}">
							<div class="bwriteBtnBox">
								<button type="submit" class="bwriteButton">글쓰기</button>
							</div>
						</form>
					</div>
					
					<!-------------------- 이미지업로드 -------------------->
				<div>
					<button id="pick-image">Image 선택하기</button>
				</div>
				<div id="preview-box">
					<!-- 이미지를 미리보기 생성 -->
				</div>
				<div>
					<button id="upload-image">Image 업로드하기</button>
				</div>
				<div id="upload-image-box">
					<!--  업로드된 경로로 이미지 태그 생성 -->
				</div>
			</div>
            </div>
        </section>
        
	<script>

  $(function () {

    $.imagePicker = function () {
      return new Promise((resolve) => {
        M.media.picker({
          mode: "SINGLE",
          media: "PHOTO",
          //path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
          column: 3,
          callback: (status, result) => {
            resolve({ status, result })
          },
        });
      });
    };

    $.convertBase64ByPath = function (imagePath) {
      if (typeof imagePath !== 'string') throw new Error('imagePath must be string')
      return new Promise((resolve) => {
        M.file.read({
          path: imagePath,
          encoding: 'BASE64',
          indicator: true,
          callback: function (status, result) {
            resolve({ status, result });
          },
        });
      });
    };

    $.uploadImageByPath = function (targetImgPath, progress) {
      return new Promise((resolve) => {
        const _options = {
          url: `${location.origin}/file/upload`,
          header: {},
          params: {},
          body: [
            //multipart/form-data 바디 데이터
            { name: "file", content: targetImgPath, type: "FILE" },
          ],
          encoding: "UTF-8",
          finish: (status, header, body, setting) => {
            resolve({ status, header, body })
          },
          progress: function (total, current) {
            progress(total, current);
          },
        };
        M.net.http.upload(_options);
      });
    };

  });


  $(function () {

    let selectImagePath = '';
    let $previewImg = null;
    let $uploadImg = null;
    const $box = $('#box');
    const $uploadBox = $('#upload-box');
    const $progress = $('#progress');
    const $picker = $('#picker');
    const $upload = $('#upload');



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

    $upload.on('click', () => {
      if (selectImagePath === '') return alert('이미지를 선택해주세요.')
      if ($uploadImg) {
        $uploadImg.remove();
        $uploadImg = null;
      }
      $progress.text('')
      $.uploadImageByPath(selectImagePath, (total, current) => {
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
            return Promise.reject('업로드를 실패하였습니다.')
          }
        })
        .catch((err) => {
          if (typeof err === 'string') alert(err)
          console.error(err)
        })
    })
  });


</script>
  	
    </body>
</html>
