
function nickChange() {
		
			let newNickname = $(".NewNickname").val();
			const nicknameRegex = /^[a-zA-Z0-9가-힣]+$/;
			const nicknamelength = /^.{1,10}$/;

    if (!nicknameRegex.test(newNickname)) {
        alert("닉네임은 한글, 영문자, 숫자만 사용할 수 있습니다");
        return false;
    }

    if (!nicknamelength.test(newNickname)) {
        alert("닉네임은 2글자 이상이어야 합니다.");
        return false;
    }
			
		if(confirm(newNickname+"으로 닉네임을 변경하시겠습니까?")){
			
			alert(newNickname);
			$.ajax({
				url: "./isNicknameExists",
				type: "post",
				data: { newNickname: newNickname },
				dataType : "json",
				success: function(result) {
					if(result == 1) {
						alert("중복된 닉네임 입니다.");
						return false;
					} else {
						
                    $.ajax({
                        url: "./nicknameModify",
                        type: "post",
                        data: { newNickname: newNickname },
                        dataType: "json",
                        success: function(result) {
                            if (result == 1) {
                                alert("변경이 완료되었습니다.");
 								 window.location.href = '/profile';
                            } else {
                                alert("변경에 실패했습니다.");
                            }
                        },
                        error: function(error) {
                            alert("단단히 실패");
                        }
                    });
                }
            },
			});
		}	

}