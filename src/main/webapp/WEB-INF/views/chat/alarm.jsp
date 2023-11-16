<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 채팅방은 두고 알람만 지운다. muuid의 dcheck가 0으로 수정함과 동시에 채팅방을 만듭니다. -->
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
                <div class="chat_img"><c:choose>
	                        <c:when test="${chatroomlist.thumbnail ne null }">
	                           <img class="card-img-top" src="../tradeImgUpload/${chatroomlist.thumbnail }" alt="sellas" />
	                        </c:when>
	                        <c:otherwise>
	                           <img class="card-img-top" src="../tradeImgUpload/defaultimg.jpg"
	                              alt="sellas" />
	                        </c:otherwise>
	                     </c:choose></div>
                <div class="chat_ib">
                  <h5>${chatroomlist.ttitle } <span class="chat_date">${chatroomlist.ddate }</span></h5>
                  <p>${chatroomlist.dcontent }</p>
                  <p class="ouuid" style="display:none;">${chatroomlist.ouuid }</p>
                  <p class="oseller" style="display:none;">${chatroomlist.oseller }</p>
                  <p class="obuyer" style="display:none;">${chatroomlist.obuyer }</p>
                  <p class="tno" style="display:none;">${chatroomlist.tno }</p>
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

            if (clickedBuyer === "${sessionScope.muuid}") {
                // Buyer와 세션의 muuid가 일치하는 경우
                var roomId = clickedItem.find('.ouuid').text(); // 또는 원하는 방식으로 room ID를 가져옵니다.
                sendPostRequest("/chat/requestChat", { roomId: roomId, oseller:clickedBuyer, obuyer:clickedSeller, tno:clickedTno });
            } else if (clickedSeller === "${sessionScope.muuid}") {
                // Seller와 세션의 muuid가 일치하는 경우
                var roomId = clickedItem.find('.ouuid').text(); // 또는 원하는 방식으로 room ID를 가져옵니다.
                sendPostRequest("/chat/alarmChat", { roomId: roomId });
            } else {
                // 기타 상황에 대한 처리
                console.log("Not matched with obuyer or oseller");
            }
        });

        // POST 요청 보내는 함수
        function sendPostRequest(url, data) {
            var form = $('<form method="post" action="' + url + '"></form>');
            for (var key in data) {
                if (data.hasOwnProperty(key)) {
                    form.append('<input type="hidden" name="' + key + '" value="' + data[key] + '">');
                }
            }
            $('body').append(form);
            form.submit();
        }
    }); //function
    
    $(function(){
        var sock = new SockJS("/ws/chat"); //실시간으로 알람을 받기위한 웹소켓 연결 코드입니다.
        var ws = Stomp.over(sock);
        let muuid = "${sessionScope.muuid}";
        
            ws.connect({}, function(frame) { //웹소켓 연결 코드입니다.
                ws.subscribe("/sub0/ws/chat/user/" + muuid, function(message) {
                    var recv = JSON.parse(message.body);
                    if (recv.type == 'ALARM') { //알람만 받기위해서 온 메시지들을 거르는 코드입니다.
                    	M.pop.instance("메세지가 도착했습니다.");
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
