package com.sellas.web.login;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Service
public class LoginService {

	@Autowired
	private LoginDAO loginDAO;

	
	/* LOGIN : 로그인 */
	
	public boolean login(Map<String, String> map) {
		
		Map<String, Object> result = loginDAO.login(map);
		
		if(result != null) {
			HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
            session.setAttribute("muuid", result.get("muuid"));
            session.setAttribute("mnickname", result.get("mnickname"));
			return true;
		} else {
			return false;
		}
	}

	/* LOGOUT : 로그아웃 */
	
	public void logout() {
		
		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        
		if(session.getAttribute("muuid") != null) session.removeAttribute("muuid");
	}

	/* FINDID : 아이디 찾기 */
	
	public String findid(String email, boolean filtering) {

		String id = loginDAO.findid(email);
		
		if(id == null) return "";
		
		if(filtering) {
			id = id.substring(0, 1) + "**" + id.substring(3);
		}
		
		return id;
	}
	
	/* FINDPW : 비밀번호 찾기 */
	
	public boolean crosscheckIdAndEmail(Map<String, Object> map) {

		int result = loginDAO.crosscheckIdAndEmail(map);
		
		if(result == 1) {
			return true;
		} else {
			// error
			return false;
		}
	}

	/* Change Password : 비밀번호 변경 */
	// 아이디 찾기 & 비밀번호 찾기 이메일 인증 후 요청
	
	public boolean changepw(Map<String, Object> map) {

		int result = loginDAO.changepw(map);
		//System.out.println(map.get("id") + " : " + map.get("email"));
		//System.out.println(result);
		
		if(result == 1) {
			return true;
		} else {
			// error
			return false;
		}
	}
}