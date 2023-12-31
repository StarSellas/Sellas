
let emailCodeChecked = false;

/* 이메일 인증 시작 */
function showEmailCodeDiv() {
	
	let id = document.getElementById("id").value;
	let emailAddress = document.getElementById("email").value;
	
	$.ajax({
		url : "/crosscheckIdAndEmail",
		method : "post",
		data : {id : id, email : emailAddress},
		success : function(result){
			if(result){
				document.getElementById("idDiv").textContent = id;
				document.getElementById("emailDiv").textContent = emailAddress;
				showPage("page2");
				sendVerificationCode();
			} else {
				setMessage("emailMessage", "회원 정보를 확인하고 다시 입력하세요.", false);
			}
		},
		error : function(error){
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
				emailCodeChecked = true;
				showPage("page3");
			} else {
				emailCodeChecked = false;
				let msg = "인증번호가 일치하지 않습니다.";
				setMessage("emailCodeMessage", msg, false);
				invalidInput(document.getElementById("emailCode"));
			}
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}

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
	
	let id = document.getElementById("id").value;
	let emailAddress = document.getElementById("email").value;
	let password = document.getElementById("pw").value;
	
	$.ajax({
		url : "/changePassword",
		method : "post",
		data : {email : emailAddress, id : id, pw : encryptPassword(password)},
		success : function(result){
			if(result){
				showPage("page4");
			}
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
	
	if(pwInputChecked && pwcheckInputChecked){
		document.getElementById("changePasswordButton").removeAttribute("disabled");
	}
}

/* 비밀번호 찾기 페이징 */
function showPage(pageId) {

	let pages = document.querySelectorAll(".page");
	for (let i = 0; i < pages.length; i++) {
		pages[i].style.display = "none";
	}
	document.getElementById(pageId).style.display = "block";
}