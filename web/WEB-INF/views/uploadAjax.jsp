<%--
  Created by IntelliJ IDEA.
  User: bongchangyun
  Date: 2022/02/24
  Time: 11:44 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .uploadResult{
        width: 100%;
        background-color: gray;
    }

    .uploadResult ul{
        display: flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }

    .uploadResult ul li {
        list-style: none;
        padding: 10px;
        align-content: center;
        text-align: center;
    }

    .uploadResult ul li img{
        width: 100px;
    }

    .uploadResult ul li span{
        color: white;
    }

    .bigPictureWrapper{
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top:    0%;
        width:  100%;
        height:     100%;
        background-color: gray;
        z-index: 100;
        background: rgba(255,255,2555,0.5);
    }

    .bigPicture{
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .bigPicture img{
        width: 600px;
    }

</style>

<html>
<head>
    <title>Upload Ajax</title>
</head>
<body>
    <h1>Upload With Ajax</h1>
    <div class="uploadDiv">
        <input type="file" name="uploadFile" multiple>
    </div>

    <div class="uploadResult">
        <ul>

        </ul>
    </div>

    <button id="uploadBtn">Upload</button>


    <div class="bigPictureWrapper">
        <div class="bigPicture">

        </div>
    </div>



    <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
    <script>


        function showImage(fileCallPath){
            // alert(fileCallPath);
            $(".bigPictureWrapper").css("display", "flex").show();

            $(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+ "'>").animate({width:'100%', height:'100%'}, 1000);
        }


        $(document).ready(function(){

            let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");

            let maxSize = 5242880;  // 5MB

            function checkExtension(fileName, fileSize){
                if(fileSize >= maxSize){
                    alert("파일 사이즈 초과");
                    return false;
                }

                if(regex.test(fileName)){
                    alert("해당 종류의 파일은 업로드할 수 없습니다.");
                    return false;
                }
                return true;
            }


            // 첨부 파일을 업로드하기 전에 아무 내용이 없는 <input type="file"> 객체가 포함된 div를 복사
            let cloneObj = $(".uploadDiv").clone();

            $("#uploadBtn").on("click", function(e){
                let formData = new FormData();  // Like Virtual form tag
                let inputFile = $("input[name='uploadFile']");
                let files = inputFile[0].files;
                console.log(files);

                for(let i = 0 ; i < files.length ; i++){
                    if(!checkExtension(files[i].name, files[i].size)){
                        return false;
                    }

                    formData.append("uploadFile", files[i]);
                }

                $.ajax({
                    url: '/uploadAjaxAction',
                    processData: false,
                    contentType: false,
                    data: formData,
                    type: 'POST',
                    dataType: 'json',
                    success: function(result){
                        console.log(result);

                        showUploadedFile(result);
                        // 파일 업로드가 끝나면 비어있는 cloneObj의 html 요소를 uploadDiv html로 -> 업로드 종료 후 input을 비우는 역할
                        $(".uploadDiv").html(cloneObj.html());
                    }

                }); //$.ajax

                /*   $.ajax({
			 url: '/uploadAjaxAction',
			 processData: false,
			 contentType: false,
			 data: formData,
			 type: 'POST',
			 success: function(result){
			 alert("Uploaded");
			 }
			 }); //$.ajax */
            });

            let uploadResult = $(".uploadResult ul");
            function showUploadedFile(uploadResultArr){
                let str= '';
                $(uploadResultArr).each(function (i, obj){
                   if(!obj.image){
                       let fileCallPath = encodeURIComponent( obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
                       let fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                       str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"+
                           "<img src='/resources/img/attach.png'>"+obj.fileName+"</a>"+
                           "<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"+
                           "<div></li>"
                   }else{
                       // uploadController의 uploadAjaxAction post의 응답을 받고 이미지일 경우 썸네일을 보여준다
                       // str += "<li>" +obj.fileName + "</li>";
                       let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);

                       let originPath = obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;
                       originPath = originPath.replace(new RegExp(/\\/g), "/");

                       str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"+
                           "<img src='display?fileName="+fileCallPath+"'></a>"+
                           "<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"+
                           "<li>";
                   }

                });
                uploadResult.append(str);
            }


            $(".bigPictureWrapper").on("click", function (e){
                $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
                setTimeout(()=>{
                    $(this).hide();
                }, 1000);
            });

            //  IE11 동작
            // $(".bigPictureWrapper").on("click", function (e){
            //     $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
            //     setTimeout(function (){
            //         $(".bigPictureWrapper").hide();
            //     }, 1000);
            // })

            $(".uploadResult").on("click", "span", function (e){
                let targetFile = $(this).data("file");
                let type = $(this).data("type");
                console.log(targetFile);

                $.ajax({
                   url:'/deleteFile',
                   data: {fileName:targetFile, type: type},
                   dataType: 'text',
                   type: 'POST',
                   success: function (result){
                       alert(result);
                   }
                }); // $.ajax

            }); //  end uploadResult

        });


    </script>

</body>
</html>
