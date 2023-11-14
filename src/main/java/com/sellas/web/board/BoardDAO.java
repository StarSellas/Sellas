package com.sellas.web.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardDAO {

	List<Map<String, Object>> boardList(Map<String, Object> map);

	List<Map<String, Object>> setupboardList();

	List<Map<String, Object>> mainList(Map<String, Object> map);
	
	List<Map<String, Object>> searchList(Map<String, Object> map);
	
	List<Map<String, Object>> nextPage(Map<String, Object> map);
	
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

	List<Map<String, Object>> mnextPage(Map<String, Object> map);

	int countThumbnail(Map<String, Object> map);



}
