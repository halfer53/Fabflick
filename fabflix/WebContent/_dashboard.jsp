<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      
     <!-- <script type="text/javascript" src=""></script>  -->
     <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet" href="css/bootstrap-material-design.min.css">
    <link rel="stylesheet" href="css/main.css">
	<script src='https://www.google.com/recaptcha/api.js'></script>
    <title>Movie</title>
      <meta name="description" content="fabflix">
      <meta name="author" content="Bruce Tan">
</head>
<body>
    <div class="container-fluid mb-70">
        <nav class="navbar navbar-default navbar-fixed-top"> 
            <div class="container-fluid"> <div class="navbar-header"> 
                <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-6" aria-expanded="false"> 
                <span class="sr-only">Toggle navigation</span> 
                <span class="icon-bar"></span>
                 <span class="icon-bar"></span> 
                 <span class="icon-bar"></span> 
                 </button> <a href="/fabflix/jsp/Main.jsp" class="navbar-brand">Fabflix</a> 
            </div>
             <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-6"> 
             <ul class="nav navbar-nav"> 
                 <li class="active"><a href="#">Login</a></li> 
                 
             </ul> 
             </div> 
            </div> 
        </nav>
    </div>
    <div id="message">

    </div>
    
    <div class="container">
        <div class="row">
        <form class="col-xs-6 center-block" method="post" action="/fabflix/servlet/EmployeeLogging">
            <div class="form-group label-floating is-empty">
                <label for="username-input" class="control-label">User Name:</label>
                <input type="text" class="form-control" id="username-input" name="user_name">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for="password-input" class="control-label">Password :</label>
                    <input type="password" class="form-control" id="password-input" name="password">
            </div>
            <div class="g-recaptcha" data-sitekey="6LfClCEUAAAAAKx9Ryd_qg2A-bpkP6mhulPgwwnV"></div>
             <input class="btn btn-primary" type="submit"></input>
        </form>
        </div>
    </div>


    

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="js/request.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script src="lib-js/material.min.js"></script>
    <script src="lib-js/ripples.min.js"></script>


    <script >
        $.material.init()
    </script>
    
</body>
</html>