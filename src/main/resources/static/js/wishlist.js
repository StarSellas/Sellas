
$(function() {
	let tno = $(".normalTno").val();

$("#addWishList").click(function() {
    $.ajax({
        url: "addWish",
        type: "post",
        data: { tno: tno },
        dataType: "json",
        success: function(data) {
            if (data.addWish == 1) {
                if(confirm("위시리스트로 이동하시겠습니까?")){
                    window.location.href = '/getwish';
                } else {
                    window.location.reload(); // 취소 버튼을 눌렀을 때만 새로고침
                }
            }
        },
        error: function(error) {
            alert("현재 서비스가 불가합니다.");
        }
    });
});

	
		$("#delWishList").click(function() {
	
			$.ajax({
				url: "delWish",
				type: "post",
				data: { tno: tno },
				dataType: "json",
				success: function(data) {
					if (data.delWish == 1) {
						alert("위시리스트에서 삭제되었습니다.");
							window.location.reload();
					}
				},
				error: function(error) {
					alert("현재 서비스가 불가합니다.");
				}
			});
		
	});


});

