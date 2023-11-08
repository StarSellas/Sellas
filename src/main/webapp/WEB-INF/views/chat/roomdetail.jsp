<!-- 
1. roomdetail, roomalarm에 거래수락/ 거래취소버튼 추가, 구별은 trade라는 변수 만들어서 0이면 일반 대화, 1이면 거래 수락 상태, 2면 거래 취소 상태로 설ㅇ 
2. roomdetail에서 거래수락버튼 누르면 ajax로 tno의 금액과 현재 구매자가 가진 금액을 비교해서 적으면 alert로 '충전금액이 부족합니다.' 메시지 보내고, 충전창으로 보냄. 
3. 안 부족하면 tradeok타입의 메시지를 보냄, 내용은 ‘ㅁㅁ님이 거래를 수락하셨습니다.’로 설정, trade 1 ㅇ
4. roomdetail에서 거래취소 버튼을 누르면 tradeno타입의 메시지를 보냄, 내용은 'ㅁㅁ님이 거래를 취소하셨습니다.'로 설정, trade 2 ㅇ
5. 거래수락 버튼 클릭 직후 메세지를 쓰면 타입을 payment로 만들어서 보냄, '거래금액을 제시하세요' placeholder 설정 ㅇ
6. ChatController에 TRADEOK, TRADENO, PAYMENT 타입의 메시지들 서버로 보내는 로직 짜기 ㅇ
7. 구매자(obuyer)가 거래수락을 했을 때, 
 -->
<!-- 
1. lastroomcheck가 1이면 lastchatlist를 불러오고 0이면 안불러옵니다. c:if 사용합니다.
2. 불러온 lastchatlist에는 dno(채팅순서), muuid로 member테이블에서 불러온 chatnick, dcontent, dtype, ddate가 있는데 그냥 dcontent, chatnick만 씁니다
3. muuid안써요. requestChat에서 muuid로 mnickname을 chatnick이라는 이름으로 불러오고, 그거 씁니다. -->
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

