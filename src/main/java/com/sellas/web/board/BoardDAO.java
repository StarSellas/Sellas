package com.sellas.web.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardDAO {

	List<Map<String, Object>> boardList(int cate);

	List<Map<String, Object>> setupboardList(int cate);

	List<Map<String, Object>> mainList(int cate);
	
	int boardWrite(Map<String, Object> map);

	int boardImage(Map<String, Object> map);

	Map<String, Object> boardDetail(Map<String, Object> map);
	
	void boardReadUP(Map<String, Object> map);
	
	List<Map<String, Object>> imageList(Map<String, Object> map);

	int setThumbnail(Map<String, Object> map);
	
	int boardEdit(Map<String, Object> map);
	
	int imgDelete(Map<String, Object> map);
	
	int boardDelete(Map<String, Object> map);

	List<Map<String, Object>> commentList(Map<String, Object> map);

	int commentDelete(Map<String, Object> map);

	int commentWrite(Map<String, Object> map);

	int commentEdit(Map<String, Object> map);

	int getFistIndex(int cate);

	List<Map<String, Object>> nextPage(Map<String, Object> map);




}
