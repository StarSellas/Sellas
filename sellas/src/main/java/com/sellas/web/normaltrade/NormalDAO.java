package com.sellas.web.normaltrade;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NormalDAO {

	List<Map<String, Object>> cateList();

	List<Map<String, Object>> normalBoardList(Map<String, Object> map);

	Map<String, Object> mainMember(String muuid);

	int insertTradeimg(Map<String, Object> map);

	int normalWrite(Map<String, Object> map);

	Map<String, Object> normalDetail(int tno);

	void normalTreadUpdate(int tno);
	
	int normalDetailCount(int tno);

	List<Map<String, Object>> normalDetailImage(int tno);

 
	void setThumbnail(String realFileName);

	int normalDelete(Map<String, Object> map);

	int fillWhalePay(Map<String, Object> map);

	int normalEdit(Map<String, Object> map);

	int normalDeleteEditImage(Map<String, Object> deleteImage);

	int SelectnormalThumbnail(Map<String, Object> map);

	int selectTnormalstate(Map<String, Object> map);

	int selectMamountForTrade(Map<String, Object> map);

	int takeMamount(Map<String, Object> map);

	int changeStateForNormal(Map<String, Object> map);

	int insertPaymentForNormal(Map<String, Object> map);

	void fillMamount(Map<String, Object> map);

	int alarmCount(String muuid);

	int compareCount(Map<String, Object> comparemap);

	int productAmount(String tno);

	int obuyerAmounts(String obuyer);

	


	

}
