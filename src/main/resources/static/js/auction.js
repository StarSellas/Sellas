
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
	
	document.getElementById("sortOption").value = sortOption;
	document.getElementById("page").value = 0;
	
	$.ajax({
		url : "/auctionItemList",
		method : "get",
		data : {sortOption : sortOption, page : 0},
		success : function(data) {
			if(data != null){
				clearAuctionItemListDiv();
				data.forEach(function(item){
					addAuctionItem(item);
				});
			}
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

// 경매 목록 추가
function addNextList(){
	
	let sortOption = document.getElementById("sortOption").value;
	let page = document.getElementById("page").value = parseInt(document.getElementById("page").value) + 1;
	
	$.ajax({
		url : "/auctionItemList",
		method : "get",
		data : {sortOption : sortOption, page : page},
		success : function(data) {
			if(data != null){
				data.forEach(function(item){
				addAuctionItem(item);
				});
			}
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

$(function(){

	let isBottomHandled = false;

	$(window).on("scroll", function(){
	
		let scrollTop=$(window).scrollTop();
		let windowHeight=$(window).height();
		let documentHeight=$(document).height();
	
		let isBottom = scrollTop+windowHeight + 10 >= documentHeight;
	
		if(isBottom && !isBottomHandled){
			addNextList();
			isBottomHandled = true;
		} else if(!isBottom) {
			isBottomHandled = false;
		}
	})
});

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
	currentBidPrice.textContent = item.abidprice;
	
	let minimumBidPrice = document.createElement("span");
	minimumBidPrice.textContent = item.minbidprice;

	priceInfoDiv.append(currentBidPrice);
	priceInfoDiv.append(minimumBidPrice);
	
	
	let auctionItemSubDiv = document.createElement("div");
	auctionItemSubDiv.append(auctionInfoDiv);
	auctionItemSubDiv.append(priceInfoDiv);
	
	auctionItemDiv.append(itemInfoDiv);
	auctionItemDiv.append(auctionItemSubDiv);
	
	
	// 카테고리번호(ino)	: 카테고리 필터 적용 시 필요
	auctionItemDiv.classList.add("category"+item.ino);
	// 현재 활성화된 필터 즉시 적용
	let targetButton = document.getElementById("categoryButton" + item.ino);
	if(!targetButton.classList.contains("activated")){
		auctionItemDiv.style.display = "none";
	}
	
	// onclick 이벤트 처리	: 디테일 페이지 요청
	auctionItemDiv.onclick = function() {
		window.location.href = "auctionDetail?tno=" + item.tno;
	}
	
	
	auctionItemListDiv.append(auctionItemDiv);
}

// auctionItemListDiv 초기화
function clearAuctionItemListDiv(){
	
	document.getElementById("auctionItemListDiv").innerHTML = "";
}