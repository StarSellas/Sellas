<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>alarm</title>
</head>
<body>
	<ul class="alarm">
		
	</ul>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	<script type="text/javascript">
		var sock = new SockJS("/ws/chat");
		var ws = Stomp.over(sock);
		function recvMessage(recv) {
			var messagesList = document.getElementById("messages");
			var listItem = document.createElement("li");
			listItem.className = "list-group-item";
			listItem.textContent = recv.sender + " - " + recv.message;
			messagesList.insertBefore(listItem, messagesList.firstChild);
		}

		ws.connect({}, function(frame) {
			ws.subscribe("/sub/ws/chat/room/" + roomId, function(message) {
				var recv = JSON.parse(message.body);
				if (recv.type == 'ALARM') {
					recvMessage(recv);
				} else {
					return false;
				}
			});
			ws.send("/pub/ws/chat/message", {}, JSON.stringifiy({
				type : 'ALARM',
				roomId : roomId,
				sender : sender
			}));
		}, function(error) {
			if (reconnect++ <= 5) {
				setTimeout(function() {
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