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
        <link href="css/board.css" rel="stylesheet">
        
        <!-- ******************* 추가 *********************** -->
        <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
        <script src="./js/jquery-3.7.0.min.js"></script>
        
        <script type="text/javascript" defer>
	            
	     // 글제목 길면 자르기
	    	function cutTitle(){
	    	 
	        	$(".btitle").each(function() {
	        	    let title = $(this).children(".title").text();
	        	    //console.log(title);
	        	    //console.log(title.length);
	        	    
	        	    if(title.length > 12){
	            		titlecut = title.substring(0, 11) + " ...";
	            		//console.log("titlecut : " + titlecut);
	            		$(this).children(".title").text(titlecut);
	            	}
	        	});
	        	
	    	}	
        
            $(function(){
            	
            	// 게시판 드롭다운 스타일조정
				$(".division2").hide();
            	
            	cutTitle(); // 글제목 자르기
            	
            	// 글번호 숨김
            	$(".rowNum").hide();
            	
            	// 스크롤 페이징
            	let cate;
            	let search = "${param.search }";	// 값이 없는 경우에도 서버로 보내야함
            	let searchCate = "";
            	let currentPage = 1;	// 현재페이지
            	let isBottomHandled = false;	// 연속적인 요청 방지용
            	
            	if(${empty param}){	// 메인게시판인 경우 
            		cate = 0;
            	} else {
            		cate = $(".cateNum").val();
            	}
            	
            	//console.log("search값 잡아: " + search);
            	
            	// 스크롤 이벤트 발생
            	$(window).on("scroll",function(){

            		let scrollTop=$(window).scrollTop(); 		// 스크롤된 길이
            	    let windowHeight=$(window).height(); 		//웹브라우저의 창의 높이
            	    let documentHeight=$(document).height(); 	//문서 전체의 높이
            	    
            	    let isBottom=scrollTop+windowHeight + 10 >= documentHeight;	// 스크롤완료여부
            	    
            	    if(isBottom && !isBottomHandled){	
            	    	
            	    	nextPage(currentPage);	// 다음페이지 불러오는 함수	실행
            	    	currentPage++;
            	    	isBottomHandled = true;	// 연속적인 요청 방지용
            	    	
            	    } else if (!isBottom) {
            	    	
            	        isBottomHandled = false;
            	    }
            	
            // 다음페이지 불러오는 함수	
           	 function nextPage(currentPage){
            	
               let firstbno = $(".rowNum:first").attr("data-bno");	// 최상단글bno ***** 확인용 *****
               let lastbno = firstbno; 
               let lastRow = $(".boardRow:last");					// 최하단row
               let count = $(".boardRow").attr("data-count");		// 해당 카테고리의 글갯수
               let wholePage = Math.ceil(count/10);					// 전체페이지수(글의갯수/10의 올림) 
               
               //console.log("wholePage : " + wholePage);
               //console.log("count : " + count);
               //console.log("firstbno : " + firstbno);
               
               
                  // 다음페이지가 없다면 진행X
                  if(wholePage < currentPage){
                	  	//alert("마지막 페이지 입니다.");
   						return false;
                  }
                  
               		// 다음페이지가 있다면 진행
               		 let newRow = ""; 	// 추가될 tr
                     let data = {};		// ajax로 보낼 객체
                     
                     data.currentPage = currentPage;	// ***** 확인용 *****

                  	 lastbno = $(".rowNum:last").attr("data-bno"); // 최하단글bno
                     console.log("변경 lastbno : " + lastbno);
                  	
                  	 // 서버로 보낼것들 data에 담기
                     data.cate = cate;
                     data.lastbno = lastbno;
                     data.count = count;
                     data.search = search;
                     
                     $.ajax({
                          url: './nextPage',
                          type: 'post',
                          data: data,
                          dataType: 'json',
                          success: function(data) {
                        	  
                        	    if (data.list != null) { // 데이터가 있다면 뽑아내기
                        	        //alert("데이터와");
                        	        	
                        	        $(data).each(function() {
                        	        	//console.log("가져온list : " + this.list[0].bno + "~");
                        	        	
                        	        	for (let i = 0; i < this.list.length; i++) {
                        	        		
                        	        		newRow = "<tr class='boardRow' data-count='" + this.list[i].count + "'>" +
		                        	                "<td class='rowNum' data-bno='" + this.list[i].bno + "'>" + this.list[i].bno + "</td>" +
		                        	                "<td class='btitle' onclick=\"location.href='/boardDetail?cate=" + this.list[i].sno + "&bno=" + this.list[i].bno + "'\">" +
		                        	                    "<span class='title'>" + this.list[i].btitle + "</span>" +
		                        	                    " <i class='xi-speech-o count' id='counticon'></i>" +
		                        	                    " <span class='commentcount'>" + this.list[i].commentcount + "</span>" +
		                        	                    (this.list[i].bimagecount > 0 ? "<span class='bphotoBox'><img src='./img/board_photo.png' class='bphoto' alt='img'></span>" : "") +
		                        	                    "<div class='UserBox'>" +
		                        	                        "<div class='userImgBox'>" +
		                        	                        (this.list[i].mphoto ? "<img src='../userImgUpload/" + this.list[i].mphoto + "' alt='user-img' class='userImg'>": "<img src='./tradeImgUpload/defaultimg.jpg' alt='basic-user-img' class='userImg'>") +
		                        	                        "</div>" +
		                        	                        "<span class='mnickname'>" + this.list[i].mnickname + "</span>" +
		                        	                    "</div>" +
		                        	                "</td>" +
		                        	                "<td class='bdateBox'>" +
		                        	                    "<div class='bdate'>" + this.list[i].bdate + "</div>" +
		                        	                "</td>" +
		                        	              "</tr>";
	
	                    	                    lastRow.after(newRow); // lastRow 뒤에 추가
	                        	        	  
	                    	                  // 추가된 tr로 lastRow 재설정
	                                          lastRow = $(".boardRow:last");   // 최하단row
	                                          console.log("lastRow :" + i + "번째");
	                                          
	                                          $(".rowNum").hide();
	                                          
	                                      	 // 새로 불러온 글제목 자르기
	                                          cutTitle();	
	                                          
                        	        	}	// for
                        	        	
                        	        }); // .each
                        	        
                        	        $(".currentPage").text(currentPage); // ***** 페이지확인용 *****
                        	        
                        	    } // if(data.list != null)
                        	}, // success
                          
                          error: function(error) {
                              //alert("에러남");
                          }
                      }); // ajax
                      
            } // nextPage
               
            
            	});	// 스크롤
            
            	
            });          
            
            </script>  
            
					<script type="text/javascript">
						
					// 검색
						$(function(){
							
							$(".searchA").click(function() {
	   							 // 클릭된 항목에 active 클래스 추가
	    						$(this).addClass("active");
	    						// 다른 항목에서 active 클래스 제거
	   							$(".searchA").not(this).removeClass("active");
	    						
	    						let searchCate = $(this).text();
	    						//console.log(searchCate);
	    						$("#navbarSDropdown").text(searchCate);	// 선택한 카테고리 보여주기
							});
							
							// 검색버튼 클릭
							$(".swriteButton").click(function(){
								
								if($(".searchA").hasClass("active")){
									let selectedOption = $(".searchA.active").data("option");
									$(".searchCate").val(selectedOption);	// searchCate 서버로 보낼 input창에 넣기
									//console.log(selectedOption)
								} 
								
								$(".searchFrom").submit();	// form 제출
							});
							
							
							// 검색카테고리 & 검색단어 검색창에 남기기
			            	let searchCate = "${param.searchCate}";
			            	let search = "${param.search}";
			            	
			        		let firstOption = $(".searchCate option:first").val();
			        		$(".searchCate").val(firstOption);
			            	
			            	if (searchCate != ""){
			            		let pick = $("a.dropdown-item[data-option="+searchCate+"]").text();
								//console.log("선택한카테 : " + pick);
								$("#navbarSDropdown").text(pick);
			            		$(".swrite").val(search);
			            	}
							
						})
						
					</script>

    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
        <!-- Section-->
        <section class="py-5">
        
            <div class="container mt-4" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">
                
                
				<!-------------- 게시판 검색 & 카테고리 드롭다운 -------------->
				
				<div class="HeaderBox">
				
				<div class="searchBox">

						<form action="./board" method="get" class="searchFrom">

							<ul class="navbar-nav">
								<li class="nav-item dropdown">
									<a	class="nav-link dropdown-toggle" id="navbarSDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">검색</a>
									<ul class="dropdown-menu" aria-labelledby="navbarSDropdown">
										<li><a class="dropdown-item searchA" href="#" data-option="title">제목</a></li>
										<li><hr class="dropdown-divider" /></li>
										<li><a class="dropdown-item searchA" href="#" data-option="content">내용</a></li>
										<li><hr class="dropdown-divider" /></li>
										<li><a class="dropdown-item searchA" href="#" data-option="writer">글쓴이</a></li>
									</ul>
								</li>
							</ul>

							<input type="text" name="search" class="swrite"> 
							<input type="hidden" name="searchCate" class="searchCate" value="title">
							<input type="hidden" name="cate" value="${param.cate }" class="cateNum">
							<button type="button" class="swriteButton"><img src="../img/searchIcon.png" id="searchIcon" alt="searchIcon"></button>

						</form>
					</div>

					<div class="cateBox">
			            <ul class="navbar-nav">
			               <li class="nav-item dropdown">
			               <c:choose>
			                  <c:when test="${!empty param}">
			                     <c:forEach items="${board}" var="board">
				                        <c:if test="${param.cate eq board.sno}">
				                           <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
				                           role="button" data-bs-toggle="dropdown" aria-expanded="false">
				                           ${board.sname }
				                           </a>
				                         </c:if>
			                     </c:forEach>
			                     <c:if test="${param.cate eq ''}">
				                         	<a class="nav-link dropdown-toggle" id="" href="#"
			                    			 role="button" data-bs-toggle="dropdown" aria-expanded="false">
			                     			게시판
			                     			</a>
				                 </c:if>
			                  </c:when>
			                  
			                  <c:otherwise>
			                     <a class="nav-link dropdown-toggle" id="navbarMain" href="#"
			                     role="button" data-bs-toggle="dropdown" aria-expanded="false">
			                     게시판
			                     </a>
			                  </c:otherwise>
			               </c:choose>
			               
			                  <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
			                     <c:forEach items="${board}" var="board" varStatus="loop">
			                        <li class="cateChange"><a class="dropdown-item" href="/board?cate=${board.sno }">${board.sname }</a></li>
			                    	<li class="division${loop.index }"><hr class="dropdown-divider" /></li>
			                     </c:forEach>
			                  </ul>
			               </li>
			            </ul>
		            </div>
		            
		            </div>
            
            <div class="writeBtnBox">
            	<c:if test="${sessionScope.muuid ne null && (param.cate == 2 || param.cate == 3)}">
               		<button class="writeBtn" onclick="location.href='/boardWrite?cate=${param.cate}'">글쓰기</button>
               	</c:if>
            </div>
            
          
            <div class="boardListBox">
               <table id="boardList">
					
					<!-------------- 메인게시판(전체글_최신순) -------------->
               		<c:if test="${empty param}">
               			<c:forEach items="${mainList}" var="mainList">
		                     <tr class="boardRow" data-count="${mainList.count}">
		                        <td class="rowNum" data-bno="${mainList.bno}">${mainList.bno}</td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${mainList.sno}&bno=${mainList.bno }'">
		                        	<span class="title">${mainList.btitle}</span> <i class="xi-speech-o count" id="counticon"></i><span class="commentcount">${mainList.commentcount}</span>
		                        	<c:if test="${mainList.bimagecount gt 0}"><span class="bphotoBox"><img src="./img/board_photo.png" class="bphoto" alt="img"></span></c:if>
		                        	<div class="UserBox">
		                        		<div class="userImgBox">
												<c:choose>
													<c:when test="${sessionScope.muuid ne null && mainList.mphoto ne null}">
														<img src="../userImgUpload/${mainList.mphoto}" class="bphoto" alt="userImg">
													</c:when>
													<c:otherwise>
														<img src="./tradeImgUpload/defaultimg.jpg" alt="basic-user-img" class="userImg">
													</c:otherwise>
												</c:choose>
											</div>
		                        		<span class="mnickname">${mainList.mnickname}</span>
		                        	</div>
		                        </td>
		                       	<td class="bdateBox">
		                       		<div class="bdate">${mainList.bdate}</div>
		                       	</td>
		                     </tr>
		                     
                  		</c:forEach>
               		</c:if>
               		
             		<!-------------- 카테고리별 게시판(공지, 나눔, 판매요청) -------------->
             		
             		<c:if test="${param.cate ne null && param.searchCate eq null}">
             		
						<c:forEach items="${list}" var="list">
		                     <tr class="boardRow" data-count="${list.count}">
		                        <td class="rowNum" data-bno="${list.bno}">${list.bno}</td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${list.sno}&bno=${list.bno }'">
		                        	 <span class="title">${list.btitle}</span> <i class="xi-speech-o count" id="counticon"></i><span class="commentcount">${list.commentcount}</span>
		                        	<c:if test="${list.bimagecount gt 0}"><span class="bphotoBox"><img src="./img/board_photo.png" class="bphoto" alt="img"></span></c:if>
		                        	<div class="UserBox">
		                        		<div class="userImgBox">
												<c:choose>
													<c:when test="${list.mphoto ne null}">
														<img src="../userImgUpload/${list.mphoto}" alt="user-img" class="userImg">
													</c:when>
													<c:otherwise>
														<img src="../img/defaultimg.jpg" alt="basic-user-img" class="userImg">
													</c:otherwise>
												</c:choose>
											</div>
		                        		<span class="mnickname">${list.mnickname}</span>
		                        	</div>
		                        </td>
		                        <td class="bdateBox">
		                        	<div class="bdate">${list.bdate}</div>
		                        </td>
		                     </tr>
                  		</c:forEach>
                  		
             		</c:if>
             		
             		<!--------------카테고리별 게시판 검색결과 -------------->
             		<c:if test="${param.search ne null && param.searchCate ne null}">
             			<c:if test="${empty  searchList}">
             				<div class="NoSearchList">검색결과가 없습니다.</div>
             			</c:if>
						<c:forEach items="${searchList}" var="searchList">
							<tr class="boardRow" data-count="${searchList.scount}">
		                        <td class="rowNum" data-bno="${searchList.bno}">${searchList.bno}</td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${searchList.sno}&bno=${searchList.bno }'">
		                        	 <span class="title">${searchList.btitle}</span> <i class="xi-speech-o count" id="counticon"></i><span class="commentcount">${searchList.commentcount}</span>
		                        	<c:if test="${searchList.bimagecount gt 0}"><span class="bphotoBox"><img src="./img/board_photo.png" class="bphoto" alt="img"></span></c:if>
		                        	<div class="UserBox">
		                        		<div class="userImgBox">
												<c:choose>
													<c:when test="${searchList.mphoto ne null}">
														<img src="../userImgUpload/${searchList.mphoto}" alt="user-img" class="userImg">
													</c:when>
													<c:otherwise>
														<img src="../img/defaultimg.jpg" alt="basic-user-img" class="userImg">
													</c:otherwise>
												</c:choose>
											</div>
		                        		<span class="mnickname">${searchList.mnickname}</span>
		                        	</div>
		                        </td>
		                        <td class="bdateBox">
		                        	<div class="bdate">${searchList.bdate}</div>
		                        </td>
		                     </tr>
	             		</c:forEach>
	             		
             		</c:if> 
             		
               </table>
              
            </div>
            
        		 </div>
            </div>
        </section>
        
  </body>
  
</html>