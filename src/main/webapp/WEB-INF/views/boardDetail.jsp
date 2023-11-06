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
        
        	// 댓글 전체보기 페이지로 이동
        	function commentDetail(sno, bno){
        		location.href="/commentDetail?cate="+sno+"&bno="+bno;
        	}
        
     		// 글수정
	        function bedit(sno, bno){
	        	if(confirm("글을 수정하시겠습니까?")){
	             	location.href="/boardEdit?cate="+sno+"&bno="+bno;
	            }
	        }	
	        	
        	// 글삭제
        	function bdelete(sno, bno){
      			 if(confirm("글을 삭제하시겠습니까?")){
      				location.href="/boardDelete?cate="+sno+"&bno="+bno;
        		}
        	}
        	
        	// 댓글삭제
        	function cdelete(cno) {
        		if (confirm("댓글을 삭제하시겠습니까?")) {
        			location.href = "/commentDelete?cate=${param.cate}&bno=${param.bno}" + "&cno=" + cno;
        		}
        	}
        	
        	// 댓글수정
        	$(function() {
        	
        		$(".cedit").click(function() {
        			//alert("!");
        			let cno = $(this).parent().siblings(".cContentBox").children(".cno").val();
        			let bno = ${param.bno };
        			let cate = ${param.cate };
        			let cdeleteButton = $(this).siblings(".cdelete");
        			// 댓글내용
        			let ccontent = $(this).parent().siblings(".cContentBox").children(".content").text();
        			// 댓글박스
        			let contentBox = $(this).parent().siblings(".cContentBox");
        			// 댓글버튼박스
        			let cButtonBox = $(this).parent(".commentsBtn");
        			// 수정댓글창
        			let newContentBox = ""
        	
        			newContentBox += '<div class="newWriteBox">'
        				+ '<form action="./commentEdit" method="post">'
        				+ '<input type="hidden" name="bno" value="' + bno + '">'
        				+ '<input type="hidden" name="cno" value="' + cno + '">'
        				+ '<input type="hidden" name="cate" value="' + cate + '">'
        				+ '<textarea class="cContent" name="ccontent">'
        				+ ccontent
        				+ '</textarea>'
        				+ '<div class="commentsBtn">'
        				+ '<button type="submit">등록</button>' // 등록 버튼
        				+ '<button class="reset">취소</button>'
        				+ '</div>'
        				+ '</form>'
        				+ '</div>';
        	
        	
        			contentBox.after(newContentBox);
        			contentBox.hide();
        			cButtonBox.hide();
        	
        			// 수정취소버튼클릭 
        			$(".reset").click(function() {
        				$(this).parents(".newWriteBox").remove();
        				contentBox.show();
        				cButtonBox.show();
        			});
        	
        		}) // cedit 클릭이벤트
        		
        		// 댓글쓰기 유효성 검사 (로그인&빈칸)
        		$(".cWriteBtn").click(function(){
        			
        			let muuid = $(this).parent().siblings(".muuid").val();
        			let cContent = $(this).parent().siblings(".cContent").val();
					
        			if(muuid == "" || muuid == null){
	        			alert("로그인이 필요한 서비스입니다.");
	        			return false;
        			}
        			
					if(cContent == "" || cContent == null){
						alert("댓글을 입력해주세요");
						return false;
					}
        			//alert("댓글등록")
        		});
        	
        	});
			 
        </script>
        
    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
         <!-- Section-->
        <section class="py-5">
        
            <div class="cateName mt-4"><a href="/board?cate=${bdetail.sno }">${bdetail.sname } (${bdetail.bno })</a></div>
            <div class="container mt-5" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">
                    

				<!-------------------- 게시글창 -------------------->
				
				<div class="detailContainer justify-content-center">
					
					<div class="titleBox">
						<div class="btitle">
							${bdetail.btitle }
						</div>
						<div class="mnickname">${bdetail.mnickname } 
							<span class="bdate">${bdetail.bdate }</span>
						</div>
					</div>
					
					<div class="contentBox">
						<div class="bcontent">${bdetail.bcontent }</div>
					</div>
					
					<div class="bimageBox">
					<!--<span>이미지 갯수 : ${bdetail.bimagecount}</span>-->
						<c:if test="${imageList ne null && bdetail.bimagecount ne 0}">
							<c:forEach items="${imageList}" var="imageList">
								<div class="boardImgBox"><img class="boardImg" src="/boardImgUpload/${imageList.bimage}"></div>
								<!--<span>${imageList.bimage}</span>-->
							</c:forEach>
						</c:if>
					</div>
					<div class="bBtnBox">
						<span class="bread">조회 : ${bdetail.bread }</span>
						<c:if test="${sessionScope.mnickname ne null && sessionScope.mnickname eq bdetail.mnickname}">
							<button class="bedit" onclick="bedit(${bdetail.sno}, ${bdetail.bno})">글수정</button>
						</c:if>
					</div>
				</div>
                   
                   <!-------------------- 댓글창 -------------------->
                   <div class="commentContainer">
                   
					<c:choose>
						<c:when test="${bdetail.commentcount eq 0}">
							<div class="noComments">댓글이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<div class="cWholeBtnBox">
								<button class="cWholeBtn" onclick="commentDetail(${bdetail.sno}, ${bdetail.bno})">댓글 전체보기</button>
							</div>
							<c:forEach items="${comments }" var="comments">
								<div class="commentBox">
										<div class="cContentBox">
											<input type="hidden" name="muuid" class="muuid" value="uuid : ${comments.muuid }">
											<input type="hidden" class="cno" value="${comments.cno }"/>
											<div class="chead">${comments.mnickname } <span class="cdate">${comments.cdate }</span></div>
											<div class="content">${comments.ccontent }</div>
										</div>
										<div class="commentsBtn">
											<c:if test="${sessionScope.mnickname ne null && sessionScope.mnickname eq comments.mnickname}">
												<button class="cedit">수정</button>
												<button class="cdelete" onclick="cdelete(${comments.cno })">삭제</button>
											</c:if>
										</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>

					<!-------------------- 댓글쓰기창 -------------------->
						<div class="cWriteBox">
							<form action="./commentWrite" method="post" class="commentWriteForm">
								<textarea class="cContent" name="ccontent"></textarea>
								<input type="hidden" name="muuid" class="muuid" value="${sessionScope.muuid }">
								<input type="hidden" name="cate" value="${param.cate }">
								<input type="hidden" name="bno" value="${param.bno }">
								<div class="commentsBtn">
									<button type="submit" class="cWriteBtn">등록</button>
								</div>
							</form>
						</div>
						<div class="bdeleteBtnBox">
							<button class="bdelete" onclick="bdelete(${bdetail.sno}, ${bdetail.bno})">글삭제</button>
                   		</div>
                   </div>

                   
                </div>
        	</div>
        </section>
    </body>
</html>