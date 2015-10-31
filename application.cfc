component extends="framework.one" {
	this.sessionManagement = true;
  this.scriptprotect = "all";
  this.sessionTimeout = createTimeSpan(0,1,0,0);
  this.applicationTimeout = createTimeSpan(0,7,0,0);
  this.setClientCookies = true;
  // **********************************************************************************************
  variables.framework = {
    base = "/app",
    error = "error_pages.error",
    diLocations = ["app/model"]
  };
  // **********************************************************************************************
  variables.framework.environments = {
    dev = {
      reloadApplicationOnEveryRequest = true
    },
    prod = {
      password = "password" //Be sure to change the reload password
    }
  };
  // **********************************************************************************************
  function getEnvironment() {
  	if (listFindNoCase(cgi.server_name, "dev", ".")) {
  		return "dev";
  	} else {
  		return "prod";
  	}
  }
  // **********************************************************************************************
  function setupApplication() {
    var config = deserializeJSON(fileRead(expandPath("/config/config.json")));

    application.config = config[getEnvironment()];

    this.datasource = application.config.datasource;
    this.name = application.config.projectName & "-" & hash(getCurrentTemplatePath());
  }
  // **********************************************************************************************
  function setupRequest() {
  	param name="session.user.isLoggedIn" default="false";
    var bypass = "home:security.login";
    var reqData = "";

  	if (listContainsNoCase(bypass, request.action) eq 0 && (not session.user.isLoggedIn or structKeyExists(session,"user") eq 0)) {
  		reqData = getHTTPRequestData();
  		if (structKeyExists(reqData.headers, "X-Requested-With") && reqData.headers["X-Requested-With"] eq "XMLHttpRequest") {
  			throw(message="SessionTimeout");
			} else {
				redirect("security.login");
			}
  	}
  }
  // **********************************************************************************************
  function setupSession() {
  	session.user = {
  		isLoggedIn = false,
  		admin = false
  	};
  }
  // **********************************************************************************************
  function onMissingView(rc) {
    var messageBody = "";
    var mailer = new mail();

    savecontent variable="messageBody" {
        writeDump(var=session, label="Session Data");
        writeDump(var=cgi, label="CGI Data");
    };

    mailer = new mail();
    mailer.setTo(application.config.adminEmail);
    mailer.setFrom(application.config.projectName & " <no-reply@noreply.com>");
    mailer.setSubject("404 - Missing Template");
    mailer.setType("html");
    mailer.send(body = messageBody);

    getPageContext().getResponse().setStatus(404);

  	return view("home:error_pages/404");
  }
  // **********************************************************************************************
}
