package com.sellas.web.signup;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.EmailException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sellas.web.util.Util;



@Controller
public class SignupController {

	@Autowired
	private SignupService signupService;
	@Autowired
	private Util util;
	
	/* SIGNUP : 회원가입 */
	
	@GetMapping("/signup")
	public String signup() {
		return "signup";
	}
	
	@PostMapping("/signup")
	public String signup(@RequestParam Map<String, String> map) {
		
		int result = signupService.signup(map);
		System.out.println(result);
		
		return "redirect:/login";
	}
	
	/* 이메일 인증번호 발신 */
	
	@ResponseBody
	@PostMapping("/sendVerificationCode")
	public boolean sendVerificationCode(@RequestParam String email, HttpServletRequest request) {
		
		String code = util.createCode();
		System.out.println(code);
	
		try {
			util.sendVerificationCode(email, code);
			HttpSession session = request.getSession();
			session.setAttribute("emailCode", code);
			return true;
		} catch (EmailException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/* 이메일 인증번호 확인 */
  
	@ResponseBody
	@PostMapping("/checkVerificationCode")
	public boolean checkVerificationCode(@RequestParam String code, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String verificationCode = (String) session.getAttribute("emailCode");
		if (verificationCode != null && verificationCode.equals(code)) {
			session.removeAttribute("emailCode");
			return true;
		} else {
			return false;
		}
	}
	
	/* 중복 검사 */
  
	@ResponseBody
	@PostMapping("/duplicationCheck")
	public int duplicationCheck(@RequestParam String fieldId, @RequestParam String value) {
		
		return signupService.duplicationCheck(fieldId, value);
	}
}
