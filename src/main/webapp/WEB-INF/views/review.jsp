<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>Shop Homepage - Start Bootstrap Template</title>
<!-- Favicon-->
<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
<!-- Bootstrap icons-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"
	rel="stylesheet" />
<!-- Core theme CSS (includes Bootstrap)-->
<link href="css/styles.css" rel="stylesheet" />

<!-- ******************* 추가 *********************** -->
<link rel="stylesheet"
	href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link rel="stylesheet" href="../css/review.css">
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
        	

            // 선택한 값을 저장할 변수
            let ratePromiseValue = null;
            let rateResponseValue = null;
            let rateMannerValue = null;

            // ratePromise 라디오 버튼이 선택됐을 때
            $('#ratePromise input[type=radio]').on('change', function() {
        	ratePromiseValue = $(this).val(); // 선택한 값을 변수에 저장
           alert(ratePromiseValue);
           // 모든 라벨의 색상을 기본색으로 변경
           $('#ratePromise label').css('color', 'transparent');
           // 선택된 라벨의 색상을 파란색으로 변경
           $(this).next('label').css('color', 'blue');
           
           
           $('.explain-text1').css('color', 'gray');
           if (ratePromiseValue == 0) {
               $('.explain3').css('color', '#496f94');
           } else if  (ratePromiseValue == 3) {
           $('.explain2').css('color', '#1a72ff ');
           } else if (ratePromiseValue == 5) {
           $('.explain1').css('color', '#ff6289');
           }
  
       });
            
            // rateResponse 라디오 버튼이 선택됐을 때
            $('#rateResponse input[type=radio]').on('change', function() {
                rateResponseValue = $(this).val(); // 선택한 값을 변수에 저장
                alert(rateResponseValue);
                $('#rateResponse label').css('color', 'transparent');
                $(this).next('label').css('color', 'blue');
                
                $('.explain-text2').css('color', 'gray');
                if (rateResponseValue == 0) {
                    $('.explain6').css('color', '#496f94');
                } else if  (rateResponseValue == 3) {
                $('.explain5').css('color', '#1a72ff ');
                } else if (rateResponseValue == 5) {
                $('.explain4').css('color', '#ff6289');
                }
                
            });
            
            
            // rateManner 라디오 버튼이 선택됐을 때
            $('#rateManner input[type=radio]').on('change', function() {
                rateMannerValue = $(this).val(); // 선택한 값을 변수에 저장
                alert(rateMannerValue);
                $('#rateManner label').css('color', 'transparent');
                $(this).next('label').css('color', 'blue');
           
                
                $('.explain-text3').css('color', 'gray');
                if (rateMannerValue == 0) {
                    $('.explain9').css('color', '#496f94');
                } else if  (rateMannerValue == 3) {
                $('.explain8').css('color', '#1a72ff ');
                } else if (rateMannerValue == 5) {
                $('.explain7').css('color', '#ff6289');
                }
            
            
            });
                
         
            
            
            
            $('.reviewSubmit').click(function() {
                let isValid = true; // 유효성 검사를 위한 변수

                // 각 질문에 대해 확인
                $('.question').each(function() {
                    let checkBtn = $(this).find('input[type="radio"]:checked');

                    // 선택된 라디오 버튼이 없거나 2개 이상이면
                    if (checkBtn.length !== 1) {
                        alert("평가하지 않은 문항이 있어요.");
                        isValid = false; // 유효성 검사 실패
                        return false; // 각각의 질문에서 나가기
                    }
                });
                if (isValid) {
                    // 평가하지 않은 문항이 없으면 폼 서브밋
                    $('#review').submit();
                }
            });
            
        });
        
        
    </script>
</head>

</head>
<body>
	<!-- Navigation-->
   <%@ include file="menubar.jsp" %>
	<!-- Header-->
	<header> </header>
	<!-- Section-->
	<section class="py-5">
		<div class="container px-4 px-lg-5 mt-5" style="z-index: 10">
			<div class="row justify-content-center">
				<form class="mb-3" name="review" id="review" method="post">
				    <input type="hidden" name="pno" value="${reviewMember.pno}" />
    <input type="hidden" name="pseller" value="${reviewMember.pseller}" />
    <input type="hidden" name="pbuyer" value="${reviewMember.pbuyer}" />
					<div class="question">약속 시간은 잘 지켰나요?
					<fieldset id="ratePromise">
						<input type="radio" name="reviewStar1" value="5" id="rate1"><label for="rate1">🐳</label>
							<input type="radio" name="reviewStar1" value="3" id="rate2"><label for="rate2">🐋</label>
							<input type="radio" name="reviewStar1" value="0" id="rate3"><label for="rate3">🐟</label>
							<div class="explain-div">
							<div class="explain1 explain-text1">!최고예요</div>
							<div class="explain2 explain-text1">좋아요</div>
							<div class="explain3 explain-text1">별로에요</div>
							</div>
					</fieldset>
					</div>

					<div class="question">응답은 빨랐나요?
					<fieldset id="rateResponse">
						<input type="radio" name="reviewStar2" value="5" id="rate6"><label for="rate6">🐳</label>
						<input type="radio" name="reviewStar2" value="3" id="rate7"><label for="rate7">🐋</label>
						<input type="radio" name="reviewStar2" value="0" id="rate8"><label for="rate8">🐟</label>
								<div class="explain-div">
							<div class="explain4 explain-text2">!최고예요</div>
							<div class="explain5 explain-text2">좋아요</div>
							<div class="explain6 explain-text2">별로에요</div>
							</div>
					
					</fieldset>
					</div>

					<div class="question">친절하고 매너가 좋았나요?
					<fieldset id="rateManner">
						<input type="radio" name="reviewStar3" value="5" id="rate11"><label for="rate11">🐳</label>
						<input type="radio" name="reviewStar3" value="3" id="rate12"><label for="rate12">🐋</label>
						<input type="radio" name="reviewStar3" value="0" id="rate13"><label for="rate13">🐟</label>
								<div class="explain-div">
							<div class="explain7 explain-text3">!최고예요</div>
							<div class="explain8 explain-text3">좋아요</div>
							<div class="explain9 explain-text3">별로에요</div>
							</div>
					</fieldset>
					</div>
		
					<div>

						<div class="writeReview">따듯한 후기를 남겨주세요.(선택사항)</div>
						<textarea style="height:140px;" class="col-auto form-control"  name="rcontent" id="reviewContents" placeholder="후기는 상대방 프로필에 보입니다."></textarea>
					</div>
					<button type="button" class="reviewSubmit">후기보내기</button>
				</form>

			</div>
		</div>

	</section>
	<!-- Footer-->
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/scripts.js">
		
	</script>
</body>
</html>
