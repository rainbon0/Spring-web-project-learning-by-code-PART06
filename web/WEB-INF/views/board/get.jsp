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

<%@include file="../includes/header.jsp"%>

<style>
    .uploadResult {
        width:100%;
        background-color: gray;
    }
    .uploadResult ul{
        display:flex;
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
    .uploadResult ul li span {
        color:white;
    }
    .bigPictureWrapper {
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top:0%;
        width:100%;
        height:100%;
        background-color: gray;
        z-index: 100;
        background:rgba(255,255,255,0.5);
    }
    .bigPicture {
        position: relative;
        display:flex;
        justify-content: center;
        align-items: center;
    }

    .bigPicture img {
        width:600px;
    }

</style>

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
            <div class="panel-heading">Board Read Page</div>

            <!-- /.panel-body-->
            <div class="panel-body">

                    <div class="form-group">
                        <label>Bno</label><input class="form-control" name="bno"
                    value='<c:out value="${board.bno}" />' readonly>
                    </div>

                    <div class="form-group">
                        <label>Title</label><input class="form-control" name="title"
                    value='<c:out value="${board.title}"/>' readonly>
                    </div>

                    <div class="form-group">
                        <label>Text Area</label>
                        <textarea class="form-control" rows="3" name="content" readonly><c:out value="${board.content}" /></textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly>
                    </div>

                    <button data-oper="modify" class="btn btn-default">Modify Button</button>
                    <button data-oper="list" class="btn-info btn">List</button>

                    <form id="operForm" action="/board/modify" method="get">
                        <input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}' />">
                        <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}" />'>
                        <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'/>
                        <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                        <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'/>
                    </form>
            </div>
            <!-- end panel-body -->
        </div>
    <%--        end panel-bpdy--%>
    </div>
    <%--    end panel--%>
</div>
<%--/.row--%>

<div class='row'>

    <div class="col-lg-12">

        <!-- /.panel -->
        <div class="panel panel-default">
            <!--       <div class="panel-heading">
                    <i class="fa fa-comments fa-fw"></i> Reply
                  </div> -->

            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
            </div>


            <!-- /.panel-heading -->
            <div class="panel-body">

                <ul class="chat">

                </ul>
                <!-- ./ end ul -->
            </div>
            <!-- /.panel .chat-panel -->

            <div class="panel-footer"></div>


        </div>
    </div>
    <!-- ./ end row -->

    <div class="bigPictureWrapper">
        <div class="bigPicture">

        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">Files</div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <div class="uploadResult">
                        <ul>

                        </ul>
                    </div>
                </div>
<%--                end panel-body--%>
            </div>
<%--            end panel-heading--%>
        </div>
    </div>
<%--/.row--%>
</div>



<!-- new Reply Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="ture">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>Reply</label>
                    <input class="form-control" name="reply" value="New Reply!!!">
                </div>
                <div class="form-group">
                    <label>Replyer</label>
                    <input class="form-control" name="replyer" value="replyer">
                </div>
                <div class="form-group">
                    <label>Repl Date</label>
                    <input class="form-control" name="replyDate" value="">
                </div>
            </div>
            <div class="modal-footer">
                <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
                <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
                <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
                <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/reply.js" ></script>
