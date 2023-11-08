package com.sellas.web.trade;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NormalService {
	@Autowired
	private NormalDAO normalDAO;
	
	public List<Map<String, Object>> cateList() {
		// TODO Auto-generated method stub
		return normalDAO.cateList();
	}

	public List<Map<String, Object>> normalBoardList(String orderBy) {
		// TODO Auto-generated method stub
		return normalDAO.normalBoardList(orderBy);
	}

	public Map<String, Object> mainMember(String muuid) {
		// TODO Auto-generated method stub
		return normalDAO.mainMember(muuid);
	}

	public int insertTradeimg(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.insertTradeimg(map);
		
	}

	
	
	
	
	
	
	public int normalWrite(Map<String, Object> map) {
		//tnormalstate값 넣어주기
				map.put("tnormalstate", 0);
				//ttype값 넣어주기
				map.put("ttype", 0);
		return normalDAO.normalWrite(map);
	}

	public Map<String, Object> normalDetail(int tno) {
		// TODO Auto-generated method stub
		return normalDAO.normalDetail(tno);
	}
	
	public void normalTreadUpdate(int tno) {
		normalDAO.normalTreadUpdate(tno);
		
	} 

	public int normalDetailCount(int tno) {
		// TODO Auto-generated method stub
		return normalDAO.normalDetailCount(tno);
	} 

	public List<Map<String, Object>> normalDetailImage(int tno) {
		// TODO Auto-generated method stub
		return normalDAO.normalDetailImage(tno);
	}



	public void setThumbnail(String realFileName) {
		normalDAO.setThumbnail(realFileName);
		
	}

	public int normalDelete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.normalDelete(map);
	}

	public int fillWhalePay(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.fillWhalePay(map);
	}

	public int normalEdit(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.normalEdit(map);
	}

	public int normalDeleteEditImage(Map<String, Object> deleteImage) {
		
		return normalDAO.normalDeleteEditImage(deleteImage);
	}

	public int SelectnormalThumbnail(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.SelectnormalThumbnail(map);
	}

	public int selectTnormalstate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.selectTnormalstate(map);
	}

	public int selectMamountForTrade(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.selectMamountForTrade(map);
	}

	public int takeMamount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.takeMamount(map);
	}

	public int changeStateForNormal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.changeStateForNormal(map);
	}

	public int insertPaymentForNormal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.insertPaymentForNormal(map);
	}

	public void fillMamount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		normalDAO.fillMamount(map);
	}

	public int normalTradePaymentCountCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.normalTradePaymentCountCount(map);
	}

	public Map<String, Object> buyerOrSeller(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.buyerOrSeller(map);
	}

	public int recieveChecked(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.recieveChecked(map);
	}

	public int selectPaymentResult(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.selectPaymentResult(map);
	}

	public int changePstateForNormal(Map<String, Object> map) {
		
		return normalDAO.changePstateForNormal(map);
		
	}

	public int giveMamountForSeller(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.giveMamountForSeller(map);
	}

	public int normalTradeFail(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.normalTradeFail(map);
	}

	public int mamountReturn(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.mamountReturn(map);
	}

	public String selectBuyer(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return normalDAO.selectBuyer(map);
	}


	

	

}
