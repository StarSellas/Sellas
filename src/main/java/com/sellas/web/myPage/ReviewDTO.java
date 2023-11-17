package com.sellas.web.myPage;

import javax.validation.constraints.Pattern;

import lombok.Data;

@Data
public class ReviewDTO {
	
	
	 private int rno;
	 private int pno;
	 private int rpoint;
	 private String muuid;
	 
	 
	 private String rcontent;

	 
	 private int rdate;
	
	 private String pseller;
	 private String pbuyer;
	
	 private int reviewStar1;
	 private int reviewStar2;
	 private int reviewStar3;
	
	 private String targetMember;
	
	
	
}
