<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Shop Homepage - Start Bootstrap Template</title>
        <script src="https://js.bootpay.co.kr/bootpay-4.3.3.min.js"
	type="application/javascript"></script>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        
        <!-- ******************* 추가 *********************** -->
        <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
        <script src="./js/jquery-3.7.0.min.js"></script>
    </head>
    <body>
	<!-- Navigation-->
	<nav class="navbar navbar-expand-lg navbar-light bg-light"
		style="z-index: 10">
		<div class="container px-4 px-lg-5">
			<a class="navbar-brand" href="">SellAS</a>
            <button class="navbar-toggler" type="button" data-bs-target="" aria-controls="navbarSupportedContent"><img src="../img/menuIcon.png" id="menuIcon" alt="menuIcon"></button>
		</div>
	</nav>
	<!-- Header-->
        <header>

        </header>
        <!-- Section-->
        <section class="py-5">
        
            <div class="container px-4 px-lg-5 mt-5 tradecontainter" style="z-index: 10" id="productContainer">
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
                    
                  	<script type="text/javascript">
                  	let mnickname = "${sessionScope.mnickname}";
                  	
                  	
		try {
			(async ()=> {
			
			const response = await Bootpay.requestPayment({
				"application_id" : "652b7e1400c78a001b21b5df",
				"price" : ${bootpayDetail.money},
				"order_name" : "웨일 페이",
				"order_id" : "Whale_Pay_TEST",
				"pg" : "",
				"method" : "카드",
				"tax_free" : 0,
				"user" : {
					"id" : "회원아이디",
					"username" : "회원이름",
					"phone" : "01000000000",
					"email" : "test@test.com"
				},
				"items" : [ {
					"id" : "item_id",
					"name" : "테스트아이템",
					"qty" : 1,
					"price" : ${bootpayDetail.money}
				} ],
				"extra" : {
					"open_type" : "iframe",
					"card_quota" : "0,2,3",
					"escrow" : false
				}
				
			})
			
			switch (response.event) {
			case 'issued':
				// 가상계좌 입금 완료 처리
				break
			case 'done':
				console.log(response)
				// 결제 완료 처리
				
				
                  	let money = ${bootpayDetail.money};
				
				
				const jsonData = JSON.stringify(response.data);
				const form = document.createElement('form');
				form.method = 'POST'; // 또는 'GET', HTTP 메서드 선택
				form.action = './payOK'; // 이동하고자 하는 페이지 URL로 설정

				// 값을 추가하고 폼에 추가
				const input = document.createElement('input');
				input.type = 'hidden';
				input.name = 'payData'; // 파라미터 이름
				input.value = jsonData; // 파라미터 값
				
				form.appendChild(input);
				
				
				
				const inputMoney = document.createElement('input');
				inputMoney.type = 'hidden';
				inputMoney.name = 'money'; // 파라미터 이름
				inputMoney.value = money; // 파라미터 값
				
				form.appendChild(inputMoney);
				
				const inputMnickname = document.createElement('input');
				inputMnickname.type = 'hidden';
				inputMnickname.name = 'mnickname'; // 파라미터 이름
				inputMnickname.value = mnickname; // 파라미터 값
				
				
				form.appendChild(inputMnickname);

				alert("결제가 완료되었습니다.");
				
				// 폼을 문서에 추가하고 자동으로 제출
				document.body.appendChild(form);
				
				form.submit();

				
				
				
				
				break
			case 'confirm': //payload.extra.separately_confirmed = true; 일 경우 승인 전 해당 이벤트가 호출됨
				console.log(response.receipt_id)
				/**
				 * 1. 클라이언트 승인을 하고자 할때
				 * // validationQuantityFromServer(); //예시) 재고확인과 같은 내부 로직을 처리하기 한다.
				 */
				const confirmedData = Bootpay.confirm() //결제를 승인한다
				if (confirmedData.event === 'done') {
					//결제 성공
				} else {
				    // 결제 승인이 실패한 경우
				    console.log("결제 승인 실패: " + confirmedData.event);
				    // 여기에 실패 시 수행할 작업을 추가할 수 있습니다.
				}

				/**
				 * 2. 서버 승인을 하고자 할때
				 * // requestServerConfirm(); //예시) 서버 승인을 할 수 있도록  API를 호출한다. 서버에서는 재고확인과 로직 검증 후 서버승인을 요청한다.
				 * Bootpay.destroy(); //결제창을 닫는다.
				 */
				break
			}
			})();
		} catch (e) {
			// 결제 진행중 오류 발생
			// e.error_code - 부트페이 오류 코드
			// e.pg_error_code - PG 오류 코드
			// e.message - 오류 내용
			
			location.href='/';	
			console.log("오류발생!!!!!!!!!!!!!!!");
			switch (e.event) {
			case 'cancel':
				// 사용자가 결제창을 닫을때 호출
				console.log("오류발생2!!!!!!!!!!!!!!");
				break
			case 'error':
				// 결제 승인 중 오류 발생시 호출
				console.log("오류발생3!!!!!!!!!!!!!");
				break
			}
		}
		
	</script>
                    
                   
                   
                   
                </div>
            </div>
            
        </section>
        <!-- Footer-->
        <footer id="footer">
            <div class="container">
	            <ul class="menubar">
	            	<li onclick="location.href='./'"><i class="xi-home xi-2x"></i><div id="menu">홈</div></li>
	            	<li><i class="xi-message xi-2x"></i><div id="menu">채팅</div></li>
	            	<li><i class="xi-profile xi-2x"></i><div id="menu">마이페이지</div></li>
	            </ul>
            </div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
    </body>
</html>
