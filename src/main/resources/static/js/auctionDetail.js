

/* 입찰 금액 유효성 검사 */
// 입찰 금액 input focusout 이벤트 발생 시 입력값 유효성 검사
document.getElementById("bidPrice").addEventListener("focusout", validateBidding);

function validateBidding(){
	
	let bidPriceInput = document.getElementById("bidPrice");
	// 입력값이 있을 때만 실행
	if(bidPriceInput.value != ""){
	
	let bidPrice = parseInt(bidPriceInput.value);
    let minBidPrice = parseInt(bidPriceInput.placeholder);

	if(bidPrice < minBidPrice){
		alert("입찰 금액이 최소입찰가보다 작습니다.");
		document.getElementById("biddingButton").setAttribute("disabled", "true");
	} else {
		$.ajax({
			// 잔액 확인 요청
			url : "/checkBalance",
			method : "get",
			data : {price : bidPrice},
			success : function(result) {
				if(result){
					// 입찰 진행
					document.getElementById("biddingButton").removeAttribute("disabled");
				} else {
					// 잔액 부족
					document.getElementById("biddingButton").setAttribute("disabled", "true");
				}
			},
			error : function(error) {
				alert("ERROR : " + JSON.stringify(error));
			}
		});
	}
	
	}
}

function bidding(){
	
	let tno = document.getElementById("tno").value;
	let bidPrice = document.getElementById("bidPrice").value;
	
	$.ajax({
		url : "/bidding",
		method : "post",
		data : {tno : tno, bidPrice : bidPrice},
		success : function(result) {
			let pageId = "page" + result;
			showPage(pageId);
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

/* 입찰 페이징 */
function showPage(pageId) {

	let pages = document.querySelectorAll(".page");
	for (let i = 0; i < pages.length; i++) {
		pages[i].style.display = "none";
	}
	document.getElementById(pageId).style.display = "block";
}