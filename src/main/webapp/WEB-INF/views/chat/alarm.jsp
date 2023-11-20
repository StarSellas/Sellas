u<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 채팅방은 두고 알람만 지운다. muuid의 dcheck가 0으로 수정함과 동시에 채팅방을 만듭니다. -->
<!-- 가장 최근의 ddate 순으로 정렬합니다. -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>alarm</title>
<script src="../js/jquery-3.7.0.min.js"></script>
    <script src="../js/wnInterface.js"></script> 
    <script src="../js/mcore.min.js"></script> 
    <script src="../js/mcore.extends.js"></script> 
<link rel="stylesheet" type="text/css" href="../css/alarmlist.css">
<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
</head>
<body>
<%@ include file="alarmmenubar.jsp" %>
<div class="inbox_people">
	<div class="headind_srch">
		<div class="recent_heading">
			<h4>채팅</h4>
		</div>
	</div>
	<div class="inbox_chat">
		<c:forEach items="${chatroomlist }" var="chatroomlist">
			<div class="chat_list">
            	<div class="chat_people">
                	<div class="chat_img">
                		<c:choose>
	                		<c:when test="${chatroomlist.thumbnailcheck eq 1 }">
	                          	<img class="card-img-top" src="../tradeImgUpload/${chatroomlist.thumbnail }" alt="sellas" style="border-radius:5px;"/>
	                        </c:when>
	                        <c:otherwise>
	                           <img class="card-img-top" src="../img/흰배경셀라스.jpg" alt="sellas" style="border-radius:5px;"/>
	                        </c:otherwise>
	            		</c:choose>
	            	</div>
                	<div class="chat_ib">
                  		<h5>${chatroomlist.ttitle } <span class="chat_date">${chatroomlist.ddate }</span></h5>
                  		<p class="dcontent">${chatroomlist.dcontent }</p>
                  		<p class="ouuid" style="display:none;">${chatroomlist.ouuid }</p>
                  		<p class="oseller" style="display:none;">${chatroomlist.oseller }</p>
                  		<p class="obuyer" style="display:none;">${chatroomlist.obuyer }</p>
                  		<p class="tno" style="display:none;">${chatroomlist.tno }</p>
                  		<p class="lastroomcheck" style="display:none;">${chatroomlist.lastroomcheck }</p>
                	</div>
              	</div>
            </div>
		</c:forEach>
	</div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script type="text/javascript">
    $(function(){

    	// 클릭 이벤트 처리
        $('.chat_list').on('click', function() {
            var clickedItem = $(this);
            var clickedBuyer = clickedItem.find('.obuyer').text();
            var clickedSeller = clickedItem.find('.oseller').text();
            var clickedTno = clickedItem.find('.tno').text();
            var clickedLastroomcheck = clickedItem.find('.lastroomcheck').text();
            let clickedDcontent = clickedItem.find(".dcontent").text();
            var roomId = clickedItem.find('.ouuid').text(); // 또는 원하는 방식으로 room ID를 가져옵니다.
            
            if(clickedDcontent.includes('낙찰')){
            	
            	let form = document.createElement("form"); 
				form.setAttribute("action", "/chat/auctionchat");
				form.setAttribute("method", "post");
			
				let ouuidInput = document.createElement("input");
				ouuidInput.setAttribute("type", "hidden");
				ouuidInput.setAttribute("name", "roomId");
				ouuidInput.setAttribute("value", roomId);
				form.appendChild(ouuidInput);
			
				let lastroomcheckInput = document.createElement("input");
				lastroomcheckInput.setAttribute("type", "hidden");
				lastroomcheckInput.setAttribute("name", "lastroomcheck");
				lastroomcheckInput.setAttribute("value", clickedLastroomcheck);
				form.appendChild(lastroomcheckInput);
				
				document.body.appendChild(form);
				form.submit();
            	
            } else {

          	  	if (clickedBuyer === "${sessionScope.muuid}") {
              	  	// Buyer와 세션의 muuid가 일치하는 경우
                
              	 	let form = document.createElement("form"); 
    				form.setAttribute("action", "/chat/requestChat");
    				form.setAttribute("method", "post");
    			
    				let tnoInput = document.createElement("input");
    				tnoInput.setAttribute("type", "hidden");
    				tnoInput.setAttribute("name", "tno");
    				tnoInput.setAttribute("value", clickedTno); 	
    				form.appendChild(tnoInput);
    			
    				let obuyerInput = document.createElement("input");
    				obuyerInput.setAttribute("type", "hidden");
    				obuyerInput.setAttribute("name", "obuyer");
    				obuyerInput.setAttribute("value", clickedBuyer); 
    				form.appendChild(obuyerInput);
    			
    				let osellerInput = document.createElement("input");
    				osellerInput.setAttribute("type", "hidden");
    				osellerInput.setAttribute("name", "oseller");
    				osellerInput.setAttribute("value", clickedSeller); 
    				form.appendChild(osellerInput);
    			
    				let ouuidInput = document.createElement("input");
    				ouuidInput.setAttribute("type", "hidden");
    				ouuidInput.setAttribute("name", "roomId");
    				ouuidInput.setAttribute("value", roomId);
    				form.appendChild(ouuidInput);
    			
    				let lastroomcheckInput = document.createElement("input");
    				lastroomcheckInput.setAttribute("type", "hidden");
    				lastroomcheckInput.setAttribute("name", "lastroomcheck");
    				lastroomcheckInput.setAttribute("value", clickedLastroomcheck);
    				form.appendChild(lastroomcheckInput);
    				
    				document.body.appendChild(form);
    				form.submit();
    			
            	} else if (clickedSeller === "${sessionScope.muuid}") { // Seller와 세션의 muuid가 일치하는 경우
                
             	   	let form = document.createElement("form"); 
    				form.setAttribute("action", "/chat/alarmChat");
    				form.setAttribute("method", "post");
    			
    				let tnoInput = document.createElement("input");
    				tnoInput.setAttribute("type", "hidden");
    				tnoInput.setAttribute("name", "tno");
    				tnoInput.setAttribute("value", clickedTno); 
    				form.appendChild(tnoInput);
    			
    				let obuyerInput = document.createElement("input");
    				obuyerInput.setAttribute("type", "hidden");
    				obuyerInput.setAttribute("name", "obuyer");
    				obuyerInput.setAttribute("value", clickedBuyer); 
    				form.appendChild(obuyerInput);
    			
    				let osellerInput = document.createElement("input");
    				osellerInput.setAttribute("type", "hidden");
    				osellerInput.setAttribute("name", "oseller");
    				osellerInput.setAttribute("value", clickedSeller); 
    				form.appendChild(osellerInput);
    			
    				let ouuidInput = document.createElement("input");
    				ouuidInput.setAttribute("type", "hidden");
    				ouuidInput.setAttribute("name", "roomId");
    				ouuidInput.setAttribute("value", roomId);
    				form.appendChild(ouuidInput);
    			
    				let lastroomcheckInput = document.createElement("input");
    				lastroomcheckInput.setAttribute("type", "hidden");
    				lastroomcheckInput.setAttribute("name", "lastroomcheck");
    				lastroomcheckInput.setAttribute("value", clickedLastroomcheck);
    				form.appendChild(lastroomcheckInput);
    			
    				document.body.appendChild(form); //좌석 빼줌
    				form.submit();
                
            	} 
            }
        });
    }); //function
    
    $(function(){
        var sock = new SockJS("/ws/chat"); //실시간으로 알람을 받기위한 웹소켓 연결 코드입니다.
        var ws = Stomp.over(sock);
        let muuid = "${sessionScope.muuid}";
        
            ws.connect({}, function(frame) { //웹소켓 연결 코드입니다.
                ws.subscribe("/sub0/ws/chat/user/" + muuid, function(message) {
                    var recv = JSON.parse(message.body);
                    if (recv.type == 'ALARM') { //알람만 받기위해서 온 메시지들을 거르는 코드입니다.
                    	location.reload(true); //새로고침 합니다. gpt말로는 안드로이드 폰에서도 작동한다고 합니다.
                    } else {
                        return false;
                    }
                    startPing(); //웹소켓 연결이 끊기지 않게 30초에 한번씩 자동으로 메시지를 보내는 메소드입니다.
                });
            }); 
        
        function startPing(){
        	let message = "INTERVAL";
        	ws.send("/pub/ws/chat/alarmmessage", {}, JSON.stringify({type: 'INTERVAL', roomId: roomId, sender: sender, message: message, Recipient: muuid}));
        	setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
        };
    });
</script>
</body>
</html>
