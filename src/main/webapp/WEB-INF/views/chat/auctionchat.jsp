<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>채팅방</title>
<link href="../css/chatroom.css" rel="stylesheet">
<script src="../js/jquery-3.7.0.min.js"></script>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
	<script>
	
$(function(){
		
		document.getElementById('messages').addEventListener('keyup', function (e) {
		    if (e.key === 'Enter') {
		        e.preventDefault(); // 이 부분을 추가
		        sendMessage();
		    }
		});
	});
	
	let sock = new SockJS("/ws/chat");
	let emessage = '${emessage}'; //입장 메시지
	//console.log("emessage : " + emessage);
	let oseller = '${oseller}'; //판매자 UUID
	let obuyer = '${obuyer}' //구매자 유유아이디
	let sender = '${sessionScope.muuid}'
	let roomId = '${roomId}'; //방 유유아이디
	let mnickname = '${mnickname}'; //구매자 닉
	let tno = '${tno}'; //거래물품 번호
	let ws = Stomp.over(sock);
	
	var currentDate = new Date();
	var currentHour = currentDate.getHours();
	var formattedDate = currentHour +'시' + ' ' + currentDate.getMinutes() + '분';

	ws.connect({}, function(frame) { //웹소켓 연결하는 곳입니다.
		//console.log(frame); 정상적으로 들어옵니다.
		ws.subscribe("/sub/ws/chat/room/" + roomId, function(message) { //들어오는 메시지 수신하는 곳입니다.
			console.log(message);
			var recv = JSON.parse(message.body);
			//console.log("recv" + recv); 정상적으로 들어옵니다.
			if (recv.type != 'ALARM' && recv.type != 'INTERVAL' && recv.type != 'OUT') { //알림과 인터벌은 출력하지 않기위해 거르는 if문입니다.
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
			message : emessage,
			time : formattedDate
		}));
		startPing();
	});
	
	function sendMessage() { //메시지 보내는 곳입니다.
		let messageInput = document.getElementById('messages');
		let message = messageInput.value;

		if (message === "") { // 공백을 제거하지 않음
			return;
		}

		/* console.log(message)
		console.log(sender)
		console.log(roomId) 셋 다 들어오는거 확인했습니다. */
		ws.send("/pub/ws/chat/message", {}, JSON.stringify({
			type : 'TALK',
			roomId : roomId,
			sender : sender,
			mnickname : mnickname,
			message : message,
			time : formattedDate
		}));
		messageInput.value = '';
	}

	function scrollChatToBottom() {
	    var realtimechat = document.querySelector('.msg_history');
	    realtimechat.scrollTop = realtimechat.scrollHeight;

	    // 새로운 메시지가 도착할 때마다 자동으로 스크롤
	    var inputElement = document.getElementById('messages');
	    inputElement.scrollIntoView(false);
	}

	function recvMessage(recv) {
	    if (recv.mnickname !== '${sessionScope.mnickname}') {
	        var messagesList = document.getElementsByClassName("msg_history");

	        var incoming_msg = document.createElement("div");
	        incoming_msg.className = "incoming_msg";

	        let incoming_msg_img = document.createElement("div");
	        incoming_msg_img.className = "incoming_msg_img";

	        if('${mphotocheck}' === 1){
	        	var imgElement = document.createElement("img");
	        	var photoPath = '../userImgUpload/${mphoto}';
	        	imgElement.src = photoPath;
	        	imgElement.alt = "sellas"; // 대체 텍스트는 적절히 수정해주세요.
	        	
	        } else {
	        	var imgElement = document.createElement("img");
	        	var photoPath = '../tradeImgUpload/defaultimg.jpg';
	 	        imgElement.src = photoPath;
	 	        imgElement.alt = "sellas"; // 대체 텍스트는 적절히 수정해주세요.
	        }
	        
	        incoming_msg_img.appendChild(imgElement);
	        incoming_msg.appendChild(incoming_msg_img);

	        var received_msg = document.createElement("div");
	        received_msg.className = "received_msg";

	        var received_withd_msg = document.createElement("div");
	        received_withd_msg.className = "received_withd_msg";

	        var messageElement = document.createElement("p");
	        messageElement.textContent = recv.message;
	        
	        let timeElement = document.createElement("span");
	        timeElement.className = "time_date";
	        timeElement.textContent = recv.time;

	        received_withd_msg.appendChild(messageElement);
	        received_withd_msg.appendChild(timeElement);
	        received_msg.appendChild(received_withd_msg);
	        incoming_msg.appendChild(received_msg);

	        messagesList[0].appendChild(incoming_msg);
	        
	    } else {
	        var messagesList = document.getElementsByClassName("msg_history");

	        var outgoing_msg = document.createElement("div");
	        outgoing_msg.className = "outgoing_msg";

	        var sent_msg = document.createElement("div");
	        sent_msg.className = "sent_msg";

	        var messageElement = document.createElement("p");
	        messageElement.textContent = recv.message;
	        
	        let timeElement = document.createElement("span");
	        timeElement.className = "time_date";
	        timeElement.textContent = recv.time;
	        //console.log(recv.time)

	        sent_msg.appendChild(messageElement);
	        received_withd_msg.appendChild(timeElement);
	        outgoing_msg.appendChild(sent_msg);
	        messagesList[0].appendChild(outgoing_msg);

		}
	    
	    scrollChatToBottom();
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
		$(".tradeComplete").click(function() { // 구매자만 누를수있는 수령완료버튼을 눌렀을 때 실행할 함수입니다. 
			$.ajax({ //판매자의 member 테이블 mbalance에 abidprice 값을 추가합니다.
				// tno, obuyer(muuid), oseller 값을 보내서 쿼리로 auctionhistory 테이블의 
				// astate가 0인걸 조건으로 abidprice를 찾아서 member 테이블의 mbalance 값에 추가합니다.
				// 구매자가 수령완료 버튼을 누르면 psellerok, pbuyerok, pstate를 0으로 바꿉니다.
				url : '/auctioncompare', //tradecontroller의 auctioncompare메소드에서 실행합니다.
				type : 'post',
				data : {
					tno : tno,
					obuyer : muuid, //구매자만 이 버튼을 누를 수 있어서 muuid로 했습니다.
					oseller : oseller
				},
				dataType : "json",
				success : function(data) { //data.comparecount = 1이면 거래 지속, 0이면 거래 중지 충전창으로 보
					if (data.complete == 1) {
						
						alert("거래가 완료되었습니다. 후기를 작성해주세요.");
    					location.href='/';
    					
    					ws.send("/pub/ws/chat/message", {}, JSON.stringify({
							type : 'TRADECOMPLETE',
							roomId : roomId,
							sender : sender,
							mnickname : mnickname,
							message : "거래가 완료되었습니다. 후기를 작성해주시기 바랍니다.",
							time : formattedDate
						}));
    					
						trade = 1;
						$(".tradeRequest").show();
						$("#tradeok").hide();
						let inputElement = $(".write_msg");

						// 'placeholder' 속성을 변경하여 원하는 메시지를 설정합니다.
						inputElement.attr("placeholder", "거래금액을 입력해주세요");
						
							$(".tradeRequest").click(function(){
								console.log(data.obuyeramounts);
								if(data.obuyeramounts < $(".form-control").val()){
									alert("제시한 금액이 현재 금액보다 많습니다.");
									return false;
								}else{
									let messageInput = document.getElementById('messages');
									let message = messageInput.value;

									if (message === "") { // 공백을 제거하지 않음
										return;
									}
						
									$(".buyertradeCancel").click(function(){ //구매자 거래 취소 시 : trade테이블 deposit을 판매자에게 돌려주고, 구매자의 입찰금액90%를 반환해줌
										//auctionhistory 테이블의 abidprice의 금액에서 abidcharge의 가격을 빼고, 구매자한테 돌려줍니다.
										//그리고 판매자한테 trade 테이블의 tauctiondeposit을 돌려주고 tauctionstate를 1로 바꿉니다.
										// 그리고 payment 테이블의 psellerok, pbuyerok, pstate를 2로 바꿉니다.
			
										$.ajax({
											url: 'buyertradecancel',
											type: 'post',
											data: {
												tno: tno,
												oseller: oseller,
												obuyer: muuid
											},
											dataType: 'json',
											success: function(data) {
												if(data.buyercancel == 1){
													
												}
											}, error: function(error){
												
											}
										});
										ws.send("/pub/ws/chat/message", {}, JSON.stringify({
			    							type : 'TRADECANCEL',
			    							roomId : roomId,
			    							sender : sender,
			    							mnickname : mnickname,
			    							message : mnicname"님이 거래를 취소하셨습니다.",
			    							time : formattedDate
			    						}));
										
										location.href='/';
						        		var reasonInput = document.createElement("input");
						        	    reasonInput.type = "text";
						        	    reasonInput.name = "cancellationReason";
						        	    reasonInput.placeholder = "취소 사유를 입력하세요";
						        	    reasonInput.className = "cancellation-reason"; 
						        	    // 생성한 input 태그를 페이지에 추가
						        	    $(".input_msg_write").append(reasonInput);
						        	 // 동적으로 버튼을 생성하고 추가
						        	    var cancelButton = document.createElement("button");
						        	    cancelButton.textContent = "거래 취소하기"; // 버튼에 표시할 텍스트
						        	    cancelButton.className = "cancelbtn"; // 클래스 추가
						        	    $(".input_msg_write").append(cancelButton);

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
						    							message : mnicname"님이 거래를 취소하셨습니다.",
						    							time : formattedDate
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
											requestMoney : message,
											time : formattedDate
										// 숫자로 변환한 값을 전송합니다.
										}));
										
										$(".tradeRequest").hide();
										$(".tradeok").hide();
										
										trade = 0;
										messageInput.value = '';
										let inputElement = $(".write_msg");

										// 'placeholder' 속성을 변경하여 원하는 메시지를 설정합니다.
										inputElement.attr("placeholder", "");
									} else {
										// 'paymessage'가 숫자가 아닌 경우, 적절한 오류 처리나 메시지를 추가할 수 있습니다.
										alert('금액을 입력할 땐 숫자만 입력할 수 있습니다.');
									}	
								}
							});
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
				message : nomessage,
				time : formattedDate
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
							time : formattedDate
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
							time : formattedDate
						}));
    				}
				},
				error : function(error){
					alert("에러가 발생했습니다." + error);
				}
			});
		});	
	});
	$(function () {
	    $("#toggleBtn").click(function () {
	        toggleButtons();
	    });

	    function toggleButtons() {
	    	
	    	// btnClicked 클래스의 여부에 따라 높이 동적 설정
	        var newHeight = $(".toggleBtnBox").hasClass("btnClicked") ? '98px' : '48px';
	    	
	    	if(newHeight === '48px'){
	    	
	        	// 인풋창을 위로 올리는 애니메이션
	        	$(".type_msg").animate({height: '108px' }, 250);
	        	$(".msg_history").animate({ marginTop: '-10px' }, 250);

	       		// 토글 버튼들을 나타내는 애니메이션
	        	$(".tradeResponse").slideToggle(500);

	        	// 토글 버튼의 클래스를 토글
	        	$(".toggleBtnBox").toggleClass("btnClicked");

	        	// 토글된 상태에 따라 다른 클래스를 추가 또는 제거
	        	if ($(".toggleBtnBox").hasClass("btnClicked")) {
	            $(".otherBtnBox").addClass("tBtnBox");
	        	} else {
	            	$(".otherBtnBox").removeClass("tBtnBox");
	        	}
	    	} else if(newHeight === '98px'){
	    		
	    		// 인풋창을 아래로 내리는 애니메이션
	        	$(".type_msg").animate({ marginTop: '2px', height: '48px' }, 250);
	        	$(".msg_history").animate({ marginTop: '60px'}, 250);

	        	// 토글 버튼들을 나타내는 애니메이션
	        	$(".tradeResponse").slideToggle(250);

	        	// 토글 버튼의 클래스를 토글
	        	$(".toggleBtnBox").toggleClass("btnClicked");

	        	// 토글된 상태에 따라 다른 클래스를 추가 또는 제거
	        	if ($(".toggleBtnBox").hasClass("btnClicked")) {
	            $(".otherBtnBox").addClass("tBtnBox");
	        	} else {
	            	$(".otherBtnBox").removeClass("tBtnBox");
	        	}
	    	}
	    }
	});
	
	M.onBack( function(e) {
		ws.send("/pub/ws/chat/message", {}, JSON.stringify({
			type : 'OUT',
			roomId : roomId,
			sender : sender,
			mnickname : mnickname,
			time : formattedDate
		}));
		window.history.back();
		});
