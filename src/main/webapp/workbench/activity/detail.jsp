<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault =true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		// $(".remarkDiv").mouseover(function(){
		// 	$(this).children("div").children("div").show();
		// });
		//
		// $(".remarkDiv").mouseout(function(){
		// 	$(this).children("div").children("div").hide();
		// });
		
		// $(".myHref").mouseover(function(){
		// 	$(this).children("span").css("color","#FF0000");
		// });
		//
		// $(".myHref").mouseout(function(){
		// 	$(this).children("span").css("color","#E6E6E6");
		// });

		// //页面加载完毕后，展现备注列表
		showRemake('${u.id}');

        //添加市场备注
        $("#saveBtn").click(function () {
            var remark = $.trim($("#remark").val());
            if (remark=='' || remark==null){
                alert("添加内容为空！")
                return false
            }
            $.ajax({
                url:"workbench/activity/saveRemark.do",
                type:"get",
                data:{
                    "remark":remark,
                    "id":'${u.id}'
                },
                dataType:"json",
                success:function (data){
                    //data{success: , ar: }
                    var html = "";
                    if(data.success){
                        html+='<div id="'+data.ar.id+'" class="remarkDiv" style="height: 60px;" >'
                        html+='<img title="'+data.ar.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html+='<div style="position: relative; top: -40px; left: 40px;" >'
                        html+='<h5 id="e'+data.ar.id+'">'+data.ar.noteContent+'</h5>'
                        html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${u.name}</b> <small id="_'+data.ar.id+'" style="color: rgb(128,128,128);"> '+data.ar.createTime+'由'+data.ar.createBy+'</small>'
                        html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6; " onclick="editRemark(\''+data.ar.id+'\')"></span></a>'
                        html+='&nbsp;&nbsp;&nbsp;&nbsp;'
                        html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;" onclick="deleteRemark(\''+data.ar.id+'\')"></span></a>'
                        html+='</div>'
                        html+='</div>'
                        html+='</div>'
                        $("#remarkDiv").before(html);
                        $("#remark").val("")
                    }else{
                        alert("添加失败！")
                    }
                }
            })

        })
        //修改操作
        $("#updateRemarkBtn").click(function () {
           var remarkId = $("#remarkId").val();
           var noteContent = $.trim($("#noteContent").val());
           if (noteContent =='' || noteContent ==null){
               alert("修改备注内容不能为空！")
               return false
           }
           $.ajax({
               url:"workbench/activity/updateRemark.do",
               type:"post",
               dataType:"json",
               data:{
                   "id":remarkId,
                   "noteContent":noteContent
               },
               success:function (data) {
                   //data:{success:  , activityRemark(ar):}
                   if (data.success){
                       $("#editRemarkModal").modal("hide");
                       $("#e"+remarkId).html(data.activityRemark.noteContent)
                       $("#_"+remarkId).html(data.activityRemark.editTime+'由'+data.activityRemark.editBy)
                   }else{
                       alert("更新失败！")
                   }
               }
           })
        })
	});
	function showRemake(id) {
		$.ajax({
			url:"workbench/activity/showRemark.do",
			type:"get",
			dataType:"json",
            data:{
              "id":id
            },
			success:function (data) {
				//data:[{remark1},{remark2},{remark3},{remark4}……]
				var html = "";
				$.each(data,function (i, n) {
					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;" >'
					html+='<img title="'+(n.editFlag==0?n.createBy:n.editBy)+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
					html+='<div style="position: relative; top: -40px; left: 40px;" >'
					html+='<h5 id="e'+n.id +'">'+n.noteContent+'</h5>'
					html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${u.name}</b> <small id="_'+n.id+'" style="color: rgb(128,128,128);"> '+(n.editFlag==0?n.createTime:n.editTime)+'由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;" onclick="editRemark(\''+n.id+'\')"></span></a>'
					html+='&nbsp;&nbsp;&nbsp;&nbsp;'
					html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;" onclick="deleteRemark(\''+n.id+'\')"></span></a>'
					html+='</div>'
					html+='</div>'
					html+='</div>'
				})
				$("#remarkDiv").before(html);
            }
		})

        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })
        $("#remarkBody").on("mouseover",".myHref",function () {
            $(this).children("span").css("color","#FF0000")
            // alert(this)
        })
        $("#remarkBody").on("mouseout",".myHref",function () {
            //这个this就是.myHref,而用$(".myHref")没有this就不是.myHref,
            $(this).children("span").css("color","#E6E6E6");
        })
	}

    function deleteRemark(id) {
        if(confirm("确定要删除吗？")){
            $.ajax({
                url:"workbench/activity/deleteRemark.do",
                type:"post",
                data:{
                    "id":id
                },
                dataType:"json",
                success:function (data) {
                    //data:{"success":...,"msg":....}
                    if (data.success){
                        $("#"+id).remove()
                    }
                    alert(data.msg)
                }
            })
        }
    }
    //展现修改市场活动备注的模态窗口
    function editRemark(id) {
        //alert(id)
        //获取内容
        var content= $.trim($("#e"+id).html());
        //模态窗口展示内容
        $("#noteContent").val(content)
        $("#remarkId").val(id)
        $("#editRemarkModal").modal("show");
    }
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body" >
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${u.name} <small>${u.startDate} ~ ${u.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: rgb(128,128,128);">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${u.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: rgb(128,128,128);">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${u.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: rgb(128,128,128);">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${u.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: rgb(128,128,128);">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${u.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: rgb(128,128,128);">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${u.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: rgb(128,128,128);">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${u.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: rgb(128,128,128);">${u.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: rgb(128,128,128);">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${u.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: rgb(128,128,128);">${u.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: rgb(128,128,128);">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${u.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: rgb(128,128,128);"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>

		<!-- 备注2 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: rgb(128,128,128);"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>