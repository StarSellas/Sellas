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
            
			
            $(function(){
            	
            	let cate;
            	
            	// 검색카테고리&검색단어 검색창에 남기기
            	let searchCate = "${param.searchCate}";
            	let search = "${param.search}";
            	
            	console.log("여기안와?")
        		let firstOption = $(".searchCate option:first").val();
        		$(".searchCate").val(firstOption);
            	
            	if (searchCate != "" && search != ""){
            		console.log("여긴왜옴?")
            		console.log("searchCate : " + searchCate)
            		$(".searchCate[name='searchCate']").val(searchCate);
					$(".swrite").val(search);
            	}
            	
            	// 글번호 숨김
            	$(".rowNum").hide();
            	
            	// 스크롤 페이징
            	let currentPage = 1;	// 현재페이지
            	let isBottomHandled = false;	// 연속적인 요청 방지용
            	
            	
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
            	
           		if(${empty param}){
            		cate = 0;
            	} else {
            		cate = $(".cateNum").val();
            	}
           		
               let firstbno = $(".rowNum:first").attr("data-bno");	// 최상단글bno ***** 확인용 *****
               let lastbno = firstbno; 
               let lastRow = $(".boardRow:last");					// 최하단row
               let count = $(".boardRow").attr("data-count");		// 해당 카테고리의 글갯수
               let wholePage = Math.ceil(count/10);					// 전체페이지수(글의갯수/10의 올림) 
               console.log("wholePage : " + wholePage);
               console.log("count : " + count);
               console.log("firstbno : " + firstbno);
               
        		
                  // 다음페이지가 없다면 진행X
                  if(wholePage < currentPage){
                	  	alert("마지막 페이지 입니다.");
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
                        	        		
                        	        		newRow = "<tr class='boardRow' data-count='" + this.list[i].count + "'>"
	                    	                    + "<td class='rowNum' data-bno='" + this.list[i].bno + "'>"
	                    	                    + "</td>"
	                    	                    + "<td class='btitle' onclick=\"location.href='/boardDetail?cate=" + this.list[i].sno + "&bno=" + this.list[i].bno + "'\">"
	                    	                    + this.list[i].btitle
	                    	                    + " <span class='commentcount'>(" + this.list[i].commentcount + ")</span>"
	                    	                    + "<div class='mnickname'>" + this.list[i].mnickname + "</div>"
	                    	                    + "</td>"
	                    	                    + "<td class='bdate'>" + this.list[i].bdate + "</td>"
	                    	                    + "</tr>";
	
	                    	                    lastRow.after(newRow); // lastRow 뒤에 추가
	                        	        	  
	                    	                  // 추가된 tr로 lastRow 재설정
	                                          lastRow = $(".boardRow:last");   // 최하단row
	                                          console.log("lastRow :" + i + "번째");
	                                          
	                                          $(".rowNum").hide();
	                                          
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
        
    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
        <!-- Section-->
        <section class="py-5">
        
            <div class="container mt-4" style="z-index: 10" id="productContainer">
                <div class="justify-content-center">
                
                <div class="backButton"><a href="javascript:history.back()"><i class="xi-angle-left xi-x"></i></a></div>
                
				<!-------------- 게시판 검색 & 카테고리 드롭다운 -------------->
				
				<div class="HeaderBox">
				<div class="searchBox">
					<form action="./board" method="get" class="searchFrom">
						<select name="searchCate" class="searchCate">
							<option value="title">제목</option>
							<option value="content">내용</option>
							<option value="writer">글쓴이</option>
						</select>
						<input type="text" name="search" class="swrite">
						<input type="hidden" name="cate" value="${param.cate }" class="cateNum">
						<button type="submit" class="swriteButton bg-light">🐋</button>			
					</form>
				</div>

					<div class="cateBox">
			            <ul class="navbar-nav" id="cateBar">
			               <li class="nav-item dropdown">
			               <c:choose>
			                  <c:when test="${empty param}">
			                     <a class="nav-link dropdown-toggle" id="navbarMain" href="#"
			                     role="button" data-bs-toggle="dropdown" aria-expanded="false">
			                     게시판
			                     </a>
			                  </c:when>
			                  <c:otherwise>
			                     <c:forEach items="${board}" var="board">
			                        <c:if test="${param.cate eq board.sno}">
			                           <a class="dropdown-toggle" id="navbarDropdown" href="#"
			                           role="button" data-bs-toggle="dropdown" aria-expanded="false">
			                           ${board.sname }
			                           </a>
			                         </c:if> 
			                     </c:forEach>
			                  </c:otherwise>
			               </c:choose>
			               
			                  <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
			                     <c:forEach items="${board}" var="board">
			                        <li class="cateChange"><a class="dropdown-item" href="/board?cate=${board.sno }">${board.sname }</a></li>
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
		                        	${mainList.btitle} <span class="commentcount">(${mainList.commentcount})</span>
		                        	<div class="mnickname">${mainList.mnickname}</div>
		                        </td>
		                       	<td class="bdate">${mainList.bdate}</td>
		                     </tr>
		                     
                  		</c:forEach>
               		</c:if>
               		
             		<!-------------- 카테고리별 게시판(공지, 나눔, 판매요청) -------------->
             		
             		<c:if test="${param.cate ne null && param.searchCate eq null}">
             		
						<c:forEach items="${list}" var="list">
		                     <tr class="boardRow" data-count="${list.count}">
		                        <td class="rowNum" data-bno="${list.bno}">${list.bno}</td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${list.sno}&bno=${list.bno }'">
		                        	 ${list.btitle} <span class="commentcount">(${list.commentcount})</span>
		                        	<div class="mnickname">${list.mnickname}</div>
		                        </td>
		                        <td class="bdate">${list.bdate}</td>
		                     </tr>
                  		</c:forEach>
                  		
             		</c:if>
             		
             		<!--------------카테고리별 게시판 검색결과 -------------->
             		<c:if test="${param.searchCate ne null && param.search ne null && param.searchCate ne null}">
             		
						<c:forEach items="${searchList}" var="searchList">
							<tr class="boardRow" data-count="${searchList.scount}">
		                        <td class="rowNum" data-bno="${searchList.bno}">${searchList.bno}</td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${searchList.sno}&bno=${searchList.bno }'">
		                        	 ${searchList.btitle} <span class="commentcount">(${searchList.commentcount})</span>
		                        	<div class="mnickname">${searchList.mnickname}</div>
		                        </td>
		                        <td class="bdate">${searchList.bdate}</td>
		                     </tr>
	             		</c:forEach>
	             		
             		</c:if> 
             		
               </table>
              
            </div>
            
            <div class="nextBtnBox"> 현재페이지 : <span class="currentPage">1</span></div>
            
        		 </div>
            </div>
        </section>
        
  </body>
  
</html>