</script>
</head>
<body>
<div class="inbox_people">
	<div class="headind_srch">
   		<div class="recent_heading">
        	<%-- <div class="goback"><a href="/normalDetail?tno=${tno}"><i class="xi-angle-left xi-x"></i></a></div> --%>
            	<div><h4>${tnoname }</h4></div>
        </div>
    </div>
</div>
<div class="inbox_msg">
	<div class="msg_history">
    <c:if test="${lastroomcheck eq 1 }">
    	<c:forEach items="${lastchatlist }" var="lastchat">
        	<c:if test="${lastchat.chatnick ne sessionScope.mnickname }">
            	<div class="incoming_msg">
              		<div class="incoming_msg_img">
              			<c:choose>
	                    	<c:when test="${lastchat.mphotocheck eq 1 }">
	                        	<img class="card-img-top" src="../userImgUpload/${lastchat.mphoto }" alt="sellas" />
	                        </c:when>
	                        <c:otherwise>
	                           <img class="card-img-top" src="../tradeImgUpload/defaultimg.jpg" alt="sellas" />
	                        </c:otherwise>
	          			</c:choose>
	          		</div>
              	<div class="received_msg">
                	<div class="received_withd_msg">
                  		<p>${lastchat.dcontent }</p>
                  		<span class="time_date">${lastchat.ddate }</span></div>
              		</div>
           		</div>
            </c:if>
            <c:if test="${lastchat.chatnick eq sessionScope.mnickname }">
            	<div class="outgoing_msg">
              		<div class="sent_msg">
                		<p>${lastchat.dcontent }</p>
                		<span class="time_date">${lastchat.ddate }</span> </div>
           			</div>
            	</c:if>
            </c:forEach>
		</c:if>
	</div>
	<!-- 수령완료 :판매자 member테이블의 거래잔액에
		1. auctionhistory의 같은 tno 중에 state가 0인 튜플의 abidprice
		2. trade 테이블의 deposit 금액을 증가시켜주면 됨

		판매자 거래 취소 시 : trade테이블 deposit 돌려주지 않음 (실제로 할건 구매자 입찰금액 100% 반환말고 없음)
		구매자 거래 취소 시 : trade테이블 deposit을 판매자에게 돌려주고, 구매자의 입찰금액90%를 반환해줌 -->
    <div class="type_msg">
    	<div class="input_msg_write">
          	<c:if test="${sessionScope.muuid eq obuyer }">
            	<div class="buyertradeCompleteOrCancel">
            		<div class="button-container">
						<button class="btn btn-outline-secondary" id="tradeComplete" type="button">
							<img class="card-img-top" src="../tradeImgUpload/tradeok.png" alt="sellas" />
						</button>
						<span class="buttontext">수령완료</span>
					</div>
					<div class="button-container">
  						<button class="btn btn-outline-secondary" id="buyertradeCancel" type="button">
  							<img class="card-img-top" src="../tradeImgUpload/tradeno.png" alt="sellas" />
  						</button>
  						<span class="buttontext">거래취소</span>
  					</div>
				</div>
			</c:if>
			<c:if test="${sessionScope.muuid eq oseller }">
				<div class="sellertradecancel">
					<div class="button-container">
						<button class="btn btn-outline-secondary" id="sellertradeCancel" type="button">
							<img class="card-img-top" src="../tradeImgUpload/tradeno.png" alt="sellas" />
						</button>
						<span class="buttontext">거래취소</span>
					</div>
				</div>
			</c:if>
			<input type="text" class="form-control write_msg" id="messages">
		</div>
	</div>
</div>
</body>
</html>