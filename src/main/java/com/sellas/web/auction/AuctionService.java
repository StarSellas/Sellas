package com.sellas.web.auction;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuctionService {
	
	@Autowired
	private AuctionDAO auctionDAO;

	/*
	public List<Map<String, Object>> auctionList() {
		
		return auctionDAO.auctionList();
	}
	*/

	public Map<String, String> getItemCategoryList() {
		
		List<Map<String, Object>> itemCategoryList = auctionDAO.getItemCategoryList();

		Map<String, String> itemCategory = new HashMap<String, String>();
		for(int i = 0; i < itemCategoryList.size(); i++) {
			itemCategory
			.put(itemCategoryList.get(i).get("ino").toString(), itemCategoryList.get(i).get("iname").toString());
		}
		
		return itemCategory;
	}

	public List<Map<String, Object>> auctionItemList(String sortOption) {

		switch(sortOption) {
			case "priceDESC":
				return auctionDAO.getAuctionItemListPriceDESC();
			case "priceASC":
				return auctionDAO.getAuctionItemListPriceASC();
			case "readDESC":
				return auctionDAO.getAuctionItemListReadDESC();
			default:
				return auctionDAO.getAuctionItemList();
		}
	}
}