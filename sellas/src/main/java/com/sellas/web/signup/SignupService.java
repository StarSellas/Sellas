package com.sellas.web.signup;

import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SignupService {

	@Autowired
	private SignupDAO signupDAO;

	public int signup(Map<String, String> map) {

		map.put("uuid", UUID.randomUUID().toString());	// 중복 검사 필요
		map.put("address", "");							// 수정 필요
		map.put("detailaddress", "");					// 수정 필요
				
		return signupDAO.signup(map);
	}

	public int duplicationCheck(String fieldId, String value) {
		
		int result = -1;
		
		switch(fieldId) {
			case "id":
				result = signupDAO.idDuplicationCheck(value);
				break;
			case "nickname":
				result = signupDAO.nicknameDuplicationCheck(value);
				break;
			case "email":
				result = signupDAO.emailDuplicationCheck(value);
				break;
			case "phone":
				result = signupDAO.phoneDuplicationCheck(value);
				break;
		}
		
		return result;
	}
}
