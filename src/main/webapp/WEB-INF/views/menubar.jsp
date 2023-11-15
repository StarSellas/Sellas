<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="initial-scale=1, width=device-width, user-scalable=no"/> 
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Shop Homepage - Start Bootstrap Template</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        <link href="css/menu.css" rel="stylesheet">
        
        <!-- ******************* 추가 *********************** -->
        <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
        
    </head>
    <body>
		<!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-white" id="headerline" style="z-index: 9999">
           <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="./"><img src="./img/sellastext.png" class="header" alt="SellAS"></a>
				<button class="navbar-toggler" type="button" data-bs-target="" aria-controls="navbarSupportedContent"><a href="/menu"><img src="./img/menu1.png" id="menuIcon" alt="menuIcon"></a></button>
           </div>
        </nav>

       <!-- Footer-->
	<footer id="footer" style="z-index: 9999">
		<c:if test="${addTradeItem == 1 }">
			<div style="position: absolute; right: 0px; bottom: 95px;"
				class="swrite" id="tWriteBtnBox" onclick="location.href='./addTradeItem'">
				<button id="tWriteBtn">물품 등록</button>
			</div>
		</c:if>
		<div class="container">
			<ul class="menubar">
				<li onclick="location.href='./'"><img src="./img/home.png"
					class="footericon" alt="home">
				<div id="menu">홈</div></li>
				<li onclick="location.href='./chat/alarm'"><img src="./img/chat.png" class="footericon" id="chat" alt="chat">
                        <!-- 알림이 오면 채팅 아이콘이 숨겨지고, 알림 아이콘이 보이게 함 -->
                        <img src="./img/chaton.png" class="footericon" id="chaton" alt="chat" style="display: none;">
                        <div id="menu">채팅</div></li>
				<li onclick="location.href='./mypage'"><img
					src="./img/mypage.png" class="footericon" alt="mypage">
				<div id="menu">마이페이지</div></li>
			</ul>
		</div>
	</footer>

	<!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="../js/jquery-3.7.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
		<script>
		 $(document).ready(function () {
	            // 초기 높이 저장
	            var initialHeight = window.innerHeight;

	            // 키보드 나타날 때 이벤트 감지
	            window.addEventListener('resize', function () {
	                var currentHeight = window.innerHeight;

	                if (currentHeight < initialHeight) {
	                    // 키보드가 나타났을 때
	                    $('#footer').css('bottom', currentHeight - initialHeight);
	                } else {
	                    // 키보드가 사라졌을 때
	                    $('#footer').css('bottom', 0);
	                }
	            });
	        });
		let sock = new SockJS("/ws/chat");
		let oseller = '${sessionScope.muuid}';
		let ws0 = Stomp.over(sock);
		
		$(function(){
			$.ajax({
				url: '/chat/alarmcount',
				type: 'post',
				data: {oseller:oseller},
				success:function(data) {
		           	  
	           	    if(data.count > 0){
	           	    	$("#chat").hide();
                        $("#chaton").show();
	           	    }
	           	    
	           	}, error: function(error) {
	           	}
	           	
	                 
			});
		});
			
			ws0.connect({}, function(frame) {
				//console.log(frame); 정상적으로 들어옵니다.
				ws0.subscribe("/sub0/ws/chat/user/" + oseller, function(message) {
					let recv = JSON.parse(message.body);

                    if (recv.type == 'ALARM') {
                        // 알림이 오면 채팅 아이콘을 숨기고 알림 아이콘을 보이게 함
                        $("#chat").hide();
                        $("#chaton").show();
                    } else {
                        return false;
                    }
				});
				startPing();
			/* 	ws0.disconnect(); */
			});
			
			function startPing() {
                let imessage = "INTERVAL";
                ws0.send("/pub/ws/chat/alarmmessage", {}, JSON.stringify({
                    type : 'INTERVAL',
                    sender : oseller,
                    message : imessage
                }));
                setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
            }
		</script>
    </body>
</html>
