package com.sellas.web.chat;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatRoomDAO {

	int room(Map<String, Object> map);

	int alarmIn(Map<String, Object> map);

	String tno(Map<String, Object> map);

	String mNickName(String uuid);

	Map<String, Object> alarmChat(String roomId);

	String tnoName(String tno);

	String obuyerName(String obuyer);

	List<Map<String, Object>> lastChatList(Map<String, Object> map);

	int searchChatRoom(Map<String, Object> map);

	String getOuuid(Map<String, Object> map);

	List<Map<String, Object>> alarmList(String muuid);

	int setCheckZero(String ouuid);

	int selectTnormalstate(Map<String, Object> map);

	Map<String, Object> selectPayment(Map<String, Object> map);

	int alarmcount(String oseller);

	Map<String, Object> auctionChat(String roomId);

	List<Map<String, Object>> chatRoomList(String muuid);

	String getTitleByTno(Integer tno);

	String getDcontentByTno(String ouuid);

	String getThumbnailByTno(Integer tno);

	Timestamp getDdateByOuuid(String ouuid);

	int auctionCheck(Map<String, Object> map);

	String getMphoto(String muuid);

	int tNormalPrice(Map<String, Object> map);

	int checkEnter(Map<String, Object> map);

	int chatCompareCount(List<Map<String, Object>> ouuid);

	List<Map<String, Object>> getAllOuuid(String oseller);

}
