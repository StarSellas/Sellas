
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