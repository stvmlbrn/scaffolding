component accessors=true {
 	property securityService;
	//------------------------------------------------------------------------------------------
	function init(fw) {
  	variables.fw = fw;
    return this;
	}
	//------------------------------------------------------------------------------------------
	function login(rc) {
		param name = "rc.username" default = "";
    var args = {};
    var user = "";

		if (isdefined("rc.logout")) {
		 	session.user.isLoggedIn = false;
		}

		if (len(trim(rc.username)) gt 0) {
  		args = {
  			username = rc.username,
  			password = rc.password,
  			ipAddress = cgi.remote_addr,
  			user_agent = cgi.user_agent
  		};

      user = variables.securityService.authenticate(argumentcollection = args);

  		if (!structIsEmpty(user)) {
  			session.user = {
  				isLoggedIn = true,
  				admin = false,
  				fname = user.fname,
  				lname = user.lname,
  				email = user.email
  				//set other session variables here.
  			};

  			variables.fw.redirect("main");
  		}
    }
  }
	//------------------------------------------------------------------------------------------
}
