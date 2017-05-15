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



				<div class="contentpanel">
					<ul class="nav nav-tabs nav-dark">
						<li class="active"><a data-toggle="tab" href="#all"><strong>Detail
									Info of Voice Actor</strong></a></li>
					</ul>
					<div class="tab-content">
						<div id="all" class="tab-pane active">
							<div class="alert alert-info fade in">
								<button type="button" class="close" data-dismiss="alert"
									aria-hidden="true">&times;</button>
								<div>
									<span style="font-size: 1.4em; line-height: 50px;">Enter
										a movie with Voice Actor | Movie Inforation | Genre</span>
								</div>
							</div>

							<div class="panel panel-default">
								<div class="panel-heading">
									<div class="panel-btns">
										<a href="" class="panel-close">&times;</a> <a href=""
											class="minimize">&minus;</a>
									</div>
									<h4 class="panel-title">Basic Information</h4>
									<p>【id】【Title】【Director】【Genre】【Voice Actor】</p>
								</div>

								<form name="myForm" method="POST"
									action="<%=basePath%>AdminServlet?method=addMovie"
									class="form-horizontal form-bordered">
									<div class="panel-body panel-body-nopadding">


										<div class="form-group">
											<label class="col-sm-3 control-label" for="disabledinput">Movie
												Id</label>
											<div class="col-sm-6">
												<input type="text" value="" placeholder="provided by server"
													id="disabledinput" class="form-control" disabled="disabled" />
											</div>
										</div>

										<div class="form-group">
											<label class="col-sm-3 control-label">Movie Title: </label>
											<div class="col-sm-6">
												<input type="text" id="title" name="title"
													placeholder="up to 100 words" class="form-control" />
											</div>
										</div>
										
										<div class="form-group">
											<label class="col-sm-3 control-label">Movie Year: </label>
											<div class="col-sm-6">
												<input  class="date-picker-year" type="text" id="year" name="year"
													placeholder="up to 4 words" class="form-control" />
											</div>
										</div>


										<div class="form-group">
											<label class="col-sm-3 control-label">Director : </label>
											<div class="col-sm-6">
												<input type="text" id="director" name="director"
													placeholder="up to 100 words" class="form-control" />
											</div>
										</div>

										<div class="form-group">
											<label class="col-sm-3 control-label">Voice Star
												Name(first): </label>
											<div class="col-sm-6">
												<input type="text" id="first_name" name="first_name"
													placeholder="up to 200 words" class="form-control" />
											</div>


										</div>
										<div class="form-group">
											<label class="col-sm-3 control-label">Voice Star
												Name(last): </label>
											<div class="col-sm-6">
												<input type="text" id="last_name" name="last_name"
													placeholder="up to 200 words" class="form-control" />
											</div>
										</div>
										<div class="form-group">
											<label class="col-sm-3 control-label">Genre: </label>
											<div class="col-sm-6">
												<input type="text" placeholder="up to 50 words" id="genre"
													name="genre">
											</div>
										</div>
									</div>
									<!-- panel-body -->

									<div class="row">
										<div class="col-sm-12" align="center">
											<p>${message}</p>
											<button id="but_submit_stadium" type="submit"
												class="btn btn-primary" onclick="return addMovieCheck()">submit</button>
											&nbsp;

										</div>
									</div>
								</form>
								<div class="panel-footer">
									<div class="row"></div>
								</div>
								<!-- panel-footer -->

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
	$(function() {
		$('.date-picker-year')
				.datepicker(
						{
							changeYear : true,
							showButtonPanel : true,
							dateFormat : 'yy',
							onClose : function(dateText, inst) {
								var year = $(
										"#ui-datepicker-div .ui-datepicker-year :selected")
										.val();
								$(this)
										.datepicker('setDate',
												new Date(year, 1));
							}
						});
		$(".date-picker-year").focus(function() {
			$(".ui-datepicker-month").hide();
		});
	});
	function clear() {
		alert(1);
		document.getElementById("first_name").reset();
		document.getElementById("last_name").reset();
		alert(3);
		document.getElementById("title").reset();
		document.getElementById("year").reset();
		alert(4);
		document.getElementById("director").reset();
		document.getElementById("genre").reset();
		alert(5);
		return false;
	}
	function addMovieCheck() {
		var flag = true;
		var message = "";
		if (myForm.last_name.value == null || myForm.last_name.value == "") {
			message = "please fill in last name";
			flag = false;
		}
		if (myForm.year.value == null || myForm.year.value == "") {
			message = "please fill in the year";
			flag = false;
		}

		if (myForm.title.value == null || myForm.title.value == "") {
			message = "please fill in the movie title";
			flag = false;
		}

		if (myForm.director.value == null || myForm.director.value == "") {
			message = "please fill in the director";
			flag = false;
		}

		if (myForm.genre.value == null || myForm.genre.value == "") {
			message = "please fill the movie genre";
			flag = false;
		}

		if (!flag) {
			alert(message);
			return false;
		}
		return true;
	}
</script>
</html>