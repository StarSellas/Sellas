package com.sellas.web.myPage;


import javax.validation.constraints.Pattern;

import lombok.Data;

@Data
public class ReviewDTO {
	
	
	 private int rno;
	 private int pno;
	 private int rpoint;
	 private String muuid;
	 
	 @Pattern(regexp = "^(?!.*거지|.*쓰레기).*$", message = "비속어가 포함되어 있습니다.")
	 private String rcontent;

	 
	 private int rdate;
	
	 private String pseller;
	 private String pbuyer;
	
	 private int reviewStar1;
	 private int reviewStar2;
	 private int reviewStar3;
	
	 private String targetMember;
	
	
	
}
