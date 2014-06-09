component extends="org.corfield.framework" {
	//be sure to change this.name for each new project
	this.sessionManagement = true; 
    this.scriptprotect = "all";
    this.name = "AppName-#hash(getCurrentTemplatePath())#"; 
    this.sessionTimeout = createTimeSpan(0,1,0,0);
    this.applicationTimeout = createTimeSpan(0,7,0,0);
    this.setClientCookies = true;  
    // **********************************************************************************************
    function getEnvironment() {
    	if (listFindNoCase(cgi.server_name, "dev", ".")) {
    		return "dev";
    	} else {
    		return "prod";
    	}
    }
    // ********************************************************************************************** 
    variables.framework = {
    	usingSubsystems = true
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
    function setupApplication() {
    	//Need to set the adminEmail, datasource, and projectName vars
    	local.objACPS = createobject("webservice", "http://webservices.allconet.org/acps.cfc?wsdl");

    	application.environment = getEnvironment();
    	application.adminEmail = "";
    	applicaion.schoolYear = local.objACPS.schoolYear(now());
    	application.projectName = "Scaffolding";
    	if (application.environment eq "prod") {
    		application.dsn = "scaffolding";
    	} else if (application.environment eq "dev") {
    		application.dsn = "scaffolding";
    	}

    	local.homeBeanFactory = new ioc("/home/services");
    	setSubsystemBeanFactory("home", local.homeBeanFactory);
    	local.adminBeanFactory = new ioc("/admin/services");
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
    	return view("home:main/404");
    }
    // **********************************************************************************************
}