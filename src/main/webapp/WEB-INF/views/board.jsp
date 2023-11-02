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
        
            <div class="container px-4 mt-5" style="z-index: 10" id="productContainer">
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
               		<c:if test="${empty param}">
               		
               			<c:forEach items="${mainList}" var="mainList">
		                     <tr class="boardRow">
		                        <td class="rowNum">
		                        	${mainList.rowNum}
		                        </td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${mainList.sno}&bno=${mainList.bno }'" data-bno="${mainList.rowNum}">
		                        	${mainList.btitle} <span class="commentcount">(${mainList.commentcount})</span>
		                        </td>
		                        <td class="bdate">${mainList.bdate}</td>
		                        <td class="bread">${mainList.bread}</td>
		                     </tr>
                  		</c:forEach>
               		</c:if>
               		
             		<c:if test="${param.cate ne null }">
						<c:forEach items="${list}" var="list">
		                     <tr class="boardRow">
		                        <td class="rowNum"><c:if test="${list.bthumbnail eq 0}"> <span>i</span> </c:if>
		                        	${list.rowNum}
		                        </td>
		                        <td class="btitle" onclick="location.href='/boardDetail?cate=${list.sno}&bno=${list.bno }'" data-bno="${list.rowNum}"> <%--  --%>
		                        	${list.btitle} <span class="commentcount">(${list.commentcount})</span>
		                        </td>
		                        <td class="bdate">${list.bdate}</td>
		                        <td class="bread">${list.bread}</td>
		                     </tr>
                  		</c:forEach>             		
             		</c:if>
               </table>
            </div>
            
            <div class="writeBtnBox">
            	<c:if test="${param.cate eq 2 || param.cate eq 3}">
               		<button class="writeBtn" onclick="location.href='/boardWrite?cate=${param.cate}'">글쓰기</button>
               </c:if>
            </div>

        		 </div>
            </div>
        </section>
        
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>