package com.sellas.web.myPage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sellas.web.util.Util;



@Controller
public class MyPageController {

   @Autowired
   MyPageService myPageService;
   
   @Autowired
   private Util util;

   @GetMapping("/mypage")
   public String myPage(Model model, HttpSession session) {

      
     
      String uuid = "ade965df-0d77-4e5f-9fec-c33c9f921588";
      session.setAttribute("muuid", uuid);
      
      //세션에 저장된 uuid를 가지고 멤버조회
      Map<String, Object> member = myPageService.memberInfo(uuid);
      
       model.addAttribute("nickname", session.getAttribute("mnickname"));
       model.addAttribute("exp", member.get("mpoint"));
       model.addAttribute("mbalance", member.get("mbalance"));
       model.addAttribute("mphoto", member.get("mphoto"));
       
       
      return "mypage";
   }
   
   

   //TODO 화면부분
   @GetMapping("/profile")
   public String profile(Model model, HttpSession session) {
      
	   String uuid = "ade965df-0d77-4e5f-9fec-c33c9f921588";
	      session.setAttribute("muuid", uuid);
      
      
      
      //세션에 저장된 uuid를 가지고 멤버조회
      Map<String, Object> member = myPageService.memberInfo(uuid);
      
      //거래후기불러오기
      List<Map<String, Object>> profileReview = myPageService.getprofileReview(session.getAttribute("muuid"));
      
       model.addAttribute("nickname", session.getAttribute("mnickname"));
       model.addAttribute("exp", member.get("mpoint"));
       model.addAttribute("mphoto", member.get("mphoto"));
       model.addAttribute("profileReview" , profileReview );

      return "profile";
   }
   
   
   //다른회원정보보기
   @GetMapping("/profileMember")
   public String profileMember(@RequestParam("muuid") String uuid, Model model, HttpSession session) {
      
      
      //세션에 있는 uuid와 같다면
      if(uuid == session.getAttribute("muuid")) {
         return "profile";
      }
      
      //멤버불러오기
      Map<String, Object> member = myPageService.memberInfo(uuid);
      model.addAttribute("nickname", member.get("mnickname"));
      model.addAttribute("exp", member.get("mpoint"));
      model.addAttribute("mphoto", member.get("mphoto"));
      
      //TODO 판매내역띄우기
      
      //거래후기
      List<Map<String, Object>> profileReview = myPageService.getprofileReview(uuid);
       model.addAttribute("profileReview" , profileReview );
      
      
      return "profileMember";
   }
   
   
   //TODO 사진부분 추가
   //프로필수정(닉네임/사진)
      @GetMapping("/profileEdit/{muuid}")
      public String profileEdit(@PathVariable("muuid") String uuid, Model model, HttpSession session) {
         
         Map<String, Object> member = myPageService.memberInfo(uuid);
         model.addAttribute("nickname", member.get("mnickname"));
         model.addAttribute("mphoto", member.get("mphoto"));
         model.addAttribute("mname", member.get("mname"));
         
         return "profileEdit";
      }
      
      
      
   /**
    * 조원 이대원의 코드를 가져와서 수정함
    * @param mphotoList
    * @param uuid
    * @return
    */
      //업로드된 사진을 저장 및 디비에 저장
      @PostMapping("/profileEdit/photoModify")
      public String photoModify(@RequestParam(value = "file") List<MultipartFile> mphotoList,
            @RequestParam(value="uuid") String uuid){
      
         //0번째 배열에 있는 이미지만 담는다.
         MultipartFile mphoto = mphotoList.stream().findFirst().orElse(null);
         
         //사용자정보와 이미지경로를 담는다.
         Map<String, Object> memberphoto = new HashMap<String, Object>();
         
         memberphoto.put("uuid", uuid);
         memberphoto.put("mphoto", mphoto);
         
         int result = myPageService.photoModify(memberphoto);
         
         if (result != 1) {
            System.out.println("사진 업로드 실패");
         }
         
      return "";
      }
      
   
      /**
       * 사용자가 변경버튼 누를시
       * @param uuid
       * @return json
       */
      @ResponseBody
      @PostMapping("/profileEdit/photoModifySubmit")
      public String photoModifySubmit(@RequestParam("uuid") String uuid) {
         
         int result = myPageService.photoModifySubmit(uuid);
         JSONObject json = new JSONObject();
      if(result ==1) {
         json.put("result", 1);
         json.put("uuid", uuid);
      }
         return json.toString();
      }
      
   
   /**
    * 닉네임 중복검사
    * @param newNickname
    * @return
    */
    @PostMapping("/profileEdit/isNicknameExists")
    @ResponseBody
    public int isNicknameExists(@RequestParam("newNickname") String newNickname) {
   int result = myPageService.isNicknameExists(newNickname);
   
       return result;
    }
   

