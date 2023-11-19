
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


               M.pop.alert({
                  title: 'Sellas',
                  message: '위시리스트로 이동하시겠습니까?',
                  buttons: ['계속보기', '이동하기'],
                  callback: function(index) {
                     if (index === 0) { // 취소버튼
                        window.location.reload();
                     } else if (index === 1) { // 이동하기
                     window.location.href = '/getwish';
                     }
                  }
               })

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




	$(".call").click(function() {
		
		        M.pop.alert({
                  title: 'Sellas',
                  message: '고객센터로 전화하시겠습니까?',
                  buttons: ['전화하기', '돌아가기'],
                  callback: function(index) {
                     if (index === 1) { // 취소버튼
                        window.location.reload();
                     } else if (index === 0) { // 이동하기
                  	M.sys.call('01012345678');
                     }
                  }
               })
		});


});
