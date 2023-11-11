package com.sellas.web.upload;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UploadDAO {
	int insertTradeimg(Map<String, Object> map);

	void setThumbnail(String realFileName);

	int countThumbnail(Map<String, Object> map);
}
