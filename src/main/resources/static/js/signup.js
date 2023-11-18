
/* 입력값 유효성 검사 확인 */
let idInputChecked = false;				// 아이디
let nickInputChecked = false;			// 닉네임
let pwInputChecked = false;				// 비밀번호
let pwcheckInputChecked = false;		// 비밀번호 일치 여부
let emailInputChecked = false;			// 이메일 주소
let phoneInputChecked = false;			// 휴대전화 번호

/* 중복 검사 확인 */
let idDuplicationChecked = false;		// 아이디
let nickDuplicationChecked = false;		// 닉네임
let emailDuplicationChecked = false;	// 이메일 주소
let phoneDuplicationChecked = false;	// 휴대전화 번호

let emailCodeChecked = false;


/* Keyup 이벤트 발생 시 입력값 유효성 검사 */
document.getElementById("id").addEventListener("keyup", validateOnKeyUp);
document.getElementById("nickname").addEventListener("keyup", validateOnKeyUp);
document.getElementById("pw").addEventListener("keyup", validateOnKeyUp);
document.getElementById("pwcheck").addEventListener("keyup", validateOnKeyUp);
document.getElementById("email").addEventListener("keyup", validateOnKeyUp);
document.getElementById("phone").addEventListener("keyup", validateOnKeyUp);

function validateOnKeyUp(event)	{
	
	let inputField = event.target;		// Keyup 이벤트가 발생한 필드
	let inputValue = inputField.value;	// 필드에 입력된 값
	let fieldId = inputField.id;		// 필드 id
	let msgDiv = fieldId + "Message";	// 필드 message div
	//alert(inputField + "/" + fieldId + " : " + inputValue);
		
	switch(fieldId){
		
		case "id":
			
			let filteredId = inputValue.replace(/[^a-z0-9]/g, '');
			
			if(inputValue != filteredId){
				inputValue = inputField.value = filteredId;
				// 아이디에는 영문 소문자와 숫자만 사용할 수 있습니다.
				//let msg = "아이디에는 영문 소문자와 숫자만 사용할 수 있습니다.";
				//setMessage(msgDiv, msg, false);
			} else {
				if(inputValue.length < 4){
					idInputChecked = false;
					// 아이디는 4글자 이상이어야 합니다.
					let msg = "아이디는 4글자 이상이어야 합니다.";
					setMessage(msgDiv, msg, false);
				} else {
					idInputChecked = true;
					// id OK
					clearMessage(msgDiv);
				}
			}
			break;
			
		case "nickname":
		
			let filteredNick = inputValue.replace(/[^A-Za-zㄱ-힣0-9]+/g, '');
			
			if(inputValue != filteredNick){
				inputValue = inputField.value = filteredNick;
				// 닉네임에는 한글, 영문자, 숫자만 사용할 수 있습니다.
				//let msg = "닉네임에는 한글, 영문자, 숫자만 사용할 수 있습니다.";
				//setMessage(msgDiv, msg, false);
			} else {
				if(inputValue.length < 2){
					nickInputChecked = false;
					// 닉네임은 2글자 이상이어야 합니다.
					let msg = "닉네임은 2글자 이상이어야 합니다.";
					setMessage(msgDiv, msg, false);
				} else {
					nickInputChecked = true;
					// nick OK
					clearMessage(msgDiv);
				}
			}
			break;
			
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
				
				// 비밀번호 암호화
				document.getElementById("encryptPassword").value = encryptPassword(password);
			}
			break;
			
		case "phone":
		
			let filteredPhone = inputValue.replace(/[^0-9]/g, '');
			
			if(inputValue != filteredPhone){
				inputValue = inputField.value = filteredPhone;
				// 휴대전화 번호에는 숫자만 입력할 수 있습니다.
				//let msg = "휴대전화 번호에는 숫자만 입력할 수 있습니다.";
				//setMessage(msgDiv, msg, false);
			} else {
				if(inputValue.length < 10){
					phoneInputChecked = false;
					// 휴대전화 번호는 10자리 이상이어야 합니다.
					let msg = "휴대전화 번호는 10자리 이상이어야 합니다.";
					setMessage(msgDiv, msg, false);
				} else {
					phoneInputChecked = true;
					// phone OK
					clearMessage(msgDiv);
				}
			}
			break;
		
		case "email":		
		
			let emailRegex = /^[a-z0-9_+.-]+@([a-z0-9-]+\.)+[a-z0-9]{2,4}$/;
		
			if(!emailRegex.test(inputValue)){
				emailInputChecked = false;
				// 올바른 이메일 주소 형식이 아닙니다.
				let msg = "올바른 이메일 주소 형식이 아닙니다.";
				setMessage(msgDiv, msg, false);
			} else {
				emailInputChecked = true;
				// email OK
				clearMessage(msgDiv);
			}
			break;
			
	}
	controllButton();
}

