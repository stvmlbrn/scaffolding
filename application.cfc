component extends="framework.one" {
	this.sessionManagement = true;
  this.scriptprotect = "all";
  this.sessionTimeout = createTimeSpan(0,1,0,0);
  this.applicationTimeout = createTimeSpan(0,7,0,0);
  this.setClientCookies = true;
  // **********************************************************************************************
  variables.framework = {
    usingSubsystems = true,
    base = "/app",
    error = "home:error_pages.error"
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
    var homeBeanFactory = new ioc("/app/home/services");
    var adminBeanFactory = new ioc("/app/admin/services");

    application.config = config[getEnvironment()];

    this.datasource = application.config.datasource;
    this.name = application.config.projectName & "-" & hash(getCurrentTemplatePath());

  	setSubsystemBeanFactory("home", homeBeanFactory);
  	setSubsystemBeanFactory("admin", adminBeanFactory);
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
				redirect("home:security.login");
			}
  	}

  	if (getSubSystem() eq "admin" && not session.user.admin) {
  		redirect("home:main.access_denied");
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
