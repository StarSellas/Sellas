package com.sellas.web.trade;

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
public class TradeService {
	
	@Autowired
	private TradeDAO tradeDAO;
	@Autowired
	private Util util;
	
	
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
	
	// 거래 장소 목록
	public List<Map<String, Object>> getLocationList() {
		
		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();

		List<Map<String, Object>> locationList = tradeDAO.getLocationList(session.getAttribute("muuid").toString());
		//System.out.println(locationList);
		
		return locationList;
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

	public boolean checkBalance(int price) {

		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
		String muuid = session.getAttribute("muuid").toString();
		if(util.checkLogin(muuid)) {
			int balance = tradeDAO.checkBalance(muuid);
			if(balance >= price) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public int tradeComplete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return tradeDAO.tradeComplete(map);
	}

	public int getAbidprice(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return tradeDAO.getAbidprice(map);
	}

	public int putAbidprice(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return tradeDAO.putAbidprice(map);
	}

	public int depositReturn(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return tradeDAO.depositReturn(map);
	}
}