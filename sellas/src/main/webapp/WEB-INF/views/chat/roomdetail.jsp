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
        </div>
        <ul class="list-group" id="messages">
        </ul>
        <div></div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        var sock = new SockJS("/ws/chat");
        var ws = Stomp.over(sock);
        var roomId = '${roomId}';
        var sender = '${obuyer}';
        function findRoom() {
            axios.get('/chat/room/' + roomId).then(function (response) {
                var roomName = response.data.name;
                document.getElementById('roomName').textContent = roomName;
            });
        }

        function sendMessage() {
            var messageInput = document.getElementById('message');
            var message = messageInput.value;

            if (message.trim() === "") {
                alert("내용을 입력해 주세요.");
                return;
            }

            ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'TALK', roomId: roomId, sender: sender, message: message}));
            messageInput.value = '';
        }

        function recvMessage(recv) {
            var messagesList = document.getElementById("messages");
            var listItem = document.createElement("li");
            listItem.className = "list-group-item";
            listItem.textContent = recv.sender + " - " + recv.message;
            messagesList.insertBefore(listItem, messagesList.firstChild);
        }

        ws.connect({}, function (frame) {
            ws.subscribe("/sub/ws/chat/room/" + roomId, function (message) {
                var recv = JSON.parse(message.body);
                if(recv.type !='ALARM'){
                	recvMessage(recv);
            	} else {
            		return false;
            	}
            });
            ws.send("/pub/ws/chat/message", {}, JSON.stringify({type: 'ENTER', roomId: roomId, sender: sender}));
            ws.send("/pub/ws/chat/message", {}, JSON.stringifiy({type: 'ALARM', roomId: roomId, sender: sender}));
        }, function (error) {
            if (reconnect++ <= 5) {
                setTimeout(function () {
                    console.log("connection reconnect");
                    sock = new SockJS("/ws/chat");
                    ws = Stomp.over(sock);
                    connect();
                }, 10 * 1000);
            }
        });
    </script>
</body>
</html>
