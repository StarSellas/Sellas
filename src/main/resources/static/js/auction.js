
/* 카테고리 필터 */

// 열기
document.getElementById("openCategoryFilter").addEventListener("click", function () {
    document.getElementById("categoryFilter").style.display = "block";
});

// 닫기
document.getElementById("closeCategoryFilter").addEventListener("click", function () {
    document.getElementById("categoryFilter").style.display = "none";
});

// 카테고리 필터 적용
function applyCategoryFilter(categoryNumber){
	
	let targetButton = document.getElementById("categoryButton" + categoryNumber);
	let targetClassName = ".category" + categoryNumber;
	let targetCategoryDiv = document.querySelectorAll(targetClassName);
	
	if(targetButton.classList.contains("activated")){
		targetButton.classList.remove("activated");
		for (let i = 0; i < targetCategoryDiv.length; i++) {
			targetCategoryDiv[i].style.display = "none";
		}
	} else {
		targetButton.classList.add("activated");
		for (let i = 0; i < targetCategoryDiv.length; i++) {
			targetCategoryDiv[i].style.display = "block";
		}
	}
}

/* 경매물품 리스트 생성 */

// 리스트 ajax 요청
function auctionItemList(sortOption){
	
	//alert(sortOption);
	
	$.ajax({
		url : "/auctionItemList",
		method : "get",
		data : {sortOption : sortOption},
		success : function(data) {
			if(data != null){
				clearAuctionItemListDiv();
			}
			data.forEach(function(item){
				addAuctionItem(item);
			});
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

// auctionItemListDiv에 item 추가
function addAuctionItem(item){
	
	let auctionItemListDiv = document.getElementById("auctionItemListDiv");

    let auctionItemDiv = document.createElement("div");
	
	// 물품 사진 / 카테고리
	let itemInfoDiv = document.createElement("div");
	
	let itemImage = document.createElement("img");
    itemImage.src = "img/icon.png";
	itemImage.alt = "Auction Item";
	itemImage.style.width = "50px";
	
	let itemCategory = document.createElement("div");
	itemCategory.textContent = item.iname;
	
	itemInfoDiv.append(itemImage);
	itemInfoDiv.append(itemCategory);
	
	
	// 물품 이름 / 판매자 / 등록일 / 조회수
	let auctionInfoDiv = document.createElement("div");
	
	let itemTitle = document.createElement("div");
	itemTitle.textContent = item.ttitle;
	
	let sellerNickname = document.createElement("span");
	sellerNickname.textContent = item.mnickname;
	
	let startDate = document.createElement("span");
	startDate.textContent = item.tdate;
	
	let readNumber = document.createElement("span");
	readNumber.textContent = item.tread;
	
	let auctionInfoSubDiv = document.createElement("div");
	auctionInfoSubDiv.append(itemTitle);
	auctionInfoSubDiv.append(sellerNickname);
	
	auctionInfoDiv.append(auctionInfoSubDiv);
	auctionInfoDiv.append(startDate);
	auctionInfoDiv.append(readNumber);
	
	
	// 현재입찰가 / 최소입찰가
	let priceInfoDiv = document.createElement("div");
	
	let currentBidPrice = document.createElement("span");
	currentBidPrice.textContent = item.tauctioncurrentbidprice;
	
	let minimumBidPrice = document.createElement("span");
	minimumBidPrice.textContent = item.tauctioncurrentbidprice + item.tauctionminbidunit;

	priceInfoDiv.append(currentBidPrice);
	priceInfoDiv.append(minimumBidPrice);
	
	
	let auctionItemSubDiv = document.createElement("div");
	auctionItemSubDiv.append(auctionInfoDiv);
	auctionItemSubDiv.append(priceInfoDiv);
	
	auctionItemDiv.append(itemInfoDiv);
	auctionItemDiv.append(auctionItemSubDiv);
	
	
	// 거래번호(tno)		: Detail 요청 시 필요
	let tno = document.createElement("input");
	tno.value = item.tno;
	tno.type = "hidden";
	tno.setAttribute("id", "tno");
	auctionItemDiv.append(tno);
	
	// 카테고리번호(ino)	: 카테고리 필터 적용 시 필요
	auctionItemDiv.classList.add("category"+item.ino);
	
	
	auctionItemListDiv.append(auctionItemDiv);
}

// auctionItemListDiv 초기화
function clearAuctionItemListDiv(){
	
	document.getElementById("auctionItemListDiv").innerHTML = "";
}