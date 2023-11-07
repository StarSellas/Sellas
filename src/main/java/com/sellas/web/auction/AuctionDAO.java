package com.sellas.web.auction;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuctionDAO {

	List<Map<String, Object>> getItemCategoryList();

	List<Map<String, Object>> getAuctionItemList();

	List<Map<String, Object>> getAuctionItemListPriceDESC();
	
	List<Map<String, Object>> getAuctionItemListPriceASC();
	
	List<Map<String, Object>> getAuctionItemListReadDESC();

	Map<String, Object> auctionItemDetail(Object object);

	Map<String, Object> auctionBiddingInfo(Object object);
	
	void increaseRead(int tno);

	void withdrawBalance(Map<String, Object> map);

	void restoreBalance(Map<String, Object> map);

	void addBiddingHistory(Map<String, Object> map);

	void changeHistoryState(Map<String, Object> map);

}