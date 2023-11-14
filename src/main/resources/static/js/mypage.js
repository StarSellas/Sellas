	//모피어스를 이용한 카메라 사진 및 앨범 사진 넣기 by 대원
	let cameraImagePath ='';
	let selectImagePath = [];
    let $previewImg = null;
    let $uploadImg = null;
    let $previewImgArray = [];
	
	
    
    const $box = $('#box');
    const $uploadBox = $('#upload-box');
    const $progress = $('#progress');
    const $picker = $('#picker');
    const $upload = $('#upload');
    const $camera = $('#camera');
    const $picker2 = $('#picker2');
    const $profile = $('.user-img-img');
    
    


function nickChange() {
		
			let newNickname = $("#newNickname").val();
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
			
		if(confirm("["+newNickname+"]님으로 닉네임을 변경하시겠습니까?")){
			
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

function picChange() {
	
	alert("!");
	
}

    $("#camera").click(function(){
    	
    	$("#picker2").hide();
alert("!");
    	
   	 if ($previewImg !== null) {
		        $previewImg.remove();
		        $previewImg = null;
		      }
		      selectImagePath = [];
	M.media.camera({
       path: "/media",
       mediaType: "PHOTO",
       saveAlbum: true,
       callback: function(status, result, option) {
           if (status == 'SUCCESS') {
        	   //alert("뜨나?11")
               var photo_path = result.fullpath;
               selectImagePath[0] = result.path;
               
                $.convertBase64ByPath2(selectImagePath)
                .then(({ status, result }) => {
         if (status === 'SUCCESS') {
        	 //alert("뜨나?22")
           $profile.attr('src', "data:image/png;base64," + result[0].data)
           
         } else {
           return Promise.reject('BASE64 변환 실패')
         }
       })
       .catch((err) => {
         if (typeof err === 'string') alert(err)
         console.error(err)
       })
               
           }
       }
     
		 });
  }); 
    

   			 $picker2.on('click', () => {
   				 $("#camera").hide();
   				 if ($box.find('img').length >= 5) {s
   			        alert('더 이상 이미지를 추가할 수 없습니다.');
   			        return false;
   			    }
   				 
   				 
    	  		if ($previewImg !== null) {
    	   				 $previewImg.remove();
    	   				 $previewImg = null;
    	 			 }
    		  selectImagePath = '';
    	 		 $.imagePicker2()
    	   		 .then(({ status, result }) => {
    	     	 	if (status === 'SUCCESS') {
    	    	 		 for (let i = 0; i < result.length; i++) {
    	    	 			 $previewImgArray[i] = result[i].path;
    	    	 		 }
    	       		 return $.convertBase64ByPath2($previewImgArray)
    	       		 } else {
    	            return Promise.reject('이미지 가져오기 실패')
    	       		 }
    	      })
    	      .then(({ status, result }) => {
    	        if (status === 'SUCCESS') {
    	        for (let i = 0; i < result.length; i++) {
    	        	
    	          let imageSrc = "data:image/png;base64," + result[i].data;
    	          $profile.attr('src', imageSrc);
    	        }
    	      } else {
    	        return Promise.reject('이미지 가져오기 실패');
    	      }
    	    })
    	    .catch((err) => {
    	      if (typeof err === 'string') alert(err);
    	      console.error(err);
    	    });
    	})
	
    	
    	$.imagePicker2 = function () {
				      return new Promise((resolve) => {
				        M.media.picker({
				          mode: "MULTI",
				          media: "PHOTO",
				          maxCount : 4,
				          // path: "/media", // 값을 넘기지않아야 기본 앨범 경로를 바라본다.
				          column: 3,
				          callback: (status, result) => {
				            resolve({ status, result })
				            
				          
				          }
				        });
				      })
				    }
   			 
   			$.convertBase64ByPath2 = function ($previewImgArray) {
		    	  if (!Array.isArray($previewImgArray)) {
		    	    throw new Error('$previewImgArray must be an array');
		    	  }

		    	  return new Promise((resolve) => {
		    	    const results = [];

		    	    const readNextFile = (index) => {
		    	      if (index < $previewImgArray.length) {
		    	        M.file.read({
		    	          path: $previewImgArray[index],
		    	          encoding: 'BASE64',
		    	          indicator: true,
		    	          callback: function (status, result) {
		    	            if (status === 'SUCCESS') {
		    	              results.push(result);
		    	              readNextFile(index + 1);
		    	            } else {
		    	              // Handle error
		    	              results.push(null); // Push null for failed file
		    	              readNextFile(index + 1);
		    	            }
		    	          }
		    	        });
		    	      } else {
		    	        resolve({ status: 'SUCCESS', result: results });
		    	      }
		    	    };

		    	    readNextFile(0);
		    	  });
		    	};
		    	
		    	$.uploadImageByPath2 = function ($previewImgArray, uuid, progress) {
			    	  return new Promise((resolve) => {
			    	    const _options = {
			    	      url: 'http://172.30.1.2:8080/profileEdit/photoModify',
			    	      header: {},
			    	      params: {uuid : uuid},
			    	      body: $previewImgArray.map((filePath) => ({
			    	        name: 'file',
			    	        content: filePath,
			    	        type: 'FILE',
			    	      })),
			    	      encoding: 'UTF-8',
			    	      finish: (status, header, body, setting) => {
			    	        resolve({ status, header, body });
			    	      },
			    	      progress: function (total, current) {
			    	        progress(total, current);
			    	      },
			    	    };

			    	    M.net.http.upload(_options);
			    	  });
			    	};
   			 
			  $(function(){
				  $("#addPhoto").show();
				  $("#addPhotoBtn").click(function(){
					  alert("사진은 앨범과 카메라 중 하나만 선택 가능합니다.");
					  $("#addPhoto").show();
				  });
				  
				  
				  $(".bwriteButton").click(function(){
					alert("요기");
					let muuid = $(this).parent().siblings(".muuid").val();
					alert(muuid);
					
					$.ajax({
						url : "./photoModifySubmit",
						type : "post",
						data : {uuid : muuid},
						dataType : "json",
						success : function(data){
						alert("!여기");
							if(data.result == 1){
								
								let uuid = data.uuid;
								
								alert("이건? : "+ uuid);
								
								if($previewImgArray[0].length > 0){
									if ($previewImgArray[0] === ''){
											 if ($uploadImg) {
											        $uploadImg.remove();
											        $uploadImg = null;
											}
									 }
								      
								      $progress.text('')
								      $.uploadImageByPath2($previewImgArray, uuid, (total, current) => {
								        console.log(`total: ${total} , current: ${current}`)
								        $progress.text(`${current}/${total}`)
								      })
								        .then(({
								          status, header, body
								        }) => {
								          // status code
								          if (status === '200') {
								        	  alert("떠라");
								            $progress.text('업로드 완료')
								            const bodyJson = JSON.parse(body)
								            $uploadImg = $(document.createElement('img'))
								            $uploadImg.attr('height', '200px')
								            $uploadImg.attr('src', bodyJson.fullpath)
								            $uploadBox.append($uploadImg)
								          } else {
								            return Promise.reject(status)
								          }
								        })
								        .catch((err) => {
								          if (typeof err === 'string') alert(err)
								          console.error(err)
								        })
									
								}
								
								alert("작성이 완료되었습니다.");
								window.location.href = '/profile';
									
							}
						},
						error : function(error){
							alert("흑흑");
						}
						
					});
					
				  });
			  });
			    	



