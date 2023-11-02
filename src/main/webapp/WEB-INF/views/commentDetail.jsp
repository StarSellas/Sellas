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
        
        	// 게시글 원문 페이지
        	function boardDetail(){
        		location.href = "/boardDetail?cate=${param.cate}&bno=${param.bno}";
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
	    	
	    	});
        
        </script>
        
    </head>
    <body>
	<%@ include file="menubar.jsp" %>
        <!-- Section-->
        <section class="py-5">
        
            <div class="container px-4 px-lg-5 mt-5" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">


				<div class="commentContainer">
					<button class="cWholeBtn" onclick="boardDetail()">원문보기</button>
					<c:forEach items="${comments }" var="comments">
						<div class="commentBox">
							<div class="cContentBox">
								<input type="hidden" class="cno" value="${comments.cno }" />
								<input type="hidden" class="bno" value="${comments.bno }" />
								<div>${comments.mnickname }
									// <span>${comments.cdate }</span>
								</div>
								<div class="content">${comments.ccontent }</div>
							</div>
							<div class="commentsBtn">
								<c:if test="${sessionScope.mnickname ne null && sessionScope.mnickname eq comments.mnickname}">
									<button class="cedit">수정</button>
									<button class="cdelete" onclick="cdelete(${comments.cno })">삭제</button>
								</c:if>
							</div>
							<hr>
						</div>
					</c:forEach>
				</div>

			</div>
            </div>
            
        </section>
    </body>
</html>
