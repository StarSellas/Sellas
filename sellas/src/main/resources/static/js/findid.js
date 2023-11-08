
let emailCodeChecked = false;

/* 아이디 찾기 */
function findid(filtering) {
	
	let emailAddress = document.getElementById("email").value;
	
	if(emailAddress == ""){
		setMessage("emailMessage", "이메일 주소를 입력하세요.", false);
	} else {
		
	$.ajax({
		url : "/findid",
		method : "post",
		data : {email : emailAddress, filtering : filtering},
		success : function(result){
			if(filtering){
				if(result != ""){
					document.getElementById("filteredid").textContent = result;
					showPage("page2");
				} else {
					setMessage("emailMessage", "가입된 아이디가 없습니다.", false);
				}
			} else {
				document.getElementById("unfilteredid").textContent = result;
				showPage("page3");
			}
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
	
	}
}

/* 이메일 인증 시작 */
function showEmailCodeDiv() {
	document.getElementById("startEmailVerificationButton").style.visibility = "hidden";
	document.getElementById("ExtraDiv").style.visibility = "hidden";
	document.getElementById("emailCodeDiv").style.visibility = "visible";
	sendVerificationCode();
}

/* 인증번호 발신 */
function sendVerificationCode() {

	if(!emailCodeChecked){
	// 이메일 인증이 완료되지 않은 경우에만 실행
	let emailAddress = document.getElementById("email").value;
	
	$.ajax({
		url : "/sendVerificationCode",
		method : "post",
		data : {email : emailAddress},
		success : function(result){
			//alert(result);
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
	
	}
}

/* 인증번호 확인 */
function validateEmailCode() {
	
	let code = document.getElementById("emailCode").value;
	
	$.ajax({
		url : "/checkVerificationCode",
		method : "post",
		data : {code : code},
		success : function(result){
			//alert(result);
			if(result){
				emailCodeChecked = true;
				findid(false);
			} else {
				emailCodeChecked = false;
			}
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

/* 이메일 인증 후 비밀번호 찾기 요청할 경우 비밀번호 변경 */
let pwInputChecked = false;
let pwcheckInputChecked = false;

document.getElementById("pw").addEventListener("keyup", validateOnKeyUp);
document.getElementById("pwcheck").addEventListener("keyup", validateOnKeyUp);

function validateOnKeyUp(event) {
	
	let inputField = event.target;		// Keyup 이벤트가 발생한 필드
	let inputValue = inputField.value;	// 필드에 입력된 값
	let fieldId = inputField.id;		// 필드 id
	let msgDiv = fieldId + "Message";	// 필드 message div
	//alert(inputField + "/" + fieldId + " : " + inputValue);
	
	switch(fieldId){
		case "pw":
		
			let uppercaseRegex = /[A-Z]/g;
			let numberRegex = /[0-9]/g;
			let specialCharRegex = /[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]/g;

			let hasUppercase = uppercaseRegex.test(inputValue);
			let hasNumber = numberRegex.test(inputValue);
			let hasSpecialChar = specialCharRegex.test(inputValue);
			
			if(!(hasUppercase && hasNumber && hasSpecialChar)){
				pwInputChecked = false;
				// 비밀번호는 영문 대문자, 숫자, 특수문자를 모두 포함해야 합니다.
				let msg = "비밀번호는 영문 대문자, 숫자, 특수문자를 모두 포함해야 합니다.";
				setMessage(msgDiv, msg, false);
			} else {
				if(inputValue.length < 8){
					pwInputChecked = false;
					// 비밀번호는 8글자 이상이어야 합니다.
					let msg = "비밀번호는 8글자 이상이어야 합니다.";
					setMessage(msgDiv, msg, false);
				} else{
					pwInputChecked = true;
					// pw OK
					clearMessage(msgDiv);
				}
			}
			
			let pwcheck = document.getElementById("pwcheck").value;
			
			if(pwcheck.length > 0){
				if(inputValue != pwcheck){
					pwcheckInputChecked = false;
					// 비밀번호가 일치하지 않습니다.
					let msg = "비밀번호가 일치하지 않습니다.";
					setMessage("pwcheckMessage", msg, false);
				} else {
					pwcheckInputChecked = true;
					// pwcheck OK
					clearMessage("pwcheckMessage");
				}
			}
			
			break;
			
		case "pwcheck":
			
			let password = document.getElementById("pw").value;
			
			if(inputValue != password) {
				pwcheckInputChecked = false;
				// 비밀번호가 일치하지 않습니다.
				let msg = "비밀번호가 일치하지 않습니다.";
				setMessage(msgDiv, msg, false);
			} else {
				pwcheckInputChecked = true;
				// pwcheck OK
				clearMessage(msgDiv);
			}
			break;
			
	}
	controllButton();
}

function changePassword() {
	
	let id = document.getElementById("unfilteredid").textContent;
	let emailAddress = document.getElementById("email").value;
	let password = document.getElementById("pw").value;
	
	$.ajax({
		url : "/changePassword",
		method : "post",
		data : {email : emailAddress, id : id, pw : password},
		success : function(result){
			if(result){
				showPage("page5");
			}
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

/* Message 출력 */
function setMessage(msgDiv, message, isOK) {
	
	let messageDiv = document.getElementById(msgDiv);
	
	messageDiv.textContent = message;
	
	if(isOK){
		messageDiv.style.color = 'green';
	} else {
		messageDiv.style.color = 'red';
	}
}

/* Message 삭제 */
function clearMessage(msgDiv) {
	
	let messageDiv = document.getElementById(msgDiv);
	
	messageDiv.textContent = "　";
}

/* 버튼 상태 변경 */
function controllButton() {
	
	if(pwInputChecked && pwcheckInputChecked){
		document.getElementById("changePasswordButton").removeAttribute("disabled");
	}
}

/* 아이디 찾기 페이징 */
function showPage(pageId) {

	let pages = document.querySelectorAll(".page");
	for (let i = 0; i < pages.length; i++) {
		pages[i].style.display = "none";
	}
	document.getElementById(pageId).style.display = "block";
}