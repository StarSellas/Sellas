<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>alarm</title>
<style>
        #alarmroomhidden {
            display: none; /* 숨김 */
        }
    </style>
    <script src="../js/jquery-3.7.0.min.js"></script>
</head>
<body>
<!-- 일단 alarm 클래스 클릭하면 가상폼써서 requestChat으로 넘어가고, 가져갈 것은 ouuid, oseller, obuyer, tno. 그 다음이 realtimealarm에 실시간 알람 뿌리기  -->
<ul class="realtimealarm">
</ul>
    
    <c:if test="${not empty alarmlist}">
        <c:forEach items="${alarmlist}" var="alarm">
        <ul>
            <li class="alarmcontent">${alarm.acontent}</li>
            <li class="alarmroomhidden">${alarm.ouuid }</li>
        </ul>
        </c:forEach>
        </c:if>
   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script type="text/javascript">
    $(function(){
    	$.ajax({
    		url: '/chat/alarmcheck',
    		type: 'post',
    		success : function(data){
    			
    		},
    		error : function(error){
    			
    		}
    	});
    });
    $(document).ready(function() {
        $(document).on('DOMNodeInserted', function() {
            $(".alarmroomhidden").hide();
        });
    });
    
    $(function(){
    	$(".alarmcontent").click(function(){
    		var roomId = $(this).nextAll(".alarmroomhidden").text();

            // roomId를 사용하여 필요한 작업 수행
            console.log("Clicked on roomId: " + roomId);
    		let form = document.createElement("form"); //좌석수 빼는 폼
            form.setAttribute("action", "/chat/alarmChat");
            form.setAttribute("method", "post");
            
            let ouuidInput = document.createElement("input");
            ouuidInput.setAttribute("type", "hidden");
            ouuidInput.setAttribute("name", "roomId");
            ouuidInput.setAttribute("value", roomId); 
            form.appendChild(ouuidInput);
            
            document.body.appendChild(form); //좌석 빼줌
           	form.submit(); 
    	});
    });
        var sock = new SockJS("/ws/chat");
        var ws = Stomp.over(sock);
        let muuid = "${sessionScope.muuid}"
        function recvMessage(recv) {
            var realtimealarm = document.querySelector(".realtimealarm");
            var listItem = document.createElement("li");
            listItem.className = "list-group-item";
            listItem.textContent = recv.message;
            realtimealarm.appendChild(listItem); // Add the new alarm at the bottom
        } 
        
       $(function(){
        	$(".list-group-item").click(function(){
        		var roomId = $(this).nextAll(".alarmroomhidden").text();
        		var form = document.createElement("form"); //좌석수 빼는 폼
                form.setAttribute("action", "/chat/alarmChat");
                form.setAttribute("method", "post");
                
                let ouuidInput = document.createElement("input");
                ouuidInput.setAttribute("type", "hidden");
                ouuidInput.setAttribute("name", "roomId");
                ouuidInput.setAttribute("value", roomId); 
                form.appendChild(ouuidInput);
                
                document.body.appendChild(form); //좌석 빼줌
               	form.submit();
        	});
        }); 

        ws.connect({}, function(frame) {
            ws.subscribe("/sub0/ws/chat/user/" + muuid, function(message) {
                var recv = JSON.parse(message.body);
                if (recv.type == 'ALARM') {
                    recvMessage(recv);
                } else {
                    return false;
                }
                startPing();
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
