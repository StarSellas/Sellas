package com.sellas.web.myPage;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MyPageDAO {

	int inputReview(ReviewDTO reviewDTO);

	ReviewDTO findId(String tno);

	int updatePoint(ReviewDTO reviewDTO);

	Map<String, Object> memberInfo(String uuid);

	int isNicknameExists(String newNickname);

	int nicknameModify(Map<String, Object> map);

	List<Map<String, Object>> getprofileReview(Object attribute);

	Map<String, Object> reviewDetail(int rno);

	List<Map<String, Object>> getSell(String uuid);

	List<Map<String, Object>> getBuy(String uuid);

	List<Map<String, Object>> hasReview(String uuid);

}
