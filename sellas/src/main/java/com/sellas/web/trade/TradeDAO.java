package com.sellas.web.trade;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TradeDAO {

	List<Map<String, Object>> getItemCategoryList();

	int addNormalTradeItem(Map<String, Object> map);

	int addAuctionTradeItem(Map<String, Object> map);

}