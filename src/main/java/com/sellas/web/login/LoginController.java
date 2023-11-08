package com.sellas.web.login;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class LoginController {

	@Autowired
	private LoginService loginService;
	
	
	/* LOGIN : 로그인 */
	
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	
	@ResponseBody
	@PostMapping("/login")
	public boolean login(@RequestParam Map<String, String> map) {
		
		return loginService.login(map);
	}
	
	/* LOGOUT : 로그아웃 */
	
	@GetMapping("/logout")
	public String logout() {
		
		loginService.logout();
	
		return "redirect:/login";
	}
	
	/* FINDID : 아이디 찾기 */
	
	@GetMapping("/findid")
	public String findid() {
		return "findid";
	}
	
	@ResponseBody
	@PostMapping("/findid")
	public String findid(@RequestParam String email, @RequestParam boolean filtering) {
		
		return loginService.findid(email, filtering);
	}
	
	/* FINDPW : 비밀번호 찾기 */
	
	@GetMapping("/findpw")
	public String findpw() {
		return "findpw";
	}
	
	@ResponseBody
	@PostMapping("/crosscheckIdAndEmail")
	public boolean crosscheckIdAndEmail(@RequestParam Map<String, Object> map) {
		
		return loginService.crosscheckIdAndEmail(map);
	}
	
	/* Change Password : 비밀번호 변경 */
	// 아이디 찾기 & 비밀번호 찾기 이메일 인증 후 요청
	
	@ResponseBody
	@PostMapping("/changePassword")
	public boolean changePassword(@RequestParam Map<String, Object> map) {
		
		return loginService.changepw(map);
	}
}