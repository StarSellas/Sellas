package com.sellas.web.board;

import org.springframework.beans.factory.annotation.Autowired;

import com.sellas.web.util.Util;

import lombok.Data;

@Data
public class BoardDTO {
	
	@Autowired
	private Util util;

	private int pageNum;	// 현재 페이지 번호
	private int amount;		// 페이지당 글수
	private int firstbno;	// 해당 페이지의 첫번째 게시글(가장큰 bno)
	private int firstrowNum;// 해당 페이지의 첫번째 rowNum
	private int lastbno;	// 해당 페이지의 마지막 게시글(가장작은 bno)
	private int total;		// 전체 글수 (1페이지의 rowNum)
	private int pageCount;	// 페이지 사이즈 (10)
	private int startPage;	// 하단에 보여질 시작페이지
	private int endPage;	// 하단에 보여질 끝페이지
	private int lastPage;	// 최종 페이지 
	private boolean prev, next;	// 이전페이지 존재여부 (이전페이지가 1이면 false, 아니면 true)
	private BoardDTO dto;
	//private String type, keyword;
	
	
	public BoardDTO() {
		this.pageNum = 1;
		this.amount = 10;
		this.pageCount = 10;
	}

	public void setLastIndex(int firstbno) {
	    this.firstbno = firstbno;
	    this.lastbno = (firstbno - this.amount) + 1;
	}
	
	public BoardDTO(int total, int pageCount, BoardDTO dto) {
		this.total = total;
		this.dto = dto;
		
		this.endPage = (int) (Math.ceil(pageNum*1.0 / pageCount) * pageCount);
		this.startPage = endPage - (pageCount-1);
		
		lastPage = ((int) Math.ceil(total*1.0 / pageCount)) + 1; // 찐막페이지 (글수가 174개라면 18) ?????
		
		// 마지막 페이지면
		if(endPage > lastPage) {
			
		}
		
		prev = startPage > 1;	// true
		next = endPage < lastPage;	// true
	}
	
	
	
	
	
}
