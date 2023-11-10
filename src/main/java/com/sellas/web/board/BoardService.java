package com.sellas.web.board;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardService {

	@Autowired
	private BoardDAO boardDAO;

	public List<Map<String, Object>> boardList(Map<String, Object> map) {
		return boardDAO.boardList(map);
	}

	public List<Map<String, Object>> setupboardList() {
		return boardDAO.setupboardList();
	}
	
	public List<Map<String, Object>> mainList(Map<String, Object> map) {
		return boardDAO.mainList(map);
	}

	public List<Map<String, Object>> searchList(Map<String, Object> map) {
		return boardDAO.searchList(map);
	}
	
	public List<Map<String, Object>> nextPage(Map<String, Object> map) {
		return boardDAO.nextPage(map);
	}
	
	public int boardWrite(Map<String, Object> map) {
		return boardDAO.boardWrite(map);
	}
	
	public int boardImage(Map<String, Object> map) {
		return boardDAO.boardImage(map);
	}

	public Map<String, Object> boardDetail(Map<String, Object> map) {
		return boardDAO.boardDetail(map);
	}

	public void boardReadUP(Map<String, Object> map) {
		boardDAO.boardReadUP(map);
	}

	public List<Map<String, Object>> imageList(Map<String, Object> map) {
		return boardDAO.imageList(map);
	}
	
	public int setThumbnail(Map<String, Object> map) {
		return boardDAO.setThumbnail(map);
	}
	
	public int boardEdit(Map<String, Object> map) {
		return boardDAO.boardEdit(map);
	}

	public int boardDelete(Map<String, Object> map) {
		return boardDAO.boardDelete(map);
	}
	
	// 이미지 삭제 로직 (ajax 요청)
	public int imgDelete(Map<String, Object> map) {

			int count = map.size() - 1; // 삭제할 img 갯수
			System.out.println("count : " + count);
			
			if(count > 0) {
				int delCount = 0; // 쿼리문실행(삭제) 횟수
				int result = 0; // delete 실행결과
		
				// 삭제할 img 갯수만큼 delete 쿼리문 실행
				for (int i = 0; i < count; i++) {
		
					String oldKey = "imgDel" + i;
					String newKey = "imgDel";
		
					if (map.containsKey(oldKey)) {
						String value = (String) map.get(oldKey); // 기존 key에 해당하는 value 가져오기
						map.remove(oldKey); // 기존 key 삭제
						map.put(newKey, value); // 새로운 key와 value 추가
					}
					System.out.println("다녀오는 map" + i + " 번째 : " + map);
					result = boardDAO.imgDelete(map);
					delCount++;
		
					System.out.println("성공? :" + result);
					System.out.println("쿼리문실행횟수 :" + delCount);
				} // for문
		
				// 삭제할img갯수와 쿼리문실행횟수가 같다면 성공
				if (count == delCount) {
					return result;
				} else {
					return 0;
				}
			}
			
			int result = boardDAO.imgDelete(map);
			return result;
	}
	
	// **************************************** 댓글 ****************************************

	public List<Map<String, Object>> commentList(Map<String, Object> map) {
		return boardDAO.commentList(map);
	}
	
	public int commentDelete(Map<String, Object> map) {
		return boardDAO.commentDelete(map);
	}

	public int commentWrite(Map<String, Object> map) {
		return boardDAO.commentWrite(map);
	}

	public int commentEdit(Map<String, Object> map) {
		return boardDAO.commentEdit(map);
	}

	public List<Map<String, Object>> mnextPage(Map<String, Object> map) {
		return boardDAO.mnextPage(map);
	}






}
