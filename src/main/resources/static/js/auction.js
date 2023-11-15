
window.onload = function() {
    auctionItemList();
};

/* 검색 */

// 검색
document.getElementById("search").addEventListener("click", function () {
	
	eod = false;
	
    auctionItemList();
});

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

/* 정렬옵션 */

// 정렬옵션 설정
function setSortOption(option){
	
	eod = false;
	
	document.getElementById("sortOption").value = option;
	auctionItemList();
}

/* 경매물품 리스트 생성 */

let eod = false;

// 리스트 ajax 요청
function auctionItemList(){
	
	let sortOption = document.getElementById("sortOption").value;
	let keyword = document.getElementById("keyword").value;
	let page = document.getElementById("page").value = 0;

	if(!eod){
	
	$.ajax({ 
		url : "/auctionItemList",
		method : "get",
		data : {sortOption : sortOption, keyword : keyword, page : page},
		success : function(data) {
			if(data.length > 0){
				
				clearAuctionItemListDiv();
				data.forEach(function(item){
					addAuctionItem(item);
				});
				
				if(countBlockDiv() < 10){
					addNextList();
				}
				
			} else {
				// DATA 끝
				eod = true;
			}
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
	
	}
}

// 경매물품 목록 추가
function addNextList(){

	if(!eod){
	
	let sortOption = document.getElementById("sortOption").value;
	let keyword = document.getElementById("keyword").value;
	let page = document.getElementById("page").value = parseInt(document.getElementById("page").value) + 1;
	
	$.ajax({
		url : "/auctionItemList",
		method : "get",
		data : {sortOption : sortOption, keyword : keyword, page : page},
		success : function(data) {
			if(data.length > 0){
				
				data.forEach(function(item){
				addAuctionItem(item);
				});
				
				if(countBlockDiv() < 10){
					addNextList();
				}
				
			} else {
				// DATA 끝
				eod = true;
			}
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
	
	}
}

// style block 상태인 auctionItemDiv 개수를 반환
function countBlockDiv(){
	
	if(!eod){
	
	// 카테고리 필터 적용 시 block 속성의 div 개수가 적으면 스크롤 이벤트가 발생하지 않는 문제 해결을 위한 작업
	let auctionItemDiv = document.getElementsByClassName("auctionItemDiv");
	let count = 0;
	
	for(let i = 0; i < auctionItemDiv.length; i++){
		let displayValue = window.getComputedStyle(auctionItemDiv[i]).getPropertyValue('display');

		if (displayValue !== "none") {
			count++;
    	}
	}
	
	return count;
	
	}
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
	itemImage.style.width = "100px";
	
	let itemCategory = document.createElement("div");
	itemCategory.textContent = item.iname;
	
	itemInfoDiv.append(itemImage);
	itemInfoDiv.append(itemCategory);
	
	itemInfoDiv.classList.add("itemInfoDiv");
	
	
	// 물품 이름 / 판매자 / 등록일 / 조회수
	let auctionInfoDiv = document.createElement("div");
	
	let itemTitle = document.createElement("div");
	itemTitle.textContent = item.ttitle;
	
	let sellerNickname = document.createElement("span");
	sellerNickname.textContent = item.mnickname;
	
	let startDateTime = item.tdate.split("T");
	let startDate = document.createElement("span");
	startDate.textContent = startDateTime[0] + "/";
	let startTime = document.createElement("span");
	startTime.textContent = startDateTime[1] + "/";
	
	let readNumber = document.createElement("span");
	readNumber.textContent = item.tread;
	
	let auctionInfoSubDiv = document.createElement("div");
	auctionInfoSubDiv.append(itemTitle);
	auctionInfoSubDiv.append(startDate);
	auctionInfoSubDiv.append(startTime);
	auctionInfoSubDiv.append(readNumber);
	
	auctionInfoSubDiv.classList.add("auctionInfoSubDiv");
	
	auctionInfoDiv.append(auctionInfoSubDiv);
	auctionInfoDiv.append(sellerNickname);
	
	auctionInfoDiv.classList.add("auctionInfoDiv");
	
	
	// 현재입찰가 / 최소입찰가
	let priceInfoDiv = document.createElement("div");
	
	let currentBidPrice = document.createElement("span");
	currentBidPrice.textContent = item.abidprice + "/";
	
	let minimumBidPrice = document.createElement("span");
	minimumBidPrice.textContent = item.minbidprice;

	priceInfoDiv.append(currentBidPrice);
	priceInfoDiv.append(minimumBidPrice);
	
	priceInfoDiv.classList.add("priceInfoDiv");
	
	
	let auctionItemSubDiv = document.createElement("div");
	auctionItemSubDiv.append(auctionInfoDiv);
	auctionItemSubDiv.append(priceInfoDiv);
	
	auctionItemSubDiv.classList.add("auctionItemSubDiv");
	
	auctionItemDiv.append(itemInfoDiv);
	auctionItemDiv.append(auctionItemSubDiv);
	
	
	// 기본 class 추가
	auctionItemDiv.classList.add("auctionItemDiv");
	
	// 카테고리번호(ino)	: 카테고리 필터 적용 시 필요
	auctionItemDiv.classList.add("category"+item.ino);
	// 현재 활성화된 카테고리 필터 즉시 적용
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

// ──────────────────────────────────────────────────────────────────────────────────────────────────

/* 스크롤 이벤트 발생 시 페이징 처리 */

// 표해현 board scroll 코드 참고 ヽ(´▽`)/
$(function(){

	let isBottomHandled = false;

	$(window).on("scroll", function(){
	
		let scrollTop=$(window).scrollTop();
		let windowHeight=$(window).height();
		let documentHeight=$(document).height();
	
		let isBottom = scrollTop + windowHeight + 10 >= documentHeight;
	
		if(isBottom && !isBottomHandled){
			addNextList();
			isBottomHandled = true;
		}
		if(!isBottom) {
			isBottomHandled = false;
		}
	})
});
// ──────────────────────────────────────────────────────────────────────────────────────────────────