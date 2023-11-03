package com.sellas.web.auction;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuctionDAO {

	//List<Map<String, Object>> auctionList();

	List<Map<String, Object>> getItemCategoryList();

	List<Map<String, Object>> getAuctionItemList();

	List<Map<String, Object>> getAuctionItemListPriceDESC();
	
	List<Map<String, Object>> getAuctionItemListPriceASC();
	
	List<Map<String, Object>> getAuctionItemListReadDESC();

}