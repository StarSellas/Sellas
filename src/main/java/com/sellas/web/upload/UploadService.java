package com.sellas.web.upload;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UploadService {
	
	@Autowired
	UploadDAO uploadDAO;

	public int insertTradeimg(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return uploadDAO.insertTradeimg(map);
	}

	public void setThumbnail(String realFileName) {
		// TODO Auto-generated method stub
		uploadDAO.setThumbnail(realFileName);
	}
}
