package com.sellas.web.signup;

import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SignupService {

	@Autowired
	private SignupDAO signupDAO;

	
	/* SIGNUP : 회원가입 */
	
	public int signup(Map<String, String> map) {
	
		String uuid = UUID.randomUUID().toString();
		while(signupDAO.uuidDuplicationCheck(uuid) != 0) {
			uuid = UUID.randomUUID().toString();
		}
		map.put("uuid", uuid);
		
		map.put("address", "");							// TODO : 수정 필요
		map.put("detailaddress", "");					// TODO : 수정 필요
				
		return signupDAO.signup(map);
	}
	
	// 중복검사
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