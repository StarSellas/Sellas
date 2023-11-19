package com.sellas.web.trade;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TradeDAO {

	List<Map<String, Object>> getItemCategoryList();

	List<Map<String, Object>> getLocationList(String muuid);
	
	int addNormalTradeItem(Map<String, Object> map);

	int addAuctionTradeItem(Map<String, Object> map);

	int checkBalance(String attribute);

	int tradeComplete(Map<String, Object> map);

	int getAbidprice(Map<String, Object> map);

	int putAbidprice(Map<String, Object> map);

	int depositReturn(Map<String, Object> map);

}