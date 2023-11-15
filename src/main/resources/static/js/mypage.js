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

     $(".picChange").click(function(){
alert("!");
     $(".toggleBtnBox").toggleClass("btnClicked");   // 버튼위로이동
     $(".otherBtnBox").toggleClass("hide");
     $(".bwriteBtnBox").toggleClass("hide");
                     
      if($(".toggleBtnBox").hasClass("btnClicked")){
          $(".otherBtnBox").addClass("tBtnBox");
          $(".bwriteBtnBox").addClass("tBtnBox");
      } else {
    $(".otherBtnBox").removeClass("tBtnBox");
    $(".bwriteBtnBox").removeClass("tBtnBox");
         }
      });


    $("#camera").click(function(){
       
       
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
                if ($box.find('img').length >= 5) {s
                    alert('더 이상 이미지를 변경할 수 없습니다 잠시후 이용해주세요.');
                    return false;
                }
                
                
               if ($previewImg !== null) {
                       $previewImg.remove();
                       $previewImg = null;
                  }
            selectImagePath = [];
               $.imagePicker2()
                 .then(({ status, result }) => {
                   if (status === 'SUCCESS') {
                         selectImagePath[0] = result.path;
                     return $.convertBase64ByPath2(selectImagePath)
                     } else {
                   return Promise.reject('이미지 가져오기 실패')
                     }
             })
             .then(({ status, result }) => {
               if (status === 'SUCCESS') {
                 
                 let imageSrc = "data:image/png;base64," + result[0].data;
                 $profile.attr('src', imageSrc);
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
                      mode: "SINGLE",
                      media: "PHOTO",
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
             

              
              $("#bwriteButton").click(function(){
               let muuid = $(this).parent().siblings(".muuid").val();
               
               $.ajax({
                  url : "./photoModifySubmit",
                  type : "post",
                  data : {uuid : muuid},
                  dataType : "json",
                  success : function(data){
                     if(data.result == 1){
                        
                        let uuid = data.uuid;
                        
                        
                        if(selectImagePath.length > 0){
                           if (selectImagePath[0] === ''){
                                  if ($uploadImg) {
                                         $uploadImg.remove();
                                         $uploadImg = null;
                                 }
                            }
                              
                              $progress.text('')
                              $.uploadImageByPath2(selectImagePath, uuid, (total, current) => {
                                console.log(`total: ${total} , current: ${current}`)
                                $progress.text(`${current}/${total}`)
                              })
                                .then(({
                                  status, header, body
                                }) => {
                                  // status code
                                  if (status === '200') {
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
 