    @PostMapping("/profileEdit/nicknameModify")
    @ResponseBody
    public int mypageModify(@RequestParam Map<String, Object> map, HttpSession session) {
    
       map.put("uuid",session.getAttribute("muuid"));
       int result = myPageService.nicknameModify(map);
       
       //닉네임 변경 성공시 세션에 새닉네임 넣어줌
       if(result == 1) {
          session.setAttribute("mnickname",map.get("newNickname"));
          
       }
       

      return result;
    }
   
    /**
     * 거래후기불러오기
     * @param pno
     * @param model
     * @param session
     * @return
     */

   //거래후기글쓰기
   @GetMapping("review")
   public String review(@RequestParam("tno") String tno, Model model, HttpSession session) {
      
	   String uuid = "ade965df-0d77-4e5f-9fec-c33c9f921588";
	      session.setAttribute("muuid", uuid);
      
      // 구매자,판매자확인
      ReviewDTO reviewMember = myPageService.findId(tno);
       session.setAttribute("reviewMember", reviewMember);
      // 구매정보불러와서 화면전환
      // 후기쓰는 자가 판매자인 경우
      if (reviewMember.getPseller() == session.getAttribute("muuid")) {
         model.addAttribute("type", "seller");
         model.addAttribute("reviewMember",reviewMember);
         return "review";
      }
      model.addAttribute("type", "buyer");
      model.addAttribute("reviewMember",reviewMember);
      return "review";

   }
   
   
   /**
    * 
    * @param reviewDTO
    * @param bindingResult
    * @param session
    * @param model
    * @return
    */
   //후기작성등록
   @PostMapping("review")
   public String review(@Valid ReviewDTO reviewDTO, BindingResult bindingResult, HttpSession session, Model model) {
      Map<String, String> errorMsg = new HashMap<>();
       if(bindingResult.hasErrors()) {
           
            List<FieldError> errorlist = bindingResult.getFieldErrors();
           
           for(int i=0; i<errorlist.size(); i++) {
               String field = errorlist.get(i).getField();
               String message = errorlist.get(i).getDefaultMessage();
               
               
               //서버확인용으로 남겨두겠습니다.
               System.out.println("필드 = " + field);
               System.out.println("메세지 = " + message);
               
               errorMsg.put(field, message);
           }
           
           // 모델에 errorMsg를 추가
           model.addAttribute("errorMsg", errorMsg);
           return "review";
       }

       
      int result = myPageService.inputReview(reviewDTO, session);
      if (result == 1) {
         session.removeAttribute("reviewMember");
         return "redirect:/mypage";
         
      } else {
         String error = "오류가 발생했습니다.";
         session.removeAttribute("reviewMember");
            model.addAttribute("error", error);
         return "redirect:/mypage";
      }
   }
   
   
   //내가 받은 후기상세페이지
   @GetMapping("reviewDetail")
   public String reviewDetail(@RequestParam int rno, Model model, HttpSession session) {

      Map<String, Object> map = new HashMap<>();
      map.put("rno", rno);
      map.put("uuid", session.getAttribute("muuid"));
      
      Map<String, Object> reviewDetail = myPageService.reviewDetail(map);
      model.addAttribute("reviewDetail", reviewDetail);
   
      return "reviewDetail";
      
   }
   
   /**
    * 내가 보낸 리뷰 확인
    * @param rno
    * @param model
    * @param session
    * @return
    */
   
