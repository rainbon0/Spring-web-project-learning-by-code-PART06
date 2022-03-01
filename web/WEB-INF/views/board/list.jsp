
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../includes/header.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<style>
    .activate{
        background-color: #337ab7 !important;
        color: white !important;
    }
</style>


        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Tables</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
                        Board List Page
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>#번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>수정일</th>
                            </tr>
                            </thead>
                            <c:forEach items="${list}" var="board">
                                <tr>
                                    <td><c:out value = "${board.bno}" /></td>

                                    <td><a class="move" href='<c:out value="${board.bno}" />'>
                                        <c:out value = "${board.title}" />
                                        <b>[ <c:out value="${board.replyCnt}"/> ]</b>
                                        </a></td>

                                    <td><c:out value = "${board.writer}" /></td>
                                    <td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></td>
                                    <td><fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd"/></td>
                                </tr>
                            </c:forEach>
                        </table>

                        <div class ="row">
                            <div class="col-lg-12">
                                <form id="searchForm" action="/board/list" method="get">
                                    <select name="type">
                                        <option value="" <c:out value="${pageMarker.cri.type == null ? 'selected' : '' }" /> >--</option>
                                        <option value="T" <c:out value="${pageMarker.cri.type eq 'T' ? 'selected' : '' }" /> >제목</option>
                                        <option value="C" <c:out value="${pageMarker.cri.type eq 'C' ? 'selected' : '' }" /> >내용</option>
                                        <option value="W" <c:out value="${pageMarker.cri.type eq 'W' ? 'selected' : '' }" /> >작성자</option>
                                        <option value="TC" <c:out value="${pageMarker.cri.type eq 'TC' ? 'selected' : '' }" /> >제목 or 내용</option>
                                        <option value="TW" <c:out value="${pageMarker.cri.type eq 'TW' ? 'selected' : '' }" /> >제목 or 작성자</option>
                                        <option value="TWC" <c:out value="${pageMarker.cri.type eq 'TWC' ? 'selected' : '' }" /> >제목 or 내용 or 작성자</option>
                                    </select>
                                    <input type="text" name="keyword" value='<c:out value="${pageMarker.cri.keyword}"/>'>
                                    <input type="hidden" name="pageNum" value='<c:out value="${pageMarker.cri.pageNum}"/>' >
                                    <input type="hidden" name="amount" value='<c:out value="${pageMarker.cri.amount}"/>' >

                                    <button class="btn btn-default">Search</button>
                                </form>
                            </div>
                        </div>

                        <!-- page part -->
                        <div class="pull-right">
                            <ul class="pagination">

                                <c:if test="${pageMarker.prev}">
                                    <li class="paginate_button previous"><a href="${pageMarker.startPage - 1}">Previous</a></li>
                                </c:if>

                                <c:forEach var="num" begin="${pageMarker.startPage}" end="${pageMarker.endPage}">
                                    <li class="paginate_button">
                                        <a class="${pageMarker.cri.pageNum==num ? 'activate' : ''}" href="${num}"><c:out value="${num}" /></a>
                                    </li>
                                </c:forEach>

                                <c:if test="${pageMarker.next}">
                                    <li class="paginate_button next"><a href="${pageMarker.endPage+1}">Next</a></li>
                                </c:if>
                            </ul>
                            <!-- end ul pagination-->


                        </div>
                        <form id="actionForm" action="/board/list" method="get">
                            <input id="pageNum" type="hidden" name='pageNum' value="<c:out value='${pageMarker.cri.pageNum}' />">
                            <input type="hidden" name='amount' value="<c:out value='${pageMarker.cri.amount}' />">
                            <input type="hidden" name="type" value="<c:out value="${pageMarker.cri.type}" />">
                            <input type="hidden" name="keyword" value="<c:out value="${pageMarker.cri.keyword}" />">
                        </form>
                        <!-- modal 추가 -->
                        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title" id="myModalLabel">Modal Title</h4>
                                    </div>
                                    <div class="modal-body">처리가 완료되었습니다.</div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                        <button type="button" class="btn btn-primary" data-dismiss="modal">Save Changes</button>
                                    </div>
                                </div>
                                <!-- modal content end-->
                            </div>
<%--                            modal dialog End--%>
                        </div>
                        <!-- Modal end-->

                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->



<script type="text/javascript">
    $(document).ready(function(){
        let result = '<c:out value="${result}" />';

        checkModal(result);

        history.replaceState({},null,null)

        function checkModal(result){
            if(result === '' || history.state){
                return;
            }

            if(parseInt(result)>0){
                $(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
            }
            $("#myModal").modal("show");
        }

        $(regBtn).on("click", function(){
            self.location = "/board/register";
        });

        let actionForm = $("#actionForm");
        $(".paginate_button a").on("click", function(e){
           e.preventDefault();
           console.log('click! : ' + $(this).attr("href") );

            // $('#pageNum').val($(this).attr("href"));
           actionForm.find('input[name="pageNum"]').val($(this).attr("href"));
           actionForm.submit();
        });

        $(".move").on("click", function (e){
           e.preventDefault();
           actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
           actionForm.attr("action", "/board/get");
           actionForm.submit();

        });

        // 검색 기능
        let searchForm = $("#searchForm");
        $("#searchForm button").on("click", function(e){
           if(!searchForm.find("option:selected").val()){
               alert("검색 종류를 선택하세요");
               console.log('no selected!');
               return false;

           }
           if(!searchForm.find("input[name='keyword']").val()){
               alert("Input Keyword");
                console.log('no keyword!');


               return false;
           }

           searchForm.find("input[name='pageNum']").val("1");
           e.preventDefault();
           searchForm.submit();
        });
    });
</script>


<%@ include file="../includes/footer.jsp"%>