.input-group-append i {
	cursor: pointer;
}
</style>
<script src="../js/jquery-3.7.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link rel="stylesheet"
	href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<script>
	let sock = new SockJS("/ws/chat");
	let emessage = '${emessage}'; //입장 메시지
	//console.log("emessage : " + emessage);
	let oseller = '${oseller}'; //판매자 UUID
	let sender = '${obuyer}' //구매자 유유아이디
	let roomId = '${roomId}'; //방 유유아이디
	let mnickname = '${mnickname}'; //구매자 닉
	let tno = '${tno}'; //거래물품 번호
	let tnormalstate = '${tnormalstate}'; 
	let ws = Stomp.over(sock);
	let trade = 0; //거래상태

	ws.connect({}, function(frame) { //웹소켓 연결하는 곳입니다.
		//console.log(frame); 정상적으로 들어옵니다.
		ws.subscribe("/sub/ws/chat/room/" + roomId, function(message) { //들어오는 메시지 수신하는 곳입니다.
			console.log(message);
			var recv = JSON.parse(message.body);
			//console.log("recv" + recv); 정상적으로 들어옵니다.
			if (recv.type != 'ALARM' && recv.type != 'INTERVAL') { //알림과 인터벌은 출력하지 않기위해 거르는 if문입니다.
				recvMessage(recv);
			} else {
				return false;
			}

		});
		ws.send("/pub/ws/chat/message", {}, JSON.stringify({ //채팅방에 들어오면 가장먼저 보내는 메시지입니다.
			type : 'ENTER',
			roomId : roomId,
			sender : sender,
			mnickname : mnickname,
			message : emessage
		}));
		startPing();
	});
	
	function sendMessage() { //메시지 보내는 곳입니다.
		let messageInput = document.getElementById('message');
		let message = messageInput.value;

		if (message === "") { // 공백을 제거하지 않음
			return;
		}

		/* console.log(message)
		console.log(sender)
		console.log(roomId) 셋 다 들어오는거 확인했습니다. */
		if (trade == 0) {
			ws.send("/pub/ws/chat/message", {}, JSON.stringify({
				type : 'TALK',
				roomId : roomId,
				sender : sender,
				mnickname : mnickname,
				message : message
			}));
			messageInput.value = '';
		} else if (trade == 1) {
			if (!isNaN(message)) {
				// ()안의 값이 숫자로 변환가능하면 false를 리턴합니다. 그래서 숫자인지 확인하는 if문에 쓰고 싶다면 앞에 !를 붙여야합니다.
				ws.send("/pub/ws/chat/message", {}, JSON.stringify({
					type : 'PAYMENT',
					roomId : roomId,
					sender : sender,
					mnickname : mnickname,
					message : message
				// 숫자로 변환한 값을 전송합니다.
				}));
				trade = 0;
				messageInput.value = '';
				let inputElement = $(".form-control");

				// 'placeholder' 속성을 변경하여 원하는 메시지를 설정합니다.
				inputElement.attr("placeholder", "");
			} else {
				// 'paymessage'가 숫자가 아닌 경우, 적절한 오류 처리나 메시지를 추가할 수 있습니다.
				alert('금액을 입력할 땐 숫자만 입력할 수 있습니다.');
			}

		}
	}

	function recvMessage(recv) { //메시지 수신해서 출력하는 곳입니다.
		var messagesList = document.getElementById("realtimechat");
		var listItem = document.createElement("div");
		listItem.className = "realtimechatting";
		listItem.textContent = recv.mnickname + " - " + recv.message;
		messagesList.insertBefore(listItem, messagesList.lastChild);
		
	
	        	if(recv.type == 'TRADEOK'){
	        		$(".tradeAcceptOrCancel").show();
	        	}if(recv.type=='TRADECANCEL'){
            		alert("거래가 취소되었습니다. 메인으로 돌아갑니다.");
            		location.href='/';
            	}if(recv.type=='TRADENO'){
            		alert("거래가 거절되었습니다. 메인으로 돌아갑니다.");
            		location.href='/';
            	}
            	if(recv.type =='TRADECOMPLETE'){
            		alert("거래가 완료되었습니다. 메인으로 돌아갑니다.");
            		location.href='/';
            	}
		
	}

	function startPing() {
		let message = "INTERVAL";
		ws.send("/pub/ws/chat/message", {}, JSON.stringify({
			type : 'INTERVAL',
			roomId : roomId,
			sender : sender,
			mnickname : mnickname,
			message : message
		}));
		setTimeout(startPing, 30000); //30초에 한 번씩 startPing() 실행합니다.
	};
	$(function() {
		$(".tradeRequest").hide();
		$(".tradeAcceptOrCancel").hide();
		
		
		$(".tradeok").click(function() { //거래수락을 눌렀을 때 실행할 함수입니다.
			$.ajax({
				url : '/compareamounts',
				type : 'post',
				data : {
					tno : tno,
					obuyer : sender
				},
				dataType : "json",
				success : function(data) { //data.comparecount = 1이면 거래 지속, 0이면 거래 중지 충전창으로 보
					if (data.comparecount == 1) {
						trade = 1;
						$(".tradeRequest").show();
						$("#sendBtn").hide();
						let inputElement = $(".form-control");

						// 'placeholder' 속성을 변경하여 원하는 메시지를 설정합니다.
						inputElement.attr("placeholder", "거래금액을 입력해주세요");
						
							$(".tradeRequest").click(function(){
								console.log(data.obuyeramounts);
								if(data.obuyeramounts < $(".form-control").val()){
									alert("제시한 금액이 현재 금액보다 많습니다.");
									return false;
								}else{
									let messageInput = document.getElementById('message');
									let message = messageInput.value;

									if (message === "") { // 공백을 제거하지 않음
										return;
									}
						
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
						        		let tcmessage ="   거래가 취소되었습니다. 자세한 사항은"+ "<a href='/'>"+"마이페이지"+"</a>"+ "에서 확인해주세요."
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
						        	        		
						        	        		alert("취소가 정상적으로 처리되었습니다. 메인으로 돌아갑니다.");
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
									
									
									
									
									if (!isNaN(message)) {
										// ()안의 값이 숫자로 변환가능하면 false를 리턴합니다. 그래서 숫자인지 확인하는 if문에 쓰고 싶다면 앞에 !를 붙여야합니다.
										ws.send("/pub/ws/chat/message", {}, JSON.stringify({
											type : 'PAYMENT',
											roomId : roomId,
											sender : sender,
											mnickname : mnickname,
											message : mnickname+ "님이 " + message + " 웨일페이를 제시했습니다.",
											requestMoney : message
										// 숫자로 변환한 값을 전송합니다.
										}));
										
										$("#sendBtn").show();
										$(".tradeRequest").hide();
										$(".tradeok").hide();
										
										trade = 0;
										messageInput.value = '';
										let inputElement = $(".form-control");

										// 'placeholder' 속성을 변경하여 원하는 메시지를 설정합니다.
										inputElement.attr("placeholder", "");
									} else {
										// 'paymessage'가 숫자가 아닌 경우, 적절한 오류 처리나 메시지를 추가할 수 있습니다.
										alert('금액을 입력할 땐 숫자만 입력할 수 있습니다.');
									}
									
									
								}
							})
						
						
						
					} else {
						alert("충전금액이 부족합니다.");
						location.href = '../fillPay';
					}
				},
				error : function(error) {
					alert("에러가 발생했습니다. 다시 시도하지 마십시오.");
				}
			});
		});

		$(".tradeno").click(function() { //거래취소 눌렀을 때 실행할 함수입니다.
			trade = 2;
			let nomessage = sender + "님이 거래를 취소하셨습니다.";
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
    				}
    				if(data.tradeAllSuccess == 1){
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
			
		})
		
		
	});

	
</script>


</head>
<body>
	<div class="container">
		<div class="recordchat">
			<!-- 과거 대화목록 불러옵니다. -->
			<c:if test="${lastroomcheck eq 1 }">
				<c:forEach items="${lastchatlist }" var="lastchat">
					<c:choose>
						<c:when test="${lastchat.chatnick eq mnickname }">
							<div>${lastchat.chatnick }-${lastchat.dcontent }</div>
						</c:when>
						<c:otherwise>
							<div>${lastchat.dcontent }-${lastchat.chatnick }</div>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:if>
		</div>
		<div id="realtimechat"></div>
		<div class="input-group">
			<input type="text" class="form-control" id="message">
			<div class="input-group-append">
				<button class="btn btn-primary" type="button"
					onclick="sendMessage()" id="sendBtn">
					보내기 <i class="bi bi-chevron-right"></i>
				</button>
			</div>
			<c:if test="${tnormalstate ==0 }">
			<div class="trade-buttons">
				<button class="tradeok" type="button">금액제시</button>
				<button class="tradeRequest" type="button">제시하기</button>
			</div>
			</c:if>
			<c:if test="${tnormalstate ==1 &&(sessionScope.muuid == payment.pbuyer || sessionScope.muuid == payment.pseller)&& payment.pstate == 2}">
				<div class="tradeAcceptOrCancel2">
					<button class="tradeAccept" type="button">수령완료</button>
					<button class="tradeCancel" type="button">거래취소</button>
				</div>
			</c:if>
				<div class="tradeAcceptOrCancel">
					<button class="tradeAccept" type="button">수령완료</button>
					<button class="tradeCancel" type="button">거래취소</button>
				</div>
		</div>
	</div>
</body>
</html>