   //내가 보낸 후기상세페이지
   @GetMapping("reviewDetailByMe")
   public String reviewDetailByMe(@RequestParam int rno, Model model, HttpSession session) {

      Map<String, Object> map = new HashMap<>();
      map.put("rno", rno);
      map.put("uuid", session.getAttribute("muuid"));
      
      Map<String, Object> reviewDetail = myPageService.reviewDetailByMe(map);
      model.addAttribute("reviewDetail", reviewDetail);
      
      
      return "reviewDetail";
   }
   
   /**
    * 
    * @param model
    * @param session
    * @return 
    */

   //판매내역
   @GetMapping("getsell")
   public String getSell(Model model, HttpSession session) {
      
      String uuid = String.valueOf(session.getAttribute("muuid"));
      //판매내역불러오기
      List<Map<String, Object>> sellList = myPageService.getSell(uuid);
      model.addAttribute("sellList",sellList);
      
      return "sellList";
      
   }
   
   

   
   //구매내역
   @GetMapping("getbuy")
   public String getBuy(Model model, HttpSession session) {
      
      String uuid = String.valueOf(session.getAttribute("muuid"));
      
      
      //구매진짜한것만 담겨있음 완료끝낸것만
      List<Map<String, Object>> buyList = myPageService.getBuy(uuid);
      model.addAttribute("buyList",buyList);
      
      return "buyList";
      
   }
   
   //경매내역
   @GetMapping("getauction")
   public String getAuction(Model model, HttpSession session) {
      
      String uuid = String.valueOf(session.getAttribute("muuid"));
   
      //판매내역
      List<Map<String, Object>> aucSellList = myPageService.getAucSell(uuid);
      model.addAttribute("aucSellList",aucSellList);
      
      //구매내역
      List<Map<String, Object>> aucBuyList = myPageService.getAucBuy(uuid);
      model.addAttribute("aucBuyList", aucBuyList);
      
      return "auctionList";
      
   }
   
   
   
   
   
   
   //위시리스트 불러오기
   @GetMapping("getwish")
   public String wishList(Model model, HttpSession session) {
      
      
      if(!util.checkLogin()) {
         return "redirect/login";
      }
      
      String uuid = String.valueOf(session.getAttribute("muuid"));
      List<Map<String, Object>> wishList = myPageService.getWish(uuid);
      
      model.addAttribute("wishList",wishList);
      return "wishList";
   
   }
   
   
   
   
   
   //찜하기(위시리스트) 추가하기
   @ResponseBody
   @PostMapping("addWish")
   public String addWish(@RequestParam("tno") int tno, Model model, HttpSession session) {
      
      Map<String, Object> map = new HashMap<>();
      map.put("tno", tno);
      map.put("muuid", session.getAttribute("muuid"));
      
      int addWish = myPageService.addWish(map);
      
      JSONObject json = new JSONObject();
      json.put("addWish", addWish);
      System.out.println("제이슨 값입니다 : " + json.toString());
      return json.toString();
   
   }
   
   /**
    * 
    * @param tno
    * @param model
    * @param session
    * @return json
    */
   //찜하기 삭제하기
   @ResponseBody
   @PostMapping("delWish")
   public String delWish(@RequestParam("tno") int tno, Model model, HttpSession session) {
      
      Map<String, Object> map = new HashMap<>();
      map.put("tno", tno);
      map.put("muuid", session.getAttribute("muuid"));
      
      int delWish = myPageService.delWish(map);
      
      JSONObject json = new JSONObject();
      json.put("delWish", delWish);
      System.out.println("삭제의 제이슨 값입니다 : " + json.toString());
      return json.toString();
   
   }
   
   
   
   //내활동내역보기
   @GetMapping("myActivities")
   public String myActivities(Model model, HttpSession session ) {
      
      if(!util.checkLogin()) {
         return "redirect/login";
      }
      

      String nickname = "SELLAS1";
      //내글보기

      
      List<Map<String, Object>> myPost = myPageService.getMyPost(nickname);
      //내댓글보기
      
      List<Map<String, Object>> myComment = myPageService.getMyComment(nickname);
      
      model.addAttribute("myPost", myPost);
      model.addAttribute("myComment",myComment);
      
      return"myActivities";
      
      
   }
   
   
   
   
   
   
   


}