<script type="text/javascript">

    // 댓글 조회 클릭 이벤트 처리
    $(".chat").on("click", "li", function(e){
        let rno = $(this).data("rno");
        replyService.get(rno,function (reply){
            modalInputReply.val(reply.reply);
            modalInputReplyer.val(reply.replyer);
            modalInputReplyDate.val(replyService.displayTime( reply.replyDate))
                .attr("readonly","readonly");
            modal.data("rno", reply.rno);

            modal.find("button[id !='modalCloseBtn']").hide();
            modalModBtn.show();
            modalRemoveBtn.show();

            $(".modal").modal("show");
        })
    })

    $("#modalCloseBtn").on("click", function(e){

        modal.modal('hide');
    });

    console.log("===================");
    console.log("JS Test");

    let bnoValue = '<c:out value="${board.bno}"/>';
    let replyUL = $(".chat");

    showList(1);

    function showList(page){
        console.log("show List " + page);
        replyService.getList({bno:bnoValue, page: page||1}, function (replyCnt, list){
            console.log("replyCnt : " + replyCnt);
            console.log("list : " + list);
            console.log(list);

            if(page== -1){
                pageNum = Math.ceil(replyCnt / 10.0);
                showList(pageNum);
                return;
            }

            let str="";
            if(list==null || list.length == 0){
                replyUL.html("");

                return;
            }

            for(let i = 0, len = list.length || 0 ; i<len ; i++){
                str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                str += "    <div><div class='header'><strong class='primary-font'>" + list[i].replyer+"</strong>";
                str += "    <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
                str += "    <p>"+ list[i].reply+"</p></div></li>";
            }
            replyUL.html(str);
        }); // end function
    }   // end showList

    let modal = $(".modal");
    let modalInputReply = modal.find("input[name='reply']");
    let modalInputReplyer = modal.find("input[name='replyer']");
    let modalInputReplyDate = modal.find("input[name='replyDate']");

    let modalModBtn = $("#modalModBtn");
    let modalRemoveBtn = $("#modalRemoveBtn");
    let modalRegisterBtn = $("#modalRegisterBtn");

    $("#addReplyBtn").on("click", function(e){

        modal.find("input").val("");
        modalInputReplyDate.closest("div").hide();
        modal.find("button[id !='modalCloseBtn']").hide();

        modalRegisterBtn.show();

        $(".modal").modal("show");

    })

    // 댓글 등록 버튼 클릭 동작
    modalRegisterBtn.on("click", function (e){
        let reply = {
            reply : modalInputReply.val(),
            replyer : modalInputReplyer.val(),
            bno : bnoValue
        };

        replyService.add(reply , function (result){
            alert(result);

            modal.find("input").val("");
            modal.modal("hide");
            showList(-1);
        });
    });

    replyService.getList({bno:bnoValue, page:1}, function (list){
        for(let i = 0 , len = list.length || 0; i< len ; i++){
            console.log(list[i]);
        }
    });

    // replyService.remove(12, function (count) {
    //     console.log(count);
    //     if (count === "Success") {
    //         alert("REMOVED!");
    //     }
    // }, function (err){
    //     alert("ERR.......");
    // });

    // replyService.update({rno:13, bno:bnoValue, reply:"Modified Reply ..........."}, function (result){
    //     alert('수정완료!');
    // })
    //
    // replyService.get(13,function (data){
    //     console.log(data);
    // })



    // panel-footer 에 댓글 페이지 추가
    let pageNum = -1;
    let replyPageFooter = $(".panel-footer");

    function showReplyPage(replyCnt){
        let endNum = Math.ceil(pageNum/10.0) * 10;
        let startNum = endNum - 9;

        let prev = startNum != 1;
        let next = false;

        if(endNum * 10 >= replyCnt){
            endNum = Math.ceil(replyCnt / 10.0);

        }
        if(endNum*10 < replyCnt){
            next = true;
        }

        let str= "<ul class='pagination pull-right'>";

        if(prev){
            str += "<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>";
        }

        for(let i = startNum ; i <= endNum ; i++){
            let active = pageNum == i ? "active" : "";

            str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
        }
    }


    // 페이지 버튼 클릭 시
    replyPageFooter.on('click', 'li a', function(e){
        e.preventDefault();
        console.log("page click");

        let targetPageNum = $(this).attr("href");
        console.log("targetPageNum : " + targetPageNum);

        pageNum = targetPageNum;

        showList(pageNum);

    })

    // 수정 버튼 클릭 동작
    modalModBtn.on("click", function (e){
        let reply = {rno:modal.data("rno"), reply:modalInputReply.val()};

        replyService.update(reply, function (result){
            alert(result);
            modal.modal("hide");
            showList(pageNum);
        });
    })

    // 삭제 버튼 클릭 동작
    modalRemoveBtn.on("click", function (e){
        let rno = modal.data("rno");

        replyService.remove(rno, function (result){
            alert(result);
            modal.modal("hide");
            showList(pageNum);
        });
    })

</script>

<script type="text/javascript">
    $(document).ready(function (){
        let operForm = $("#operForm");

        $("button[data-oper='modify']").on("click", function (e){
            // console.log('Modify Clicked!');
            operForm.attr("action", "/board/modify").submit();
        });

        $("button[data-oper='list']").on("click" , function (e){
            operForm.find("#bno").remove();
            operForm.attr("action" , "/board/list")
            operForm.submit();
        });

        (function (){
            let bno = '<c:out value="${board.bno}" />';
            $.getJSON("/board/getAttachList", {bno: bno}, function (arr){
                console.log(arr);
                let str = '';

                $(arr).each(function (i, attach){
                    // image type
                    if(attach.fileType){
                        let fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
                        str += "<img src='/display?fileName="+fileCallPath+"'>";
                        str += "</div>";
                        str + "</li>";
                    }else {
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
                        str += "<span> "+ attach.fileName+"</span><br/>";
                        str += "<img src='/resources/img/attach.png'></a>";
                        str += "</div>";
                        str + "</li>";
                    }
                });
                $(".uploadResult ul").html(str);
            });     // end getJson
        })();   //  end function


        $(".uploadResult").on("click", "li", function (e){
            console.log("view image");
            let liObj = $(this);

            let path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));

            if(liObj.data("type")){
                showImage(path.replace(new RegExp(/\\/g),"/"));
            }else{
                // download
                self.location="/download?fileName=" + path
            }
        });

        function showImage(fileCallPath){
            alert(fileCallPath);
            $(".bigPictureWrapper").css("display", "flex").show();
            $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
            .animate({width: '100%', height: '100%'}, 1000);
        }


        $(".bigPictureWrapper").on("click", function (e){
            $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
            setTimeout(function (){
                $('.bigPictureWrapper').hide();
            }, 1000);
        });
    });
</script>

<%@ include file="../includes/footer.jsp"%>