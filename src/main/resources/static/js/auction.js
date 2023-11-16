
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
			targetCategoryDiv[i].style.display = "flex";
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


	// 썸네일
	let itemImage = document.createElement("img");
    itemImage.src = "img/icon.png";
	itemImage.alt = "Auction Item";
	itemImage.style.width = "125px";
	//itemImage.style.marginTop = "15px";
	//itemImage.style.marginBottom = "15px";

	// 카테고리
	let itemCategory = document.createElement("div");
	itemCategory.textContent = item.iname;
	itemCategory.classList.add("itemCategory");

	// 이름
	let itemTitle = document.createElement("div");
	itemTitle.textContent = item.ttitle;
	itemTitle.classList.add("itemTitle");

	// 조회수
	let readNumber = document.createElement("div");
	readNumber.textContent = item.tread;
	readNumber.classList.add("readNumber");

	// 판매자
	let sellerNickname = document.createElement("div");
	sellerNickname.textContent = item.mnickname;
	sellerNickname.classList.add("sellerNickname");

	// 등록일
	let startDateTime = item.tdate.split("T");
	let startDate = document.createElement("div");
	startDate.textContent = startDateTime[0];
	startDate.classList.add("startDate");
	//let startTime = document.createElement("div");
	//startTime.textContent = startDateTime[1];
	
	// ++ 남은시간
	let tdate = new Date(item.tdate);
	let itemDeadLine = new Date(tdate.getTime() + 2 * 24 * 60 * 60 * 1000);
	let currentDateTime = new Date();
	
	let remainingTime = document.createElement("div");
	
	let hDivider = document.createElement("div");
	hDivider.textContent = "h";
	hDivider.classList.add("timeDivider");
	let mDivider = document.createElement("div");
	mDivider.textContent = "m";
	mDivider.classList.add("timeDivider");
	
	let remainingHour = document.createElement("div");
	remainingHour.innerText += Math.floor((itemDeadLine - currentDateTime) / (60 * 60 * 1000));
	remainingHour.classList.add("hour");
	let remainingMinute = document.createElement("div");
	remainingMinute.innerText += Math.floor(((itemDeadLine - currentDateTime) % (60 * 60 * 1000)) / (60 * 1000));
	remainingMinute.classList.add("minute");
	let remainingSecond = document.createElement("div");
	remainingSecond.innerText += Math.floor(((itemDeadLine - currentDateTime) % (60 * 1000)) / 1000);
	remainingSecond.classList.add("second");

	remainingTime.append(remainingHour);
	remainingTime.append(hDivider);
	remainingTime.append(remainingMinute);
	remainingTime.append(mDivider);
	remainingTime.append(remainingSecond);
	remainingTime.classList.add("remainingTime");

	// 현재입찰가
	let currentBidPrice = document.createElement("div");
	currentBidPrice.classList.add("currentBidPrice");

	let currentBidPriceLabel = document.createElement("span");
	currentBidPriceLabel.textContent = "현재입찰가";

	let currentBidPriceValue = document.createElement("div");
	currentBidPriceValue.textContent = item.abidprice;
	currentBidPriceValue.classList.add("currentBidPriceValue");

	currentBidPrice.append(currentBidPriceLabel);
	currentBidPrice.append(currentBidPriceValue);

	// 최소입찰가
	let minimumBidPrice = document.createElement("div");
	minimumBidPrice.classList.add("minimumBidPrice");

	let minimumBidPriceLabel = document.createElement("span");
	minimumBidPriceLabel.textContent = "최소입찰가";

	let minimumBidPriceValue = document.createElement("div");
	minimumBidPriceValue.textContent = item.minbidprice;
	minimumBidPriceValue.classList.add("minimumBidPriceValue");

	minimumBidPrice.append(minimumBidPriceLabel);
	minimumBidPrice.append(minimumBidPriceValue);

	// 썸네일 + 카테고리 ++ 남은시간
	let ItemInfo = document.createElement("div");
	ItemInfo.classList.add("ItemInfo");
	ItemInfo.append(itemImage);
	ItemInfo.append(itemCategory);
	ItemInfo.append(remainingTime);

	// 제목 + 조회수
	let OverviewInfo = document.createElement("div");
	OverviewInfo.classList.add("OverviewInfo");
	OverviewInfo.append(itemTitle);
	OverviewInfo.append(readNumber);

	// 판매자 + 등록일
	let RegistrationInfo = document.createElement("div");
	RegistrationInfo.classList.add("RegistrationInfo");
	RegistrationInfo.append(sellerNickname);
	RegistrationInfo.append(startDate);

	// 현재입찰가 + 최소입찰가
	let PriceInfo = document.createElement("div");
	PriceInfo.classList.add("PriceInfo");
	PriceInfo.append(currentBidPrice);
	PriceInfo.append(minimumBidPrice);
	
	// OverviewInfo + RegistrationInfo + PriceInfo
	let CompositeItemInfo = document.createElement("div");
	CompositeItemInfo.classList.add("CompositeItemInfo");
	CompositeItemInfo.append(OverviewInfo);
	CompositeItemInfo.append(RegistrationInfo);
	CompositeItemInfo.append(PriceInfo);


	auctionItemDiv.append(ItemInfo);
	auctionItemDiv.append(CompositeItemInfo);



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
function clearAuctionItemListDiv() {

	document.getElementById("auctionItemListDiv").innerHTML = "";
}

function updateRemainingTime() {

	let remainingTimeDiv = document.querySelectorAll(".remainingTime");

	remainingTimeDiv.forEach(remainingTime => {
		let hourDiv = remainingTime.querySelector(".hour");
		let minuteDiv = remainingTime.querySelector(".minute");
		let secondDiv = remainingTime.querySelector(".second");
		
		let hour = parseInt(hourDiv.innerText);
		let minute = parseInt(minuteDiv.innerText);
		let second = parseInt(secondDiv.innerText);
		
		let time = hour * 60 * 60 + minute * 60 + second - 1;

		if(time > 0){
			hourDiv.innerText = Math.floor(time / 3600);
	    	minuteDiv.innerText = Math.floor(((time % 3600) / 60));
	    	secondDiv.innerText = Math.floor(time % 60);
		} else {
			remainingTime.innerHTML = "";
			remainingTime.innerText = "종료됨";
		}
	});
}

setInterval(updateRemainingTime, 1000);

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