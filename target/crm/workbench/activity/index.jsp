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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		//日历挂件
		$(".time").datetimepicker({
			minView:"month",
			language:'zh-CN',
			format:'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//创建市场活动的模态窗口中用户列表展示
		$("#addBtn").click(function () {
			// alert("123")
			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
					data:[{用户1},{用户2},{用户3}……]
					 */
					var html = ""
					//循环遍历
					$.each(data,function (i,n){
						html+="<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-owner").html(html);
					var id = "${User.id}"
					//默认选中为登录的
					$("#create-owner").val(id)
				}
			})
			//点击完毕后展示模态窗口
			$("#createActivityModal").modal("show");
		})

		//保存市场活动，添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/activity/save.do",
				data:{
					"owner" : $.trim($("#create-owner").val()),
					"name" :$.trim($("#create-name").val()),
					"startDate" :$.trim($("#create-startDate").val()),
					"endDate" :$.trim($("#create-endDate").val()),
					"cost" :$.trim($("#create-cost").val()),
					"description" :$.trim($("#create-description").val())
				},
				type:"post",
				dataType: "json",
				success:function (data) {
					//flag:success
					if (data.success){
						//刷新市场活动信息列表
						// $("#activityAddForm")[0].reset()
						//关闭窗口
						$("#createActivityModal").modal("hide");
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert("保存失败！未知错误")
					}
				}
			})
		})
		pageList(1,2);
		$("#searchBtn").click(function () {
			$("#hidden-name").val($.trim($.trim($("#search-name").val())))
			$("#hidden-owner").val($.trim($.trim($("#search-owner").val())))
			$("#hidden-startDate").val($.trim($.trim($("#search-startDate").val())))
			$("#hidden-endDate").val($.trim($.trim($("#search-endDate").val())))

			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
		})
		//全选操作
		$("#zx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//动态生成的元素 不能以普通的方式绑定事件；以on的方式
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			$("#zx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		//删除操作
		$("#deleteBtn").click(function () {
			//前端往后端传个id=xxxxx&id=xxxxx……
			if (confirm("确定要删除吗？")){
				//获取id
				var $xz = $("input[name=xz]:checked");
				var id = ""
				$.each($xz,function (i, n) {
					id+="id="+n.value;
					if (i<$xz.length-1){
						id+="&"
					}
				})
				//一次只能修改一个
				if ($xz.length==0){
					alert("没有选择删除项")
				}else {
					$.ajax({
						url:"workbench/activity/delete.do",
						data:id,
						dataType:"json",
						type:"post",
						success:function (data) {
							/*
                            data:success,msg
                             */
							if (data.success){
								alert(data.msg)
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								alert(data.msg)
							}

						}
					})
				}
			}
		})
		//打开修改页面
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			var id ="id="+$xz.val();
			if($xz.length!=1){
				alert("每次修改只能修改一个")
			}else{
				$.ajax({
					url:"workbench/activity/getUserListAndActivity.do",
					type:"get",
					dataType:"json",
					data:id,
					success:function (data) {
						/*
						data:{"u":[{},{},{}],"a":activity对象}
						 */
						var html = "";
						$.each(data.u,function (i, n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>"
						})
						$("#edit-owner").html(html);
						$("#edit-owner").val(data.a.owner);//默认选项
						$("#edit-name").val(data.a.name);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-cost").val(data.a.cost);
						$("#edit-description").val(data.a.description);
						$("#editActivityModal").modal("show");
					}
				})
			}
		})
		//市场活动修改操作
		$("#updateBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			var id = $xz.val();
			$.ajax({
				url:"workbench/activity/update.do",
				data:{
					"id":id,
					"owner" : $.trim($("#edit-owner").val()),
					"name" :$.trim($("#edit-name").val()),
					"startDate" :$.trim($("#edit-startDate").val()),
					"endDate" :$.trim($("#edit-endDate").val()),
					"cost" :$.trim($("#edit-cost").val()),
					"description" :$.trim($("#edit-description").val())
				},
				type:"post",
				dataType: "json",
				success:function (data) {
					//flag:success
					if (data.success){
						//刷新市场活动信息列表
						// $("#activityAddForm")[0].reset()
						//关闭窗口
						alert("修改成功")
						$("#editActivityModal").modal("hide");
						//参数由bootstrap提供：第一个是停留在当前页，第二个是保存当前设置的行数
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage'),$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

					}else{
						alert("修改失败！")
					}
				}
			})
		})
	});

	//生成市场活动列表
	function pageList(pageNo,pageSize){
		//将隐藏域中的值拿出
		$("#search-name").val($("#hidden-name").val())
		$("#search-owner").val($("#hidden-owner").val())
		$("#search-startDate").val($("#hidden-startDate").val())
		$("#search-endDate").val($.trim($("#hidden-endDate").val()))
		$.ajax({
			url:"workbench/activity/pageList.do",
			type:"get",
			dataType:"json",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val()),
			},
			success:function (data) {
				/*
					data: {"total":100,[{市场活动1},{市场活动2}……]}
				 */

				var html = ""
				$.each(data.pagelist,function (i, n) {
					html+=' <tr className="active">'
					html+=' <td><input type="checkbox" value="'+n.id+'" name="xz"/></td>'
					html+=' <td><a style="text-decoration: none; cursor: pointer;" onClick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>'
					html+=' <td>'+n.owner+'</td>'
					html+=' <td>'+n.startDate+'</td>'
					html+=' <td>'+n.endDate+'</td>'
					html+=' </tr>'
				})
				$("#activityBody").html(html)
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//分页插件：
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo:false,
					showRowsDefaultInfo:false,
					//点击分页插件的按钮 会自动调用此方法，我们自己写的
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}

		})
	}
</script>
</head>
<body>
	<%--隐藏域，防止分页查询问题--%>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85% ;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate"readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">

						<%--
							data-dismiss="modal"
							关闭模态窗口
						--%>

					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startDate"  >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endDate"  >
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
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate" >
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="zx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
		</div>
		
	</div>
</body>
</html>