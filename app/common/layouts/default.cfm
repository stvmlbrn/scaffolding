<!DOCTYPE html> <!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <cfif application.environment eq "prod">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    </cfif>
    <cfoutput>
    <title><cfoutput>#application.projectName#</cfoutput></title>
    </cfoutput>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    
    
    <link rel="stylesheet" href="/assets/libs/html5-boilerplate/css/normalize.css">
    <link rel="stylesheet" href="/assets/libs/bootstrap/dist/css/bootstrap.css" />
    <link rel="stylesheet" href="/assets/css/main.css" />
    <link rel="stylesheet" href="/assets/libs/font-awesome/css/font-awesome.min.css" />
    
    <!--- <link rel="icon" type="image/png" href="/assets/img/appIcon.png" /> --->
    <script type="text/javascript" src="/assets/libs/jquery/dist/jquery.min.js"></script>
    <script type="text/javascript" src="/assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/assets/libs/handlebars/handlebars.min.js"></script>
    <script type="text/javascript" src="/assets/js/errors.js"></script>
    <script type="text/javascript">
      $(function() {		 
        $.ajaxSetup({
          error:function(x,e){
            var sessionTimeout = x.getResponseHeader("sessionTimeout");
            if (sessionTimeout) {
                alert("Your session has expired");
                location.href = "index.cfm?action=home:security.login";	
            } else {
                alert("An error occurred accessing remote method."); 
            }				
           }
        });	
      });	
    </script>
    
</head>

<body>
    <div class="container">
    <!--[if lt IE 8]>
        <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->
      <div class="row">
        <div class="col-md-6">
           <a href="/"><img src="/assets/img/acps.jpg" /></a>
        </div>
        
        <div class="col-md-6">
          <cfif rc.action neq "home:security.login">
          <span class="pull-right"><a href="index.cfm?action=home:security.login&logout"><i class="fa fa-sign-out"></i> Logout</a></span>
          </cfif>
        </div>
      </div>        
      
      <cfoutput>#body#</cfoutput>          
    </div>
</body>
</html>