/* focusout 이벤트 발생 시 중복 검사 */
document.getElementById("id").addEventListener("focusout", duplicationCheckOnFocusOut);
document.getElementById("nickname").addEventListener("focusout", duplicationCheckOnFocusOut);
document.getElementById("email").addEventListener("focusout", duplicationCheckOnFocusOut);
document.getElementById("phone").addEventListener("focusout", duplicationCheckOnFocusOut);

function duplicationCheckOnFocusOut(event) {
	
	let inputField = event.target;
	let inputValue = inputField.value;
	let fieldId = inputField.id;
	let msgDiv = fieldId + "Message";
	//alert(inputField + "/" + fieldId + " : " + inputValue);
	//console.log("FocusOut event occurred : " + fieldName);
	
	$.ajax({
		url : "/duplicationCheck",
		method : "post",
		data : {fieldId : fieldId, value : inputValue},
		success : function(result) {
			switch(fieldId){
				
				case "id":
					
					if(idInputChecked){
						if(result > 0){
							idDuplicationChecked = false;
							let msg = "이미 사용중인 아이디입니다.";
							setMessage(msgDiv, msg, false);
							invalidInput(inputField);
						} else {
							idDuplicationChecked = true;
							let msg = "사용 가능한 아이디입니다.";
							setMessage(msgDiv, msg, true);
							validInput(inputField);
						}
					}
					break;
				
				case "nickname":
				
					if(nickInputChecked){
						if(result > 0){
							nickDuplicationChecked = false;
							let msg = "이미 사용중인 닉네임입니다.";
							setMessage(msgDiv, msg, false);
							invalidInput(inputField);
						} else {
							nickDuplicationChecked = true;
							let msg = "사용 가능한 닉네임입니다.";
							setMessage(msgDiv, msg, true);
							validInput(inputField);
						}
					}
					break;
				
				case "email":
				
					if(emailInputChecked){
						if(result > 0){
							document.getElementById("emailCodeDiv").style.visibility = "hidden";
							document.getElementById("guideMessage").style.visibility = "visible";
							emailDuplicationChecked = false;
							let msg = "이미 가입된 이메일입니다.";
							setMessage(msgDiv, msg, false);
							invalidInput(inputField);
						} else {
							document.getElementById("emailCodeDiv").style.visibility = "visible";
							document.getElementById("guideMessage").style.visibility = "hidden";
							emailDuplicationChecked = true;
							sendVerificationCode();
							clearMessage(msgDiv);
							validInput(inputField);
						}
					}
					break;
				
				case "phone":
				
					if(phoneInputChecked){
						if(result > 0){
							phoneDuplicationChecked = false;
							let msg = "이미 가입된 휴대전화 번호입니다.";
							setMessage(msgDiv, msg, false);
							invalidInput(inputField);
						} else {
							phoneDuplicationChecked = true;
							let msg = "가입 가능한 휴대전화 번호입니다.";
							setMessage(msgDiv, msg, true);
							validInput(inputField);
						}
					}
					break;
				
			}
			controllButton();
		},
		error : function(error) {
			alert("ERROR : " + JSON.stringify(error));
		}
	});
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
				document.getElementById("email").readOnly = true;
				document.getElementById("emailCode").readOnly = true;
				document.getElementById("sendCode").setAttribute("disabled", "disabled");
				document.getElementById("checkCode").setAttribute("disabled", "disabled");
				emailCodeChecked = true;
				clearMessage("emailCodeMessage");
				validInput(document.getElementById("emailCode"));
			} else {
				emailCodeChecked = false;
				let msg = "인증번호가 일치하지 않습니다.";
				setMessage("emailCodeMessage", msg, false);
				invalidInput(document.getElementById("emailCode"));
			}
			controllButton();
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

/* 비밀번호 암호화 */
function encryptPassword(pw) {
	
	return M.sec.encrypt(pw).result;
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

/* Invalid input */
function invalidInput(field) {
	
	field.classList.remove("is-valid");
	field.classList.add("is-invalid");
}

/* Valid input */
function validInput(field) {
	
	field.classList.add("is-valid");
	field.classList.remove("is-invalid");
}

/* 버튼 상태 변경 */
function controllButton() {
	
	if(emailInputChecked && emailDuplicationChecked && emailCodeChecked){
		document.getElementById("next1").removeAttribute("disabled");
		if(idInputChecked && idDuplicationChecked
		&& pwInputChecked && pwcheckInputChecked){
			document.getElementById("next2").removeAttribute("disabled");
			if(nickInputChecked && nickDuplicationChecked
			&& phoneInputChecked && phoneDuplicationChecked){
				document.querySelector('button[type="submit"]').removeAttribute("disabled");
			}
		}
	}
}

/* 회원가입 페이징 */
function showPage(pageId) {

	let pages = document.querySelectorAll(".page");
	for (let i = 0; i < pages.length; i++) {
		pages[i].style.display = "none";
	}
	document.getElementById(pageId).style.display = "block";
}