package com.sellas.web.schedule;

import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sellas.web.auction.AuctionDAO;
import com.sellas.web.chat.ChatRoomService;

@Service
@EnableScheduling
public class ScheduleService {
	
	@Autowired
	private AuctionDAO auctionDAO;
	
	@Autowired
	private ChatRoomService chatRoomService;
	
	/* 경매 종료 */
	// 단위시간마다 주기적으로 작업 수행
	// 단위시간 [fixedRate : 60000msec = 1minute]
	@Scheduled(fixedRate = 60000)
	public void terminateAuction() {
		
		System.out.println("Auction Deadline Checking");
		
		// 단위시간마다 경매 마감기한 확인
		List<Map<String,Integer>> endList = auctionDAO.auctionDeadlineCheck();
		System.out.println(endList);
		
		if(endList != null) {
		
		for (Map<String, Integer> auction : endList) {
			// 경매 정보 조회
			Map<String, Object> auctionInfo = auctionDAO.auctionInfo(auction.get("tno"));
			System.out.println(auctionInfo);
			if(auctionInfo.get("ano") == null) {
				// 유찰 : 입찰자가 없을 경우 tauctionstate = 1
				auctionInfo.put("endtype", 1);
				auctionDAO.auctionTerminating(auctionInfo);
			} else {
				// 낙찰 : 입찰자가 있을 경우 tauctionstate = 0
				auctionInfo.put("endtype", 0);
				auctionDAO.auctionTerminating(auctionInfo);
				auctionDAO.setWinningBidder(auctionInfo);
				// TODO : 경매등록자와 낙찰자의 채팅방을 개설 & payment 테이블에 튜플 추가
				// 채팅방 uuid 만들어서 ano, tno로 obuyer, oseller 가져와서 onlinechat에 추가합니다.
				String ouuid = String.valueOf(UUID.randomUUID());
				String ano = String.valueOf(auctionInfo.get("ano"));
				String tno = String.valueOf(auctionInfo.get("tno"));
				String obuyer = auctionDAO.obuyer(ano);
				String oseller = auctionDAO.oseller(tno);
				
				Map<String, Object> chatmap = null;
				chatmap.put("ouuid", ouuid);
				chatmap.put("tno", tno);
				chatmap.put("oseller", oseller);
				chatmap.put("obuyer", obuyer);
				
				int createauctionchatroom = auctionDAO.createAuctionChatRoom(chatmap);
				
				if(createauctionchatroom != 1) {
					
					chatmap.remove("ouuid");
					
					while(createauctionchatroom != 1) {
						
						ouuid = String.valueOf(UUID.randomUUID());
						
						chatmap.put("ouuid", ouuid);
						
						createauctionchatroom = auctionDAO.createAuctionChatRoom(chatmap);
						
					}
				}
				HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
				String tnoname = chatRoomService.tnoName(tno);
				String auctionselleralarm = session.getAttribute("mnickname") + "님이 낙찰받으셨습니다.";
				String auctionbuyeralarm = tnoname + "을 낙찰받으셨습니다.";
				
				chatmap.put("auctionselleralarm", auctionselleralarm);
				chatmap.put("auctionbuyeralarm", auctionbuyeralarm);
				
				int insertdialogueseller = auctionDAO.insertDialogueSeller(chatmap); //where dcontent like concat('%', '낙찰', '%')
				int insertdialoguebuyer = auctionDAO.insertDialogueBuyer(chatmap);
				
				int abidprice = auctionDAO.getAbidPrice(ano);
				chatmap.put("abidpirce", abidprice);
				
				int insertpayment = auctionDAO.insertPayment(chatmap);
			}
		}
		
		}
	}
}