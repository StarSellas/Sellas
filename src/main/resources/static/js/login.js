
function login() {
	
	//alert("login");
	
	var id = document.getElementById("id").value;
	var pw = document.getElementById("pw").value;
	
	if(id == null || id == ""){
		document.getElementById("id").classList.add("is-invalid");
		document.getElementById("pw").classList.remove("is-invalid");
	} else if(pw == null || pw == "") {
		document.getElementById("id").classList.remove("is-invalid");
		document.getElementById("pw").classList.add("is-invalid");
	} else {
		document.getElementById("id").classList.remove("is-invalid");
		document.getElementById("pw").classList.remove("is-invalid");
	
		pw = encryptPassword(pw);
	
		$.ajax({
			url : "./login",
			method : "post",
			data : {id : id, pw : pw},
			dataType : "json",
			success : function(result){
				if(result){
					window.location.href = '/';
				} else{
					document.getElementById("pw").classList.add("is-invalid");
					document.getElementById("pw").value = "";
					document.getElementById("errorMessage").textContent="아이디 또는 비밀번호를 확인 후 다시 입력하세요";
					document.getElementById("errorMessage").style.color="red";
				}
			},
			error : function(error){
				alert("ERROR : " + JSON.stringify(error));
			}
		});
	
	}
}

/* 비밀번호 암호화 */
function encryptPassword(pw) {
	
	return M.sec.encrypt(pw).result;
}