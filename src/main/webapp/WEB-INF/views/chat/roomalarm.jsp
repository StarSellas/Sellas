<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>채팅방</title>
    <style>
        /* 초기에 숨길 스타일 */
        .hidden-element {
            display: none; /* 숨김 */
        }
    </style>
    <script src="../js/jquery-3.7.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
  
    	
        var sock = new SockJS("/ws/chat");
        var ws = Stomp.over(sock);
        var roomId = '${roomId}';
        var sender = '${oseller}';
        let tno = '${tno}';
		let mnickname = '${mnickname}';
		let emessage = '${econtent}';
		let requestMoney = '';
		let tnormalstate = '${tnormalstate}';
		
        ws.connect({}, function (frame) {
        	//console.log(frame); 정상적으로 들어옵니다.
            ws.subscribe("/sub/ws/chat/room/" + roomId, function (message) {
            	//console.log(message);
                var recv = JSON.parse(message.body);
                //console.log("recv" + recv); 정상적으로 들어옵니다.
                if(recv.type != 'ALARM' && recv.type != 'INTERVAL'){
                		recvMessage(recv);
            	} else {
            		return false;
            	}if(recv.type == 'PAYMENT'){
            		requestMoney = recv.requestMoney;
            		$(".tradeResponse").show();
            	}if(recv.type=='TRADECANCEL'){
            		alert("거래가 취소되었습니다. 메인으로 돌아갑니다.");
            		location.href='/';
            	}if(recv.type =='TRADECOMPLETE'){
            		alert("거래가 완료되었습니다. 메인으로 돌아갑니다.");
            		location.href='/';
            	}
               	
            });
            ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'ENTER', roomId: roomId, sender: sender, mnickname : mnickname, message: emessage}));
        });
        function sendMessage() {
            var messageInput = document.getElementById('message');
            var message = messageInput.value;

            if (message.trim() === "") {
                alert("내용을 입력해 주세요.");
                return;
            }
			/* console.log(message)
			console.log(sender)
			console.log(roomId) 셋 다 들어오는거 확인했습니다. */ 
            ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'TALK', roomId: roomId, sender: sender, mnickname : mnickname, message: message}));
            messageInput.value = '';
            startPing();
        }
        
        function recvMessage(recv) {
        	if(recv.type == 'TRADEOK'){
        		$(".tradeAcceptOrCancel").show();
        	}
        	if(recv.type == 'PAYMENT'){
        		$(".tradeResponse").show();
        	}if(recv.type == 'TRADECANCEL'){
        		alert("거래가 취소되었습니다. 메인으로 이동합니다.");
        		location.href='/';
        	}
        	
        	
        	if(recv.type == 'enter' || recv.type == 'out'){
        		var messagesList = document.getElementById("messages");
                var listItem = document.createElement("div");
                listItem.className = "list-group-item";
                listItem.textContent = recv.message;
                messagesList.insertBefore(listItem, messagesList.lastChild);
        	} else {
            var messagesList = document.getElementById("messages");
            var listItem = document.createElement("div");
            listItem.className = "list-group-item";
            listItem.textContent = recv.mnickname + " - " + recv.message;
            messagesList.insertBefore(listItem, messagesList.lastChild);
        	}
        }
        
        function startPing(){
        	let message = "INTERVAL";
        	ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'INTERVAL', roomId: roomId, sender: sender, mnickname : mnickname, message: message}));
        	setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
        };
        
        $(function() {
        	$(".tradeResponse").hide();
        //숨겨야징
        $(".tradeResponse").hide();
        $(".tradeAcceptOrCancel").hide();
        
    		$(".tradeok").click(function() { //거래수락을 눌렀을 때 실행할 함수입니다.
    			$.ajax({
    				url : '/tradeOk',
    				type : 'post',
    				data : {
    					tno : tno,
    					pseller : sender,
    					tnormalprice : requestMoney,
    					roomId : roomId
    				},
    				dataType : "json",
    				success : function(data) { //data.comparecount = 1이면 거래 지속, 0이면 거래 중지 충전창으로 보
    					if (data.tradeAccepted === 'ok') {
    						trade = 1;
    						alert("거래를 수락하셨습니다.");
    						let okmessage = mnickname + "님이 거래를 수락하셨습니다.";
    						ws.send("/pub/ws/chat/message", {}, JSON.stringify({
    							type : 'TRADEOK',
    							roomId : roomId,
    							sender : sender,
    							mnickname : mnickname,
    							message : okmessage
    						}));
    						
    						
    						$(".tradeResponse").hide();
    					}
    					
    				
    				},
    				error : function(error) {
    					
    				}
    			});
    		});

    		$(".tradeno").click(function() { //거래취소 눌렀을 때 실행할 함수입니다.
    			trade = 2;
    			let nomessage = sender + "님이 거래를 거절하셨습니다.";
    			ws.send("/pub/ws/chat/message", {}, JSON.stringify({
    				type : 'TRADENO',
    				roomId : roomId,
    				sender : sender,
    				mnickname : mnickname,
    				message : nomessage
    			}));
    		});
    
    		$(".tradeAccept").click(function(){
    			$.ajax({
    				url : "/recieveChecked",
    				type : "post",
    				data : {muuid : sender , tno : tno},
    				dataType : "json",
    				success : function(data){
    					if(data.tradeAllSuccess==1){
        					alert("거래가 완료되었습니다. 후기를 작성해주세요.");
        					location.href='/';
        				}
        				
        				
        				if(data.tradesuccess==1){
        					ws.send("/pub/ws/chat/message", {}, JSON.stringify({
    							type : 'TRADEACCEPT',
    							roomId : roomId,
    							sender : sender,
    							mnickname : mnickname,
    							message : mnickname+ "님이 거래 수령 완료 버튼을 눌렀습니다.",
    						}));
        					$(".tradeAcceptOrCancel2").hide();
        					$(".tradeAcceptOrCancel").hide();
        				alert("수락이 완료되었습니다. 상대방의 수락을 기다리고 있습니다.");
        				}if(data.tradeAllSuccess == 1){
        					ws.send("/pub/ws/chat/message", {}, JSON.stringify({
    							type : 'TRADECOMPLETE',
    							roomId : roomId,
    							sender : sender,
    							mnickname : mnickname,
    							message : "거래가 완료되었습니다.",
    						}));
        					
        				}
        				
    				},
    				error : function(error){
    					alert("에러가 발생했습니다." + error);
    				}
    				
    				
    				
    			});
    			
    		});//TradeAccept 끝
    		
    		$(".tradeCancel").click(function(){
    			$(".tradeCancel").hide();
        		var reasonInput = document.createElement("input");
        	    reasonInput.type = "text";
        	    reasonInput.name = "cancellationReason";
        	    reasonInput.placeholder = "취소 사유를 입력하세요";
        	    reasonInput.className = "cancellation-reason"; 
        	    // 생성한 input 태그를 페이지에 추가
        	    $(".input-group").append(reasonInput);
        	 // 동적으로 버튼을 생성하고 추가
        	    var cancelButton = document.createElement("button");
        	    cancelButton.textContent = "거래 취소하기"; // 버튼에 표시할 텍스트
        	    cancelButton.className = "cancelbtn"; // 클래스 추가
        	    $(".input-group").append(cancelButton);

        	});// $(".recieveCancelled").click(function()끝
        	
        	$(document).on("click", ".cancelbtn", function() {
        	    var reason = $(".cancellation-reason").val(); 
        	 // 받아와야 하는 값 : tno, 세션의 muuid, 실패 사유, tnormalprice
        	    $.ajax({
        	        url: "/recieveCancelled",
        	        type: "post", 
        	        data: { reason: reason , muuid : sender, tno : tno}, 
        	        dataType: "json",
        	        success: function(data) {
        	        	
        	        	if(data.recieveCancelledSuccess ==1 ){
        	        		ws.send("/pub/ws/chat/message", {}, JSON.stringify({
    							type : 'TRADECANCEL',
    							roomId : roomId,
    							sender : sender,
    							mnickname : mnickname,
    							message : "거래가 취소되었습니다."
    						}));
        	        		
        	        		alert("취소가 정상적으로 처리되었습니다.");
        	        		location.href='/';
        	        	}
        	            // 서버로부터의 응답을 처리
        	            console.log("서버 응답:", data);
        	            // 이후 원하는 동작 수행
        	        },
        	        error: function(error) {
        	            // 오류 처리
        	            console.log("오류 발생:", error);
        	        }
        	    });
        	});
    		
    		
        

        
	});
    </script>
