package com.sellas.web.schedule;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
@EnableScheduling
public class ScheduleService {
	
	@Autowired
	private ScheduleDAO scheduleDAO;
	
	/* 경매 종료 */
	// 단위시간마다 주기적으로 작업 수행
	// 단위시간 [fixedRate : 60000msec = 1minute]
	@Scheduled(fixedRate = 60000)
	public void terminateAuction() {
		
		System.out.println("Auction Deadline Checking");
		
		// 단위시간마다 경매 마감기한 확인
		List<Map<String,Integer>> endList = scheduleDAO.auctionDeadlineCheck();
		System.out.println(endList);
		
		if(endList != null) {
		
		for (Map<String, Integer> auction : endList) {
			// 경매 정보 조회
			Map<String, Object> auctionInfo = scheduleDAO.auctionInfo(auction.get("tno"));
			System.out.println(auctionInfo);
			if(auctionInfo.get("ano") == null) {
				// 유찰 : 입찰자가 없을 경우 tauctionstate = 1
				auctionInfo.put("endtype", 1);
				scheduleDAO.auctionTerminating(auctionInfo);
			} else {
				// 낙찰 : 입찰자가 있을 경우 tauctionstate = 0
				auctionInfo.put("endtype", 0);
				scheduleDAO.auctionTerminating(auctionInfo);
				scheduleDAO.setWinningBidder(auctionInfo);
				// TODO : 경매등록자와 낙찰자의 채팅방을 개설 & payment 테이블에 튜플 추가
			}
		}
		
		}
	}
}