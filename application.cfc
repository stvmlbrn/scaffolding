component extends="org.corfield.framework" {
	//be sure to change this.name for each new project
	this.sessionManagement = true; 
    this.scriptprotect = "all";
    this.name = "AppName-#hash(getCurrentTemplatePath())#"; 
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
    	//Need to set the datasource, and projectName vars. Also be sure to add/change things in the config/*.json files.
    	local.objACPS = createobject("webservice", "http://webservices.allconet.org/acps.cfc?wsdl");

    	application.environment = getEnvironment();
    	applicaion.schoolYear = local.objACPS.schoolYear(now());
    	application.projectName = "Scaffolding";

    	if (application.environment eq "prod") {
    		application.dsn = "scaffolding";
            local.config = expandPath("/config/prod.json");
    	} else if (application.environment eq "dev") {
    		application.dsn = "scaffolding";
            local.config = expandPath("/config/dev.json");
    	}

        application.config = deserializeJSON(fileRead(local.config));

    	local.homeBeanFactory = new ioc("/app/home/services");
    	setSubsystemBeanFactory("home", local.homeBeanFactory);
    	local.adminBeanFactory = new ioc("/app/admin/services");
    	setSubsystemBeanFactory("admin", local.adminBeanFactory);
    }
    // **********************************************************************************************
    function setupRequest() {
    	param name="session.user.isLoggedIn" default="false";

    	local.bypass = "home:security.login";

    	if (listContainsNoCase(local.bypass, request.action) eq 0 && not session.user.isLoggedIn) {
    		local.reqData = getHTTPRequestData();
    		if (structKeyExists(local.reqData.headers, "X-Requested-Width") && local.reqData.headers["X-Requested-With"] eq "XMLHttpRequest") {
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
         savecontent variable="local.body" {
            writeDump(var=session, label="Session Data");
            writeDump(var=cgi, label="CGI Data");
        };

        local.mailer = new mail();
        local.mailer.setTo(application.config.adminEmail);
        local.mailer.setFrom(application.name & " <no-reply@noreply.com>");
        local.mailer.setSubject("404 - Missing Template");
        local.mailer.setType("html");
        local.mailer.send(body=local.body); 
        
        getPageContext().getResponse().setStatus(404);

    	return view("home:error_pages/404");
    }
    // **********************************************************************************************
}