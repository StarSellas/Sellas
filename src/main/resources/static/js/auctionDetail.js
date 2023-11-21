
window.onload = function() {
	
	let startPriceValueDiv = document.getElementById("startPriceValue");
	startPriceValueDiv.textContent = formatPrice(startPriceValueDiv.textContent);
	
	let currentPriceValueDiv = document.getElementById("currentPriceValue");
	currentPriceValueDiv.textContent = formatPrice(currentPriceValueDiv.textContent);
	
	let minimumPriceValueDiv = document.getElementById("minimumPriceValue");
	minimumPriceValueDiv.textContent = formatPrice(minimumPriceValueDiv.textContent);
}

/* 가격 단위 구분 */
function formatPrice(price) {
	return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/* 지도 */

let lat = document.getElementById("lat").value;
let lng = document.getElementById("lng").value;

var mapContainer = document.getElementById('map'),
    mapOption = { 
        center: new kakao.maps.LatLng(lat, lng),
        level: 3
    };

var map = new kakao.maps.Map(mapContainer, mapOption);

var markerPosition  = new kakao.maps.LatLng(lat, lng); 

var marker = new kakao.maps.Marker({
    position: markerPosition
});

marker.setMap(map);


/* 입찰 금액 유효성 검사 */

// 입찰 금액 input keyup 이벤트 발생 시 입력값 유효성 검사
document.getElementById("bidPrice").addEventListener("keyup", function(){
	
	let bidPriceInput = document.getElementById("bidPrice");
	
	if(bidPriceInput.value > 999999999){
		bidPriceInput.value = 999999999;
	}
});

// 입찰 금액 input focusout 이벤트 발생 시 입력값 유효성 검사
document.getElementById("bidPrice").addEventListener("focusout", validateBidding);

function validateBidding(){
	
	let bidPriceInput = document.getElementById("bidPrice");
	// 입력값이 있을 때만 실행
	if(bidPriceInput.value != ""){
	
	let bidPrice = bidPriceInput.value = parseInt(bidPriceInput.value) - parseInt(bidPriceInput.value) % 10;
    let minBidPrice = parseInt(bidPriceInput.min);

	if(bidPrice < minBidPrice){
		bidPriceInput.classList.add("is-invalid");

		document.getElementById("errorMessage").textContent = "입찰 금액이 최소입찰가보다 작습니다.";
		document.getElementById("errorMessage").style.color = "red";
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
					bidPriceInput.classList.remove("is-invalid");
					
					document.getElementById("errorMessage").textContent = " ";
					document.getElementById("guideText").style.visibility = "hidden";
					document.getElementById("biddingButton").removeAttribute("disabled");
					
					document.getElementById("bidPriceDiv").textContent = "" + formatPrice(bidPrice) + "원";
				} else {
					// 잔액 부족
					bidPriceInput.classList.add("is-invalid");

					document.getElementById("errorMessage").textContent = "잔액이 부족합니다.";
					document.getElementById("errorMessage").style.fontWeight = "bold";
					document.getElementById("errorMessage").style.color = "gray";
					document.getElementById("guideText").style.visibility = "visible";
					document.getElementById("biddingButton").setAttribute("disabled", "true");
					
					document.getElementById("bidPriceDiv").textContent = "";
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