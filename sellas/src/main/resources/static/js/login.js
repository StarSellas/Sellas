
function login() {
	
	//alert("login");
	
	var id = document.getElementById("id").value;
	var pw = document.getElementById("pw").value;
	
	$.ajax({
		url : "./login",
		method : "post",
		data : {id : id, pw : pw},
		dataType : "json",
		success : function(result){
			if(result){
				window.location.href = '/';
			} else{
				
			}
		},
		error : function(error){
			alert("ERROR : " + JSON.stringify(error));
		}
	});
}