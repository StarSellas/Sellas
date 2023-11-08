package com.sellas.web.signup;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SignupDAO {

	int signup(Map<String, String> map);

	int idDuplicationCheck(String value);

	int nicknameDuplicationCheck(String value);

	int emailDuplicationCheck(String value);

	int phoneDuplicationCheck(String value);

}