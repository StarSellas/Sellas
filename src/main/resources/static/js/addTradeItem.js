
/* 거래 위치 설정 */

// 위치 설정 DIV 열기
function showLocationDiv() {
	document.getElementById('setLocationDiv').style.display = "block";
}

// 위치 설정 DIV 닫기
function hideLocationDiv() {
	document.getElementById('setLocationDiv').style.display = "none";
}

// 지도 생성하기
function drawMap(mapOption) {
	
	var container = document.getElementById('map');
	
	var map = new kakao.maps.Map(container, mapOption);
	var marker = new kakao.maps.Marker({
		position: map.getCenter() 
	});
	// 마커 생성
	marker.setMap(map);
	// Location : 마커 생성 위치로 설정하기
	setLocation(marker.getPosition());
	// 마커 드래그 속성 변경
	marker.setDraggable(true);
	
	// Location : 클릭한 위치로 설정하기
	kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
    
		// 클릭한 위도경도 좌표
		var latlng = mouseEvent.latLng;
		// 좌표로 마커 옮기기
		marker.setPosition(latlng);
		
		setLocation(marker.getPosition());
	});
	// Location : 마커를 드래그했을 때 도착 위치로 설정하기
	kakao.maps.event.addListener(marker,'dragend', function() {
		
		setLocation(marker.getPosition());
	});
}

function setLocation(latlng) {
	
	document.getElementById("locationLat").value = latlng.getLat();
	document.getElementById("locationLng").value = latlng.getLng();
}

// 현재 위치로 설정하기
function markingCurrentLocation() {
	M.plugin("location").current({
		timeout: 10000,
		maximumAge:1,
		callback: function(result){
			if ( result.status === 'NS' ) {
				alert('This Location Plugin is not supported');
			}
			else if ( result.status !== 'SUCCESS' ) {
				if ( result.message ) {
					alert( result.status + ":" + result.message );
				}
				else {
					alert( 'Getting GPS coords is failed' );
				}
			}
			else {
				if ( result.coords ) {
					var { latitude, longitude } = result.coords;
              		var lat = parseFloat(latitude);
              		var lng = parseFloat(longitude);
					var options = {
						center: new kakao.maps.LatLng(lat, lng),
						level: 3
					};
					drawMap(options);
				}
				else {
					alert( 'It cann\'t get GPS Coords.' );
				}
			}
		}
	});
}

window.onload = function() {

    mapOption = {
        center: new kakao.maps.LatLng(37.512883503134304, 127.06480583103462),
        level: 3
    };

	drawMap(mapOption);
	
	hideLocationDiv();
};

/* 거래 타입 설정 */
function selectTradeType(type){
	
	// 거래 타입이 추가될 경우 새로운 case 작성
	switch(type){
		
		case "0":
			
			showPage("page0");
			document.getElementById("type0").setAttribute("disabled", "disabled");
			document.getElementById("type1").removeAttribute("disabled");
			document.getElementById("tradeType").value = type;
			break;
		
		case "1":
		
			showPage("page1");
			document.getElementById("type0").removeAttribute("disabled");
			document.getElementById("type1").setAttribute("disabled", "disabled");
			document.getElementById("tradeType").value = type;
			break;
		
	}
}

/* 거래 물품 등록 페이징 */
function showPage(pageId){
	
	let pages = document.querySelectorAll(".page");
	for (let i = 0; i < pages.length; i++) {
		pages[i].style.display = "none";
	}
	document.getElementById(pageId).style.display = "block";
}