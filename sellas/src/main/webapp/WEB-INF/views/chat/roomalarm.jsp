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
        var sender = '${mnickname}';
        let tno = '${tno}';
		let oseller = '${oseller}';
		let emessage = '${econtent}';

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
            	}
               	
            });
            ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'ENTER', roomId: roomId, sender: sender, message: emessage}));
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
            ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'TALK', roomId: roomId, sender: sender, message: message}));
            messageInput.value = '';
            startPing();
        }

        function recvMessage(recv) {
            var messagesList = document.getElementById("messages");
            var listItem = document.createElement("li");
            listItem.className = "list-group-item";
            listItem.textContent = recv.sender + " - " + recv.message;
            messagesList.insertBefore(listItem, messagesList.firstChild);
        }
        
        function startPing(){
        	let message = "INTERVAL";
        	ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'INTERVAL', roomId: roomId, sender: sender, message: message}));
        	setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
        };
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
            <div><button class="tradeok" type="button">거래수락</button></div>
			<div><button class="tradeno" type="button">거래취소</button></div>
        </div>
        <ul class="list-group" id="messages">
        </ul>
        <div></div>
    </div>
</body>
</html>
