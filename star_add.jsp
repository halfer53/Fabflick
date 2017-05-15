<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String serverPath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ "/";
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Fabflix</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

<%@ include file="base/common2.jsp"%>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$(function() {
		$("#datepicker").datepicker();
	});
</script>
</head>

<body>
	<section>
		<!-- 【】 -->
		<jsp:include page="menu/admin_manage_user_admin.jsp" />
		<div class="mainpanel">
			<!-- 【】 -->
			<jsp:include page="base/base_headPanel.jsp" />
			<div class="pageheader">
				<h2>
					<i class="fa fa-home"></i>Fabflix Cartoon Voice Actor Add<span><a
						href="javascript:history.back(-1)">back</a></span>
				</h2>
				<div class="breadcrumb-wrapper">
					<span class="label">Fabflix Cartoon Copyright</span>
					<ol class="breadcrumb">
						<li>Web Application</li>
						<li><a href="<%=basePath%>view/help">Help</a></li>
					</ol>
				</div>
			</div>



			<div class="contentpanel">
				<ul class="nav nav-tabs nav-dark">
					<li class="active"><a data-toggle="tab" href="#all"><strong>Please
								fill in Detail Info of Voice Actor</strong></a></li>
				</ul>
				<div class="tab-content">
					<div id="all" class="tab-pane active">
						<div class="alert alert-info fade in">
							<button type="button" class="close" data-dismiss="alert"
								aria-hidden="true">&times;</button>
							<div>
								<span style="font-size: 1.4em; line-height: 50px;">Please
									enter the basic configuration information</span>
							</div>
						</div>

						<div class="panel panel-default">
							<div class="panel-heading">
								<div class="panel-btns">
									<a href="" class="panel-close">&times;</a> <a href=""
										class="minimize">&minus;</a>
								</div>
								<h4 class="panel-title">Basic Configuration</h4>
								<p>【id】【first_name】【last_name】【date of birth】【photo_url】</p>
							</div>

							<form name="myForm" method="POST"
								action="<%=basePath%>AdminServlet?method=addStar"
								class="form-horizontal form-bordered">
								<div class="panel-body panel-body-nopadding">


									<div class="form-group">
										<label class="col-sm-3 control-label" for="disabledinput">Voice
											Actor Id</label>
										<div class="col-sm-6">
											<input type="text" value="" placeholder="provided by server"
												id="disabledinput" class="form-control" disabled="disabled" />
										</div>
									</div>

									<div class="form-group">
										<label class="col-sm-3 control-label">first_name</label>
										<div class="col-sm-6">
											<input type="text" id="first_name" name="first_name"
												placeholder="up to 50 words" class="form-control" />
										</div>
									</div>

									<div class="form-group">
										<label class="col-sm-3 control-label">last_name</label>
										<div class="col-sm-6">
											<input type="text" id="last_name" name="last_name"
												placeholder="up to 50 words" class="form-control" />
										</div>
									</div>

									<div class="form-group">
										<label class="col-sm-3 control-label">date of birth</label>
										<div class="col-sm-6">
											<input type="text" id="datepicker" name="dob">
										</div>
									</div>



									<div class="form-group">
										<label class="col-sm-3 control-label">photo_url </label>
										<div class="col-sm-6">
											<input type="text" id="photo_url" name="photo_url"
												placeholder="up to 200 words" class="form-control" />
										</div>
									</div>



								</div>
								<!-- panel-body -->

								<div class="panel-footer">
									<div class="row">
										<div class="col-sm-12" align="center">
											<p>${message}</p>
											<button id="but_submit_stadium" type="submit"
												class="btn btn-primary" onclick="return loginCheck()">submit</button>
											&nbsp;
										</div>
									</div>
								</div>
								<!-- panel-footer -->
							</form>
						</div>
						<!-- panel -->

					</div>
					<!-- tab-pane -->

				</div>
			</div>

			<jsp:include page="base/base_rightPanel.jsp" />
	</section>
	<%@ include file="base/base_preLoader.jsp"%>

</body>
<script type="text/javascript">
	function reset() {
		document.getElementById("first_name").reset();
		document.getElementById("last_name").reset();
		document.getElementById("dob_name").reset();
		return false;
	}
	function loginCheck() {
		var flag = true;
		if (myForm.first_name.value == null || myForm.first_name.value == "") {
			flag = false;
		}
		if (myForm.last_name.value == null || myForm.last_name.value == "") {
			flag = false;
		}
		if (myForm.dob.value == null || myForm.dob.value == "") {
			flag = false;
		}

		if (!flag) {
			alert("please fill up all the first name, last name and date of birth");
			return false;
		}
		return true;

	}
</script>
</html>