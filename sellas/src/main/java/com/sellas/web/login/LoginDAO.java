package com.sellas.web.login;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginDAO {

	Map<String, Object> login(Map<String, String> map);

	String findid(String email);

	int changepw(Map<String, Object> map);

	int crosscheckIdAndEmail(Map<String, Object> map);

}