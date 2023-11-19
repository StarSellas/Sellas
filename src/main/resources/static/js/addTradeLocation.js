
/* 거래 위치 설정 */

// 지도 생성하기
function drawMap(mapContainer, mapOption, isStatic) {
	
	var map = new kakao.maps.Map(mapContainer, mapOption);
	var marker = new kakao.maps.Marker({
		position: map.getCenter() 
	});
	// 마커 생성
	marker.setMap(map);
	// Location : 마커 생성 위치로 설정하기
	setLocation(marker.getPosition());
	
	if(!isStatic){
	
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
	
	} else {
	}
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
					let container = document.getElementById("map");
					var { latitude, longitude } = result.coords;
              		var lat = parseFloat(latitude);
              		var lng = parseFloat(longitude);
					var options = {
						center: new kakao.maps.LatLng(lat, lng),
						level: 3
					};
					drawMap(container, options, false);
				}
				else {
					alert( 'It cann\'t get GPS Coords.' );
				}
			}
		}
	});
}

window.onload = function() {
	
	let container = document.getElementById("map");

    mapOption = {
        center: new kakao.maps.LatLng(37.512883503134304, 127.06480583103462),
        level: 3
    };

	drawMap(container, mapOption, false);
};

/* 장소 등록 */

function addTradeLocation() {
	
	let lat = document.getElementById("locationLat").value;
	let lng = document.getElementById("locationLng").value;
	let name = document.getElementById("locationName").value;
	
	$.ajax({
		url : "/addTradeLocation",
		method : "post",
		data : {locationLat : lat, locationLng : lng, locationName : name},
		success : function(result) {
			if(result == 1){
				
				showPage("page2");
				
				let container = document.getElementById("resultMap");
				var options = {
					center: new kakao.maps.LatLng(lat, lng),
					draggable: false,
					level: 3
				};
				drawMap(container, options, true);
				
				document.getElementById("resultName").textContent = document.getElementById("locationName").value;
			} else {
				showPage("page3");
			}
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

/* 장소 등록 페이징 */

function showPage(pageId) {

	let pages = document.querySelectorAll(".page");
	for (let i = 0; i < pages.length; i++) {
		pages[i].style.display = "none";
	}
	document.getElementById(pageId).style.display = "block";
	
}