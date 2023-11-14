<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 채팅방은 두고 알람만 지운다. muuid의 dcheck가 0으로 수정함과 동시에 채팅방을 만듭니다. -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>alarm</title>
<style>
        .alarmroomhidden {
            display: none; /* 숨김 */
        }
    </style>
    <script src="../js/jquery-3.7.0.min.js"></script>
</head>
<body>
<!-- 일단 alarm 클래스 클릭하면 가상폼써서 requestChat으로 넘어가고, 가져갈 것은 ouuid, oseller, obuyer, tno. 그 다음이 realtimealarm에 실시간 알람 뿌리기  -->
<div class="realtimealarm">
</div>
    
    <c:if test="${not empty alarmlist}">
        <c:forEach items="${alarmlist}" var="alarm">
        <div>
            <div class="alarmcontent">${alarm.dcontent}</div><!-- 얘를 클릭하면 채팅룸(roomalarm)으로 가고 밑에 ouuid를 가진 웹소켓 서버와 연결됩니다. -->
            <div class="alarmroomhidden">${alarm.ouuid }</div><!-- 얘는 안보여줍니다. -->
        </div>
        </c:forEach>
        </c:if>
   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script type="text/javascript">
    $(function(){
    	$.ajax({ //acheck를 1에서 0으로 수정하는 ajax입니다.
    		url: '/chat/alarmcheck',
    		type: 'post',
    		success : function(data){
    			
    		},
    		error : function(error){
    			
    		}
    	});
    });
    
    $(function(){ //roomalarm.jsp로 보내는 가상폼입니다.
    	$(".alarmcontent").click(function(){
    		let name = $(this).text();
    		let keyword = "낙찰";

    		let startIndex = name.indexOf(keyword);

    		if (startIndex !== -1) {
    			var roomId = $(this).nextAll(".alarmroomhidden").text();
    			
    			let form = document.createElement("form"); 
                form.setAttribute("action", "/chat/auctionchat");
                form.setAttribute("method", "post");
                
                let ouuidInput = document.createElement("input");
                ouuidInput.setAttribute("type", "hidden");
                ouuidInput.setAttribute("name", "roomId");
                ouuidInput.setAttribute("value", roomId); 
                form.appendChild(ouuidInput);
                
                document.body.appendChild(form); 
               	form.submit();
    		} else {
    			var roomId = $(this).nextAll(".alarmroomhidden").text();

                // roomId를 사용하여 필요한 작업 수행
                //console.log("Clicked on roomId: " + roomId);
        		let form = document.createElement("form"); 
                form.setAttribute("action", "/chat/alarmChat");
                form.setAttribute("method", "post");
                
                let ouuidInput = document.createElement("input");
                ouuidInput.setAttribute("type", "hidden");
                ouuidInput.setAttribute("name", "roomId");
                ouuidInput.setAttribute("value", roomId); 
                form.appendChild(ouuidInput);
                
                document.body.appendChild(form); 
               	form.submit(); 
    		}
    	});
    });
        var sock = new SockJS("/ws/chat"); //실시간으로 알람을 받기위한 웹소켓 연결 코드입니다.
        var ws = Stomp.over(sock);
        let muuid = "${sessionScope.muuid}"
        
            ws.connect({}, function(frame) { //웹소켓 연결 코드입니다.
                ws.subscribe("/sub0/ws/chat/user/" + muuid, function(message) {
                    var recv = JSON.parse(message.body);
                    if (recv.type == 'ALARM') { //알람만 받기위해서 온 메시지들을 거르는 코드입니다.
                        recvMessage(recv);
                    } else {
                        return false;
                    }
                    startPing(); //웹소켓 연결이 끊기지 않게 30초에 한번씩 자동으로 메시지를 보내는 메소드입니다.
                });
            }); 
        
        function recvMessage(recv) { //실시간으로 알람을 받아 화면에 보여주는 코드입니다.
            var realtimealarm = document.querySelector(".realtimealarm");
            var alarmcontent = document.createElement("div");
            alarmcontent.className = "alarmcontent0";
            alarmcontent.textContent = recv.message;
            
            let alarmhidden = document.createElement("div");
            alarmhidden.className = "alarmhidden";
            alarmhidden.textContent = recv.roomId;
            alarmhidden.style.display = "none";
            
            realtimealarm.appendChild(alarmcontent); 
            realtimealarm.appendChild(alarmhidden);
        } 
        
       $(function(){
        	$(".alarmcontent0").click(function(){ //위에서 연결한 웹소켓으로 온 실시간 알람을 클릭하면 판매자 채팅룸(roomalarm.jsp)으로 이동하는 코드입니다.
        		var roomId = $(this).nextAll(".alarmhidden").text();
        		var form = document.createElement("form"); 
                form.setAttribute("action", "/chat/alarmChat");
                form.setAttribute("method", "post");
                
                let ouuidInput = document.createElement("input");
                ouuidInput.setAttribute("type", "hidden");
                ouuidInput.setAttribute("name", "roomId");
                ouuidInput.setAttribute("value", roomId); 
                form.appendChild(ouuidInput);
                
                document.body.appendChild(form); 
               	form.submit();
        	});
        }); 
        
        function startPing(){
        	let message = "INTERVAL";
        	ws.send("/pub/ws/chat/message/" + muuid, {}, JSON.stringify({type: 'INTERVAL', roomId: roomId, sender: sender, message: message, Recipient: muuid}));
        	setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
        };
    </script>
</body>
</html>
