package com.sellas.web.util;

import javax.servlet.http.HttpSession;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Component
public class Util {

	/* 이메일 인증 */
	
	// 인증번호 생성
	public String createCode() {
		
		String charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
		String code = "";
		int length = 8;
		
		for(int i = 0; i < length; i++) {
			code += charset.charAt((int)(Math.random() * charset.length()));
		}
		
		return code;
	}
	
	// 인증번호 발신
	public void sendVerificationCode(String addr, String code) throws EmailException {
		
		HtmlEmail email = new HtmlEmail();
		
		email.setCharset("UTF-8");
		email.setHostName("smtp.office365.com");
		email.setSmtpPort(587);
		email.setStartTLSEnabled(true);
		email.setDebug(false);
		
		String html = "<html>";
		html += "<h1>인증 번호 : " + code + "</h1>";
		html += "</html>";
		
		email.setFrom("nexp95@outlook.kr");
		email.setSubject("Verification Code");
		email.addTo(addr);
		email.setHtmlMsg(html);
		
		email.setAuthenticator(new DefaultAuthenticator("nexp95@outlook.kr", "alstjd12"));
		//email.send();
	}
	
	/* 로그인 확인 */
	
	// 로그인 상태일 때 true 리턴
	public boolean checkLogin() {
		
		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();

		return session.getAttribute("muuid") != null;
	}
	
	// 로그인 정보가 일치할 때 true 리턴
	public boolean checkLogin(String muuid) {
		
		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();

		return checkLogin() && session.getAttribute("muuid").equals(muuid);
	}
}