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
    }

    .uploadResult ul li img{
        width: 20px;
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

    <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
    <script>
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
                       str += "<li><image src='/resources/img/attach.png'>" + obj.fileName + "</li>";
                   }else{
                       // str += "<li>" +obj.fileName + "</li>";
                       let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
                       str += "<li><img src='/display?fileName="+fileCallPath+"'></li>";
                   }

                });
                uploadResult.append(str);
            }

        });
    </script>

</body>
</html>
