component accessors=true {
 	property securityService;
  	//------------------------------------------------------------------------------------------
  	function init(fw) {
    	variables.fw = arguments.fw;
    	return this;
	}
  	//------------------------------------------------------------------------------------------
  	function login(rc) {
  		param name = "rc.username" default = "";

  		if (isdefined("rc.logout")) {
  		 	session.user.isLoggedIn = false;
  		}

  		if (len(trim(rc.username)) gt 0) {
	  		local.args = {
	  			username = rc.username,
	  			password = rc.password,
	  			ipAddress = cgi.remote_addr,
	  			user_agent = cgi.user_agent
	  		};

	  		local.user = getSecurityService().authenticate(argumentcollection = local.args);

	  		if (!structIsEmpty(local.user)) {
	  			session.user = {
	  				isLoggedIn = true,
	  				fname = local.user.fname,
	  				lname = local.user.lname,
	  				email = local.user.email
	  				//set other session variables here.
	  			};

	  			variables.fw.redirect("main");
	  		}
  		}
  	}
  	//------------------------------------------------------------------------------------------
}
