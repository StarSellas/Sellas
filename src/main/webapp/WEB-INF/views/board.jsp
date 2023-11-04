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
        
		<script type="text/javascript">
			$(function(){
				$(".rowNum").hide();
			});	
		</script>        
        
    </head>
    <body>
	<%@ include file="menubar.jsp" %>
	
        <!-- Section-->
        <section class="py-5">
        
            <div class="container mt-5" style="z-index: 10" id="productContainer">
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
		                           <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
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
            
            <div class="boardListBox">
               <table id="boardList">
	               <thead>
						<tr class="addList"></tr>
					</thead>
               		<c:if test="${empty param}">
               			<c:forEach items="${mainList}" var="mainList">
		                     <tr class="boardRow" data-count="${mainList.count}">
		                        <td class="rowNum" data-bno="${mainList.bno}">${mainList.bno}</td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${mainList.sno}&bno=${mainList.bno }'">
		                        	${mainList.btitle} <span class="commentcount">(${mainList.commentcount})</span>
		                        	<div class="mnickname">${mainList.mnickname}</div>
		                        </td>
		                        <td class="bdateBox">
		                       		<div class="mainbdate">${mainList.bdate}</div>
		                       		<div class="bread">${mainList.bread}</div>
		                        </td>
		                     </tr>
                  		</c:forEach>
               		</c:if>
               		
             		<c:if test="${param.cate ne null }">
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
               </table>
            </div>
            
            
            <script type="text/javascript">
            
            $(function(){
               
               let nextpage = 1;	// 초기페이지번호 1
               let cate = ${param.cate};
               let firstbno = $(".rowNum:first").attr("data-bno");	// 최상단글bno
               let lastbno = $(".rowNum:last").attr("data-bno");	// 최하단글bno
               let lastRow = $(".rowNum:last");	// 최하단row
               let count = $(".boardRow").attr("data-count");	// 해당 카테고리의 글갯수
               console.log(lastbno + " +초기");
               console.log(lastRow.text().trim() + " +초기");
               
               let data = {};	// ajax로 보낼 객체
               data.cate = cate;
               data.lastbno = lastbno;
               data.firstbno = firstbno;
               data.count = count;
               
               $(".nextbutton").click(function() {
                  
                  console.log("nextpage : " + nextpage);
                  let wholePage = Math.ceil(count/10);
                  console.log("wholePage : " + wholePage);
                  //let hasNext = (Math.ceil(count/10) > nextpage)
                  //console.log(hasNext);
                  
                  // 다음페이지가 있다면 진행
                  if(wholePage == nextpage){
                	  
                	  	alert("마지막 페이지 입니다.");
   						return false;
   						
                  } else {
                 
                     nextpage++;
                     $(".currentPage").text(nextpage) // 현재페이지 표시(테스트용)
                     data.nextpage = nextpage;
                     let newRow = "";
                     
                     $.ajax({
                          url: './nextPage',
                          type: 'post',
                          data: data,
                          dataType: 'json',
                          success: function(data) {
                        	    if (data.list != null) { // 데이터가 있다면 뽑아내기
                        	        alert("데이터와");

                        	        $(data).each(function() {
                        	        	console.log(this.list[0].bno);
                        	        	//console.log(this.list.length);
                        	        	for (let i = 0; i < 1; i++) {
                        	        		
	                        	        	let newRow = "<tr class='boardRow'>"
	                    	                    + "<td class='rowNum' data-bno='" + this.list[i].bno + "'>"
	                    	                    + this.list[i].bno + "</td>"
	                    	                    + "<td class='btitle' onclick=\"location.href='/boardDetail?cate=" + this.list[i].sno + "&bno=" + this.list[i].bno + "'\">"
	                    	                    + this.list[i].btitle
	                    	                    + " <span class='commentcount'>(" + this.list[i].commentcount + ")</span>"
	                    	                    + "<div>" + this.list[i].m_name + "</div>"
	                    	                    + "</td>"
	                    	                    + "<td class='bdate'>" + this.list[i].bdate + "</td>"
	                    	                    + "<td class='bread'>" + this.list[i].blike + "</td>"
	                    	                    + "</tr>";
	
	                    	                    lastRow = $(newRow).insertAfter(lastRow); // lastRow 뒤에 행 추가
	                    	                    
                        	        	}	// for
                        	        }); // .each
                        	        
                        	    } // if(data != null)
                        	},
                          
                          error: function(error) {
                              //alert("에러남");
                          }
                          
                      }); // ajax
                   
                  }
                  
               }) // 다음페이지 불러오기
               
               
               let prevpage = ${pageNum }-1;
               
               $(".prevbutton").click(function(){
                  location.href="/board?cate="+${param.cate}+"&pageNum="+prevpage;
               })
               
               
            });          
            
            </script>
            
            
            <div class="writeBtnBox">
            ${sessionScope.uuid}
            	<c:if test="${sessionScope.muuid ne null && (param.cate == 2 || param.cate == 3)}">
               		<button class="writeBtn" onclick="location.href='/boardWriteForTest?cate=${param.cate}'">글쓰기</button>
               	</c:if>
            </div>

        		 </div>
            </div>
        </section>
        
    </body>
</html>