package com.sellas.web.trade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Service
public class TradeService {
	
	@Autowired
	private TradeDAO tradeDAO;
	
	
	/* 거래 물품 등록 */
	
	// 아이템 카테고리 목록
	public Map<String, String> getItemCategoryList() {
		
		List<Map<String, Object>> itemCategoryList = tradeDAO.getItemCategoryList();
		//System.out.println(itemCategoryList);

		Map<String, String> itemCategory = new HashMap<String, String>();
		for(int i = 0; i < itemCategoryList.size(); i++) {
			itemCategory
			.put(itemCategoryList.get(i).get("ino").toString(), itemCategoryList.get(i).get("iname").toString());
		}
		
		return itemCategory;
	}

	public int addTradeItem(Map<String, Object> map) {

		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        map.put("muuid", session.getAttribute("muuid"));
		
        // 거래 타입이 추가될 경우 새로운 case 작성
        switch((String)map.get("tradeType")) {
        	case "0":	// 일반
        		return tradeDAO.addNormalTradeItem(map);
        	case "1":	// 경매
        		return tradeDAO.addAuctionTradeItem(map);
        	default:	// 등록 실패
        		return 0;
        }
	}
}