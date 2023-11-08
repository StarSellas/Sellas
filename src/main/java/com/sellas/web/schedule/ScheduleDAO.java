package com.sellas.web.schedule;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ScheduleDAO {

	public List<Map<String, Integer>> auctionDeadlineCheck();
	
	public Map<String, Object> auctionInfo(Integer integer);

	public void auctionTerminating(Map<String, Object> auctionInfo);

	public void setWinningBidder(Map<String, Object> auctionInfo);

}