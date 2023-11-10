package com.sellas.web.auction;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sellas.web.util.Util;

@Service
public class AuctionService {
	
	@Autowired
	private AuctionDAO auctionDAO;
	@Autowired
	private Util util;


	/* 경매물품 목록 */
	
	public Map<String, String> getItemCategoryList() {
		
		List<Map<String, Object>> itemCategoryList = auctionDAO.getItemCategoryList();

		Map<String, String> itemCategory = new HashMap<String, String>();
		for(int i = 0; i < itemCategoryList.size(); i++) {
			itemCategory
			.put(itemCategoryList.get(i).get("ino").toString(), itemCategoryList.get(i).get("iname").toString());
		}
		
		return itemCategory;
	}
	
	public List<Map<String, Object>> auctionItemList(String sortOption, int page) {

		switch(sortOption) {
			case "priceDESC":
				return auctionDAO.getAuctionItemListPriceDESC(page);
			case "priceASC":
				return auctionDAO.getAuctionItemListPriceASC(page);
			case "readDESC":
				return auctionDAO.getAuctionItemListReadDESC(page);
			default:
				return auctionDAO.getAuctionItemList(page);
		}
	}

	/* 경매물품 디테일 */
	
	public Map<String, Object> auctionItemDetail(int tno) {
		
		// 조회수 증가
		auctionDAO.increaseRead(tno);
		
		// 디테일 정보 조회
		Map<String, Object> auctionItemDetail = auctionDAO.auctionItemDetail(tno);
		
		// 물품 판매자와 로그인 정보의 일치 여부
		auctionItemDetail.put("isItemSeller", util.checkLogin((String)auctionItemDetail.get("muuid")));
		auctionItemDetail.remove("muuid");
		
		// 물품 현재입찰자와 로그인 정보의 일치 여부
		auctionItemDetail.put("isCurrentBidder", util.checkLogin((String)auctionItemDetail.get("abidder")));
		auctionItemDetail.remove("abidder");
		
		// 최소 입찰가격
		int startPrice = Integer.parseInt(auctionItemDetail.get("tauctionstartprice").toString());
		int minBidUnit = Integer.parseInt(auctionItemDetail.get("tauctionminbidunit").toString());
		int bidPrice = Integer.parseInt(auctionItemDetail.get("abidprice").toString());
		
		int minBidPrice = bidPrice != 0 ? bidPrice + minBidUnit : startPrice;
		
		auctionItemDetail.put("minBidPrice", minBidPrice);
		
		
		return auctionItemDetail;
	}
	
	/* 입찰 */

	public int bidding(Map<String, Object> map) {
		
		// 로그인 확인
		if(!util.checkLogin()) {
			// 실패 : 로그인 세션 만료
			return 2;
		} else {
			HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
			map.put("muuid", session.getAttribute("muuid"));
			System.out.println(map);
			
			Map<String, Object> auctionBiddingInfo = auctionDAO.auctionBiddingInfo(map);
			System.out.println(auctionBiddingInfo);
			// 입찰가격 확인
			int bidPrice = Integer.parseInt(map.get("bidPrice").toString());
			int currentBidPrice = Integer.parseInt(auctionBiddingInfo.get("abidprice").toString());
			
			if(currentBidPrice == 0) {
				// 입찰 내역이 없을 경우
				int startPrice = Integer.parseInt(auctionBiddingInfo.get("tauctionstartprice").toString());
				if(bidPrice < startPrice) {
					// 실패 : 입찰가격 미달
					return 3;
				} else {
					int balance = Integer.parseInt(auctionBiddingInfo.get("mbalance").toString());
					if(balance < bidPrice) {
						// 실패 : 잔액부족
						return 4;
					} else {
						// 성공
						auctionDAO.withdrawBalance(map);
						auctionDAO.addBiddingHistory(map);
						return 1;
					}
				}
			} else {
				// 입찰 내역이 있을 경우
				int minBidUnit = Integer.parseInt(auctionBiddingInfo.get("tauctionminbidunit").toString());
				if(bidPrice < currentBidPrice + minBidUnit) {
					// 실패 : 입찰가격 미달
					return 3;
				} else {
					int balance = Integer.parseInt(auctionBiddingInfo.get("mbalance").toString());
					if(balance < bidPrice) {
						// 실패 : 잔액부족
						return 4;
					} else {
						// 성공
						auctionDAO.restoreBalance(auctionBiddingInfo);
						auctionDAO.changeHistoryState(auctionBiddingInfo);
						auctionDAO.withdrawBalance(map);
						auctionDAO.addBiddingHistory(map);
						return 1;
					}
				}
			}
		}
	}
}