<%--
  Created by IntelliJ IDEA.
  User: bongchangyun
  Date: 2022/02/17
  Time: 11:16 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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

<%@include file="../includes/header.jsp"%>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Register</h1>
    </div>
    <!-- /.col-lg-12 -->

</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Register</div>

            <!-- /.panel-body-->
            <div class="panel-body">
                <form role="form" action="/board/register" method="post">
                    <div class="form-group">
                        <label>Title</label><input class="form-control" name="title">
                    </div>

                    <div class="form-group">
                        <label>Text Area</label><textarea class="form-control" rows="3" name="content"></textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name="writer">
                    </div>

                    <button type="submit" class="btn btn-default">Submit Button</button>
                    <button type="reset" class="btn-default btn">Reset Button</button>
                </form>
            </div>
            <!-- end panel-body -->
        </div>
    <%--        end panel-bpdy--%>
    </div>
    <%--    end panel--%>
</div>
<%--/.row--%>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">File Attach</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple>
                </div>

                <div class="uploadResult">
                    <ul>

                    </ul>
                </div>

            </div>
<%--            end panel body--%>
        </div>
<%--        end panel--%>
    </div>
</div>
<%--    /.row--%>


<%@ include file="../includes/footer.jsp"%>

<script>
    $(document).ready(function (e){

        let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        let maxSize = 5242880;

        function checkExtension(fileName, fileSize){
            if(fileSize >= maxSize){
                alert("파일 사이즈 초과!");
                return false;
            }

            if(regex.test(fileName)){
                alert("해당 종류의 파일은 업로드할 수 없습니다.");
                return false;
            }

            return true;
        }

        $("input[type='file']").change(function (e){
            let formData = new FormData();
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;

            for(let i = 0 ; i<files.length ; i++){
                if(!checkExtension(files[i].name, files[i].size) ){
                    inputFile.value='';
                    return false;
                }
                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url: '/uploadAjaxAction',
                processData: false,
                contentType: false,data:
                formData,type: 'POST',
                dataType:'json',
                success: function(result){
                    console.log(result);
                    showUploadResult(result);
                }
            }); //$.ajax
        });

        function showUploadResult(uploadResultArr){
            console.log('Start showUploadResult()!');

            if(!uploadResultArr || uploadResultArr.length==0){return;}

            let uploadUL = $(".uploadResult ul");
            let str = "";

            $(uploadResultArr).each(function(i, obj){
                //  image type
                if(obj.image){
                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
                    str += "<li data-path='"+obj.uploadPath+"'";
                    str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
                    str +" ><div>";
                    str += "<span> "+ obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' ";
                    str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/display?fileName="+fileCallPath+"'>";
                    str += "</div>";
                    str +"</li>";
                }else{
                    let fileCallPath = encodeURIComponent( obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
                    // console.log("Not Image fileCallPath : "+fileCallPath);

                    let fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                    str += "<li "
                    str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
                    str += "<span> "+ obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
                    str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/resources/img/attach.png'></a>";
                    str += "</div>";
                    str +"</li>";
                }
            });
            uploadUL.append(str);
        }

        $(".uploadResult").on("click", "button", function (e){
            console.log("delete file");

            let targetFile = $(this).data("file");
            let type = $(this).data("type");

            let targetLi = $(this).closest("li");

            $.ajax({
                url: '/deleteFile',
                data: {fileName: targetFile, type:type},
                dataType: 'text',
                type: 'POST',
                success: function (result){
                    alert(result);
                    targetLi.remove();
                }
            }); //  $.ajax
        });

        let formObj = $("form[role='form']");
        $("button[type='submit']").on("click", function(e){
            e.preventDefault();
            // console.log("submit clicked!");

            let str = '';

            $(".uploadResult ul li").each(function (i, obj){
                let jobj = $(obj);

                console.dir(jobj);

                str += "<input type='hidden' name='attachList[" + i + "].fileName' value='"+jobj.data("filename")+"'>";
                str += "<input type='hidden' name='attachList[" + i + "].uuid' value='"+jobj.data("uuid")+"'>";
                str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='"+jobj.data("path")+"'>";
                str += "<input type='hidden' name='attachList[" + i + "].fileType' value='"+jobj.data("type")+"'>";
            });
            formObj.append(str).submit();
        });

    });
</script>