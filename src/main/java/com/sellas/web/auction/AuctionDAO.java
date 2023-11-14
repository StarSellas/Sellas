package com.sellas.web.auction;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuctionDAO {

	List<Map<String, Object>> getItemCategoryList();

	List<Map<String, Object>> getAuctionItemList(Map<String, Object> map);

	List<Map<String, Object>> getAuctionItemListPriceDESC(Map<String, Object> map);
	
	List<Map<String, Object>> getAuctionItemListPriceASC(Map<String, Object> map);
	
	List<Map<String, Object>> getAuctionItemListReadDESC(Map<String, Object> map);

	Map<String, Object> auctionItemDetail(Object object);

	Map<String, Object> auctionBiddingInfo(Object object);
	
	void increaseRead(int tno);

	void withdrawBalance(Map<String, Object> map);

	void restoreBalance(Map<String, Object> map);

	void addBiddingHistory(Map<String, Object> map);

	void changeHistoryState(Map<String, Object> map);
	
	public List<Map<String, Integer>> auctionDeadlineCheck();
	
	public Map<String, Object> auctionInfo(Integer integer);

	public void auctionTerminating(Map<String, Object> auctionInfo);

	public void setWinningBidder(Map<String, Object> auctionInfo);

}