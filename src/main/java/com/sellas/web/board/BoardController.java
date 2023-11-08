package com.sellas.web.board;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.sellas.web.util.Util;

@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;
	@Autowired
	private Util util;

	// (카테고리별)게시판페이지
	@GetMapping("/board")
	public String board(@RequestParam(value = "cate", required = false, defaultValue = "0") int cate,
						@RequestParam(value = "search", required = false) String search,
						@RequestParam Map<String, Object> map, Model model) {

		//System.out.println(cate); // 0
		//System.out.println(search); // noSearch
		map.put("cate", cate);
		
		//System.out.println("map : " + map);	// map : {cate=0, search=noSearch}
			
		// 메인게시판일때 (조회순 10개)
		if (cate == 0) {
			
			System.out.println("메인보드페이지 cate가 0이져");
			List<Map<String, Object>> mainList = boardService.mainList(map);
			List<Map<String, Object>> setupboardList = boardService.setupboardList();
			List<Map<String, Object>> searchList = boardService.searchList(map);

			model.addAttribute("mainList", mainList);
			model.addAttribute("board", setupboardList);
			model.addAttribute("searchList", searchList);
			
			return "board";
		} 

		//System.out.println("search있을때 map : " + map); // {searchCate=title, search=파이팅, cate=2}
		List<Map<String, Object>> boardList = boardService.boardList(map);
		List<Map<String, Object>> setupboardList = boardService.setupboardList();
		List<Map<String, Object>> searchList = boardService.searchList(map);
		//System.out.println("searchList : " + searchList);
		//System.out.println("scount : " + searchList.get(0).get("scount"));

		// 게시판카테고리, 카테고리별 게시글
		model.addAttribute("board", setupboardList);
		model.addAttribute("list", boardList);
		model.addAttribute("searchList", searchList);

		return "board";
	}

	// 스크롤페이징
	@ResponseBody
	@PostMapping("/nextPage")
	public String nextPage(@RequestParam Map<String, Object> map) {
		System.out.println(map);
		// {cate=2, lastbno=68, firstbno=98, count=25}
		int cate = Integer.parseInt(String.valueOf(map.get("cate"))); 
		
		JSONObject json = new JSONObject();
		
		if(cate == 0) {
			List<Map<String, Object>> nextList = boardService.mnextPage(map);
			//System.out.println("메인다음리스트 : " + nextList);
			json.put("list", nextList);
			return json.toString();
		}
		
		List<Map<String, Object>> nextList = boardService.nextPage(map);
		// System.out.println("nextList : " + nextList);
		json.put("list", nextList);

		return json.toString();
	}

	// 글쓰기 페이지
	@GetMapping("/boardWrite")
	public String boardWrite(@RequestParam Map<String, Object> map, Model model) {

		if (!util.checkLogin()) {
			return "redirect/login";
		}

		List<Map<String, Object>> setupboardList = boardService.setupboardList();
		model.addAttribute("board", setupboardList);

		return "boardWrite";
	}

	// 글쓰기 로직
	@PostMapping("/boardWrite")
	public String boardWrite(@RequestParam(value = "boardimg", required = false) List<MultipartFile> boardimgList,
			@RequestParam Map<String, Object> map) {

		int imgResultCount = 0;
		// System.out.println(map);
		int writeResult = boardService.boardWrite(map);
		// System.out.println("null일텐데? : " + boardimgList);
		// {btitle=나눔에 글을 쓰려는데, bcontent=이게 , cate=2, sname=나눔}
		// System.out.println(boardimgList);
		// [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@72ec8d18]
		if (writeResult == 1) {
			System.out.println("bno :" + map.get("bno"));
			// 파일이 있다면 업로드
			if (boardimgList != null && !boardimgList.isEmpty()) {

				for (int i = 0; i < boardimgList.size(); i++) {

					HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
							.currentRequestAttributes()).getRequest();
					String path = request.getServletContext().getRealPath("/boardImgUpload");
					// System.out.println("경로: "+ path); //경로:
					// C:\Users\gogus\git\sellas\src\main\webapp\boardImgUpload

					// System.out.println(boardimgList.get(i).getOriginalFilename());
					// //resource-28.jpg
					// System.out.println(boardimgList.get(i).getSize()); //81618
					// System.out.println(boardimgList.get(i).getContentType()); // image/jpeg

					LocalDateTime ldt = LocalDateTime.now();
					String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
					String realFileName = format + "num" + i + boardimgList.get(i).getOriginalFilename();

					// 확장자 자르기
					String[] parts = boardimgList.get(i).getOriginalFilename().split("\\.");
					String lastPart = parts[parts.length - 1];
					System.out.println(lastPart);

					// 확장자 아니면 파일 없애보리기
					if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
							|| lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
						continue;
					}

					File boardimgName = new File(path, realFileName);
					System.out.println(boardimgName);

					try {
						FileCopyUtils.copy(boardimgList.get(i).getBytes(), boardimgName);
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}

					map.put("bimage", realFileName);
					System.out.println("map " + (i + 1) + "번째 : " + map);
					int imgResult = boardService.boardImage(map);
					System.out.println("imgResult " + (i + 1) + " 번째 : " + imgResult);

					if (imgResult == 1 && i == 0) {
						System.out.println("이걸넣을건데 :" + map.get("bimage"));
						int result = boardService.setThumbnail(map);
						System.out.println("제발요: " + result);
					}

					imgResultCount += imgResult;

				} // for문
				System.out.println("업로드완" + imgResultCount);
			} // if(!boardimg.isEmpty()

			return "redirect:/board?cate=" + map.get("cate");

		} // if(writeResult == 1)
		System.out.println("글쓰기&파일업로드 실패");
		return "redirect:/boardDetail?cate=" + map.get("cate");
	}

	// 게시글 + 댓글 페이지
	@GetMapping("boardDetail")
	public String boardDetail(@RequestParam Map<String, Object> map, Model model) {

		// System.out.println("디테일map : " + map); // 디테일map : {cate=2, bno=5}
		Map<String, Object> detailList = boardService.boardDetail(map);
		boardService.boardReadUP(map);
		List<Map<String, Object>> imageList = boardService.imageList(map);
		List<Map<String, Object>> commentList = boardService.commentList(map);
		// System.out.println("commentList : " + commentList);

		// [{bthumbnail=1, bno=25, bimage=고래nb.png}]
		// System.out.println("디테일페이지 : " + detailList);
		// {bno=5, bread=0, mnickname=셀라스, commentcount=2, bdate=14:27:46, sno=2,
		// sname=판매요청, btitle=판매요청글씀, bcontent=ㅁㅇㄴㄹ, mno=1}
		model.addAttribute("bdetail", detailList);
		model.addAttribute("imageList", imageList);
		model.addAttribute("comments", commentList);
		// System.out.println(commentList);
		// {bno=5, mnickname=셀라스, cdate=17:21:09, cno=1, ccontent=댓글입니다, clike=0}

		return "boardDetail";
	}

	// 게시글수정 페이지
	@GetMapping("boardEdit")
	public String boardEdit(@RequestParam Map<String, Object> map, Model model) {

		Map<String, Object> detailList = boardService.boardDetail(map);
		List<Map<String, Object>> imageList = boardService.imageList(map);
		// System.out.println(detailList);
		// {bno=107, bread=5, mnickname=pyo, commentcount=0, bdate=14:39:53, sno=2,
		// bimagecount=0, sname=판매요청, btitle=제목, bcontent=내용, mno=96}

		model.addAttribute("bdetail", detailList);
		model.addAttribute("imageList", imageList);

		return "boardedit";
	}

	// 이미지 삭제 로직 (ajax)
	@ResponseBody
	@PostMapping("imgDelete")
	public String imgDelete(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		// System.out.println("지울사진들 map :" + map);
		// 지울사진들 map :{imgDel0=20231031095234num0라이언2.png, bno=68,
		// imgDel1=20231031095234num1라이언2.png}
		int result = boardService.imgDelete(map);
		System.out.println("컨트롤러result : " + result);
		json.put("result", result);

		return json.toString();
	}

	// 게시글수정 로직
	@PostMapping("boardEdit")
	public String boardEdit(@RequestParam(value = "boardimg", required = false) List<MultipartFile> boardimgList,
			@RequestParam Map<String, Object> map) {

		// System.out.println("map : " + map);
		// System.out.println("boardimgList : " + boardimgList);
		// map : {btitle=테스트이미지, bcontent=업로드, bno=68, cate=2, boardimg1=pyos.png,
		// boardimg3=pyos2.png}
		int writeResult = boardService.boardEdit(map);
		if (writeResult == 1) {

			// 파일이 있다면 업로드
			if (boardimgList != null && !boardimgList.isEmpty()) {

				for (int i = 0; i < boardimgList.size(); i++) {

					HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
							.currentRequestAttributes()).getRequest();
					String path = request.getServletContext().getRealPath("/boardImgUpload");
					System.out.println("경로: " + path); // 경로: C:\Users\gogus\git\sellas\src\main\webapp\boardImgUpload

					System.out.println("사진이름 : " + boardimgList.get(i).getOriginalFilename()); // resource-28.jpg
					// System.out.println(boardimgList.get(i).getSize()); //81618
					// System.out.println(boardimgList.get(i).getContentType()); // image/jpeg

					LocalDateTime ldt = LocalDateTime.now();
					String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
					String realFileName = format + "num" + i + boardimgList.get(i).getOriginalFilename();

					// 확장자 자르기
					String[] parts = boardimgList.get(i).getOriginalFilename().split("\\.");
					String lastPart = parts[parts.length - 1];
					System.out.println(lastPart);

					// 확장자 아니면 파일 없애보리기
					if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
							|| lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
						continue;
					}

					File boardimgName = new File(path, realFileName);
					System.out.println(boardimgName);

					try {
						FileCopyUtils.copy(boardimgList.get(i).getBytes(), boardimgName);
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}

					map.put("bimage", realFileName);
					System.out.println("map " + (i + 1) + "번째 : " + map);
					int imgResult = boardService.boardImage(map);
					System.out.println("imgResult " + (i + 1) + " 번째 : " + imgResult);

					if (imgResult == 1 && i == 0) {
						System.out.println("이걸넣을건데 :" + map.get("bimage"));
						int result = boardService.setThumbnail(map);
						System.out.println("제발요: " + result);
					}

				} // for문
				System.out.println("글수정완");
			} // if(!boardimg.isEmpty()
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		} // if(writeResult == 1)
		System.out.println("글쓰기&파일업로드 실패");
		return "redirect:/boardDetail?cate=" + map.get("cate");
	}

	// 게시글삭제 로직
	@GetMapping("boardDelete")
	public String boardDelete(@RequestParam Map<String, Object> map) {
		// System.out.println(map);
		int result = boardService.boardDelete(map);
		// System.out.println(result);
		if (result == 1) {
			return "redirect:/board?cate=" + map.get("cate");
		} else {
			System.out.println("글삭제 실패");
			return "redirect:/board?cate=" + map.get("cate");
		}
	}

	// **************************************** 댓글
	// ****************************************

	// 댓글쓰기
	@PostMapping("commentWrite")
	public String commentWrite(@RequestParam Map<String, Object> map, HttpSession session) {
		System.out.println(map); // {ccontent=adfasdfa, muuid=, cate=2, bno=74}

		if (!util.checkLogin()) {
			return "redirect/login";
		}

		int result = boardService.commentWrite(map);

		if (result == 1) {
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		} else {
			System.out.println("댓글쓰기 실패");
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		}
	}

	// 댓글삭제
	@GetMapping("commentDelete")
	public String commentDelete(@RequestParam Map<String, Object> map) {

		// System.out.println("잡아온값 :" +map);
		// 잡아온값 :{cate=2, bno=5, cno=1}
		int result = boardService.commentDelete(map);
		// System.out.println("결과값 :" + result);

		if (result == 1) {
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		} else {
			System.out.println("댓글삭제 실패");
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		}
	}

	// 댓글수정
	@PostMapping("commentEdit")
	public String commentEdit(@RequestParam Map<String, Object> map) {

		// System.out.println(map);
		// {bno=4, cno=3, cate=2, ccontent=댓글3수정}

		int result = boardService.commentEdit(map);
		System.out.println(result);

		if (result == 1) {
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		} else {
			System.out.println("댓글수정 실패");
			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");
		}
	}

	// 댓글 전체보기 페이지
	@GetMapping("commentDetail")
	public String commentDetail(@RequestParam Map<String, Object> map, Model model) {

		List<Map<String, Object>> commentList = boardService.commentList(map);
		// System.out.println(commentList);
		// [{bno=74, mnickname=pyo, cdate=15:17:23, cno=21, ccontent=, clike=0},
		// {bno=74, mnickname=pyo, cdate=20:08:36, cno=22, ccontent=54545 되나? 또되나?,
		// clike=0}]
		model.addAttribute("comments", commentList);

		return "commentDetail";
	}

	/***************** 테스트용 *****************/
	/*
	 * // 글쓰기 페이지
	 * 
	 * @GetMapping("/boardWriteForTest") public String
	 * boardWriteForTest(@RequestParam(value = "cate", required = false,
	 * defaultValue = "1") int cate, Model model) {
	 * 
	 * if (!util.checkLogin()) { return "redirect/login"; }
	 * 
	 * List<Map<String, Object>> setupboardList = boardService.setupboardList(cate);
	 * model.addAttribute("board", setupboardList);
	 * 
	 * return "boardWriteForTest"; }
	 */

	// 글쓰기 로직
	@PostMapping("/boardWriteForTest")
	public String boardWriteForTest(
			@RequestParam(value = "boardimg", required = false) List<MultipartFile> boardimgList,
			@RequestParam Map<String, Object> map) {

		int imgResultCount = 0;
		System.out.println(map);
		int writeResult = boardService.boardWrite(map);
		System.out.println("null일텐데? : " + boardimgList);
		// {btitle=나눔에 글을 쓰려는데, bcontent=이게 , cate=2, sname=나눔}
		// System.out.println(boardimgList);
		// [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@72ec8d18]
		if (writeResult == 1) {
			System.out.println("bno :" + map.get("bno"));
			// 파일이 있다면 업로드
			if (boardimgList != null && !boardimgList.isEmpty()) {

				for (int i = 0; i < boardimgList.size(); i++) {

					HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
							.currentRequestAttributes()).getRequest();
					String path = request.getServletContext().getRealPath("/boardImgUpload");
					// System.out.println("경로: "+ path); //경로:
					// C:\Users\gogus\git\sellas\src\main\webapp\boardImgUpload

					// System.out.println(boardimgList.get(i).getOriginalFilename());
					// //resource-28.jpg
					// System.out.println(boardimgList.get(i).getSize()); //81618
					// System.out.println(boardimgList.get(i).getContentType()); // image/jpeg

					LocalDateTime ldt = LocalDateTime.now();
					String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
					String realFileName = format + "num" + i + boardimgList.get(i).getOriginalFilename();

					// 확장자 자르기
					String[] parts = boardimgList.get(i).getOriginalFilename().split("\\.");
					String lastPart = parts[parts.length - 1];
					System.out.println(lastPart);

					// 확장자 아니면 파일 없애보리기
					if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
							|| lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
						continue;
					}

					File boardimgName = new File(path, realFileName);
					System.out.println(boardimgName);

					try {
						FileCopyUtils.copy(boardimgList.get(i).getBytes(), boardimgName);
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}

					map.put("bimage", realFileName);
					System.out.println("map " + (i + 1) + "번째 : " + map);
					int imgResult = boardService.boardImage(map);
					System.out.println("imgResult " + (i + 1) + " 번째 : " + imgResult);

					if (imgResult == 1 && i == 0) {
						System.out.println("이걸넣을건데 :" + map.get("bimage"));
						int result = boardService.setThumbnail(map);
						System.out.println("제발요: " + result);
					}

					imgResultCount += imgResult;

				} // for문
				System.out.println("업로드완" + imgResultCount);
			} // if(!boardimg.isEmpty()

			return "redirect:/boardDetail?cate=" + map.get("cate") + "&bno=" + map.get("bno");

		} // if(writeResult == 1)
		System.out.println("글쓰기&파일업로드 실패");
		return "redirect:/boardDetail?cate=" + map.get("cate");
	}

}
