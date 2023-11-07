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
       });
            
            // rateResponse 라디오 버튼이 선택됐을 때
            $('#rateResponse input[type=radio]').on('change', function() {
                rateResponseValue = $(this).val(); // 선택한 값을 변수에 저장
                alert(rateResponseValue);
                $('#rateResponse label').css('color', 'transparent');
                $(this).next('label').css('color', 'blue');
            });
            
            
            // rateManner 라디오 버튼이 선택됐을 때
            $('#rateManner input[type=radio]').on('change', function() {
                rateMannerValue = $(this).val(); // 선택한 값을 변수에 저장
                alert(rateMannerValue);
                $('#rateManner label').css('color', 'transparent');
                $(this).next('label').css('color', 'blue');
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
	<nav class="navbar navbar-expand-lg navbar-light bg-light"
		style="z-index: 10">
		<div class="container px-4 px-lg-5">
			<a class="navbar-brand" href="#!">SellAS</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="#!">Home</a></li>
					<li class="nav-item"><a class="nav-link" href="#!">About</a></li>
					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
						role="button" data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="#!">All Products</a></li>
							<li><hr class="dropdown-divider" /></li>
							<li><a class="dropdown-item" href="#!">Popular Items</a></li>
							<li><a class="dropdown-item" href="#!">New Arrivals</a></li>
						</ul></li>
				</ul>
				<form class="d-flex">
					<button class="btn btn-outline-dark" type="submit">
						<i class="bi-cart-fill me-1"></i> Cart <span
							class="badge bg-dark text-white ms-1 rounded-pill">0</span>
					</button>
				</form>
			</div>
		</div>
	</nav>
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
							<input type="radio" name="reviewStar1" value="3" id="rate2"><label for="rate2">🐳</label>
							<input type="radio" name="reviewStar1" value="0" id="rate3"><label for="rate3">🐳</label>
					</fieldset>
					</div>

					<div class="question">응답은 빨랐나요?
					<fieldset id="rateResponse">
						<input type="radio" name="reviewStar2" value="5" id="rate6"><label for="rate6">🐳</label>
						<input type="radio" name="reviewStar2" value="3" id="rate7"><label for="rate7">🐳</label>
						<input type="radio" name="reviewStar2" value="0" id="rate8"><label for="rate8">🐳</label>
					</fieldset>
					</div>
					<br>

					<div class="question">친절하고 매너가 좋았나요?
					<fieldset id="rateManner">
						<input type="radio" name="reviewStar3" value="5" id="rate11"><label for="rate11">🐳</label>
						<input type="radio" name="reviewStar3" value="3" id="rate12"><label for="rate12">🐳</label>
						<input type="radio" name="reviewStar3" value="0" id="rate13"><label for="rate13">🐳</label>
					</fieldset>
					</div>
					<br>
					
					<div>

						<div class="writeReview">따듯한 후기를 남겨주세요.(선택사항)</div>
						<textarea class="col-auto form-control"  name="rcontent" id="reviewContents" placeholder="후기는 상대방 프로필에 보입니다."></textarea>
					</div>
					<button type="button" class="reviewSubmit">후기보내기</button>
				</form>

			</div>
		</div>

	</section>
	<!-- Footer-->
        <footer id="footer">
            <div class="container">
	            <ul class="menubar">
	            	<li><i class="xi-home xi-2x"></i><div id="menu">홈</div></li>
	            	<li><i class="xi-message xi-2x"></i><div id="menu">채팅</div></li>
	            	<li><i class="xi-profile xi-2x"></i><div id="menu">마이페이지</div></li>
	            </ul>
            </div>
        </footer>
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="js/scripts.js">
		
	</script>
</body>
</html>
