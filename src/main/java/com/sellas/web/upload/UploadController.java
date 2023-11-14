package com.sellas.web.upload;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UploadController {

	@Autowired
	UploadService uploadService;

//모피어스 파일 업로드입니다 -이대원
	@PostMapping("/file/upload2")
	public String comeOnFile2(@RequestParam(value = "file") List<MultipartFile> tradeimg,
			@RequestParam(value = "tno") int tno) {
		System.out.println("나와라 맵의 값!!" + tradeimg + "너도 나와라 tno의 값!! : " + tno);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tno", tno);

		for (int i = 0; i < tradeimg.size(); i++) {

			// 저장할 경로명 뽑기 request뽑기
			HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
					.getRequest();
			String path = req.getServletContext().getRealPath("/tradeImgUpload");
			System.out.println("이미지 오리지널 파일 이름 : " + tradeimg.get(i).getOriginalFilename());

			String[] split = tradeimg.get(i).getOriginalFilename().split("/");

			LocalDateTime ldt = LocalDateTime.now();
			String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
			String realFileName = format + split[split.length - 1];

			// 확장자 자르기
			String[] parts = tradeimg.get(i).getOriginalFilename().split("\\.");
			String lastPart = parts[parts.length - 1];
			System.out.println(lastPart);

			// 확장자 아니면 파일 없애보리기

			if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg") || lastPart.equals("bmp")
					|| lastPart.equals("gif") || lastPart.equals("jpe"))) {
				continue;
			}

			File newFileName = new File(path, realFileName);

			// 진짜 이름을 맵에 넣기
			map.put("realFileName", realFileName);

			try {
				FileCopyUtils.copy(tradeimg.get(i).getBytes(), newFileName);

				int insertTradeimgResult = uploadService.insertTradeimg(map);

				if (insertTradeimgResult == 1 && i == 0) {
					int Thumbnail = uploadService.countThumbnail(map);
					if (Thumbnail == 0) {
						uploadService.setThumbnail(realFileName);
					}
				}

			} catch (IOException e) {
				e.printStackTrace();
			}

		} // for문의 끝

		return "";
	}
}