</head>
<body>

    <div class="container">
        <div>
            <h2 id="roomName"></h2>
        </div>
        <div class="input-group">
            <div class="input-group-prepend">
                <label class="input-group-text">내용</label>
            </div>
            <input type="text" class="form-control" id="message">
            <div class="input-group-append">
                <button class="btn btn-primary" type="button" onclick="sendMessage()">보내기</button>
            </div>
            
            <div class="tradeResponse">
            <div><button class="tradeok" type="button">거래수락</button></div>
			<div><button class="tradeno" type="button">거래취소</button></div>
			</div>
			<c:if test="${tnormalstate ==1 &&(sessionScope.muuid == payment.pbuyer || sessionScope.muuid == payment.pseller)&& payment.pstate == 2}">
				<div>
					<button class="tradeAccept" type="button">수령완료</button>
					<button class="tradeCancel" type="button">거래취소</button>
				</div>
			</c:if>
				<div class="tradeAcceptOrCancel">
					<button class="tradeAccept" type="button">수령완료</button>
					<button class="tradeCancel" type="button">거래취소</button>
				</div>
        </div>
        <div>
			<c:if test="${lastroomcheck eq 1 }"> <!-- 과거 대화목록 불러옵니다. -->
				<c:forEach items="${lastchatlist }" var="lastchat">
				<c:choose>
					<c:when test="${lastchat.chatnick eq mnickname }">
						<div style="float:left">${lastchat.dcontent } - ${lastchat.chatnick }</div>
					</c:when>
					<c:otherwise>
						<div style="float:right">${lastchat.dcontent } - ${lastchat.chatnick }</div>
					</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:if>
		</div>
        <div class="list-group" id="messages">
        </div>
        <div></div>
    </div>
</body>
</html>
