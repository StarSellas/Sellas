<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>onlyalarm</title>
<script src="../js/jquery-3.7.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
	<script>
		let sock = new SockJS("/ws/chat");
		let lastroomcheck = '${lastroomcheck}';
		let oseller = '${oseller}';
		let obuyer = '${obuyer}';
		let tno = '${tno}';
		let amessage = '${acontent}';
		let ouuid = '${ouuid}';
		$(function() {
			let ws0 = Stomp.over(sock);
			ws0.connect({}, function(frame) {
				//console.log(frame); 정상적으로 들어옵니다.
				ws0.subscribe("/sub0/ws/chat/user/" + oseller,
						function(message) {

						});
				ws0.send("/pub/ws/chat/alarmmessage", {}, JSON.stringify({
					type : 'ALARM',
					roomId : ouuid,
					sender : obuyer,
					message : amessage,
					recipient : oseller
				}));
			/* 	ws0.disconnect(); */
			});
			$(function() {
			let form = document.createElement("form"); 
			form.setAttribute("action", "/chat/requestChat");
			form.setAttribute("method", "post");
			
			let tnoInput = document.createElement("input");
			tnoInput.setAttribute("type", "hidden");
			tnoInput.setAttribute("name", "tno");
			tnoInput.setAttribute("value", tno); 
			form.appendChild(tnoInput);
			
			let obuyerInput = document.createElement("input");
			obuyerInput.setAttribute("type", "hidden");
			obuyerInput.setAttribute("name", "obuyer");
			obuyerInput.setAttribute("value", obuyer); 
			form.appendChild(obuyerInput);
			
			let osellerInput = document.createElement("input");
			osellerInput.setAttribute("type", "hidden");
			osellerInput.setAttribute("name", "oseller");
			osellerInput.setAttribute("value", oseller); 
			form.appendChild(osellerInput);
			
			let ouuidInput = document.createElement("input");
			ouuidInput.setAttribute("type", "hidden");
			ouuidInput.setAttribute("name", "roomId");
			ouuidInput.setAttribute("value", ouuid);
			form.appendChild(ouuidInput);
			
			let lastroomcheckInput = document.createElement("input");
			lastroomcheckInput.setAttribute("type", "hidden");
			lastroomcheckInput.setAttribute("name", "lastroomcheck");
			lastroomcheckInput.setAttribute("value", lastroomcheck);
			form.appendChild(lastroomcheckInput);
			
			document.body.appendChild(form); //좌석 빼줌
			form.submit(); 
			});
		});
	</script>
</body>
</html>