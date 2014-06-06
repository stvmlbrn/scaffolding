<cfcomponent extends="org.corfield.framework">
    
<!---
Be sure to change this.name for each new project.
--->  
<cfscript>
    this.sessionManagement = true; 
    this.scriptprotect = "all";
    this.name = "AppName-#hash(getCurrentTemplatePath())#"; 
    this.sessionTimeout = createTimeSpan(0,1,0,0);
    this.applicationTimeout = createTimeSpan(0,7,0,0);
    this.setClientCookies = true;  
</cfscript>

<cffunction name="getEnvironment">
    <cfif listFindNoCase(cgi.server_name, "dev", ".")>
        <cfreturn "dev" />
    <cfelse>
        <cfreturn "prod" />
    </cfif>
</cffunction>

<cfset variables.framework = {
  usingSubsystems = true
} />

<!--- Be sure to change the reload password for the production environment --->
<cfset variables.framework.environments = {
  dev = {
    reloadApplicationOnEveryRequest = true        
  },
  prod = {
    password = "password"
  }    
} />            
    
<!--------------------------------------------------------------------->    
<cffunction name="setupApplication">
    <!---
    Need to set the adminEmail, datasource, and projectName vars
    --->
    <cfset local.objACPS = createObject("webservice","http://webservices.allconet.org/acps.cfc?wsdl") />
    
    <cfset application.environment = getEnvironment() />
    <cfset application.adminEmail = "" />
    <cfset application.schoolYear = local.objACPS.schoolYear(now()) />
    <cfset application.projectName = "Scaffolding" />
    
    <cfif application.environment eq "prod">
        <cfset application.dsn = "scaffolding" />
    <cfelseif application.environment eq "dev">
        <cfset application.dsn = "scaffolding" />
    </cfif>
    
    <cfset local.homeBeanFactory = new ioc("/home/services") />
    <cfset setSubsystemBeanFactory("home",local.homeBeanFactory) /> 
    <cfset local.adminBeanFactory = new ioc("/admin/services") /> 
    <cfset setSubsystemBeanFactory("admin",local.adminBeanFactory) /> 
    
</cffunction>   
<!--------------------------------------------------------------------->
<cffunction name="setupRequest">    
    <cfparam name="session.user.isLoggedIn" default="false" />
    
    <cfset local.bypass = "home:security.login" />  
    
    <cfif listContainsNoCase(local.bypass, request.action) eq 0 && not session.user.isLoggedIn>
    	<cfset reqData = getHTTPRequestData() />
      <cfif structKeyExists(reqData.headers,"X-Requested-With") && reqData.headers["X-Requested-With"] eq "XMLHttpRequest">
        <cfthrow message="SessionTimeout" />        
      <cfelse>
        <cflocation url="index.cfm?action=security.login" addtoken="false" />
    	  <cfabort />
      </cfif>    	
    </cfif>
    
    <cfif getSubSystem() eq "admin" && not session.user.admin>
      <cfset redirect("home:main.access_denied") />
    </cfif>
    
</cffunction>
<!--------------------------------------------------------------------->
<cffunction name="setupSession">
    <cfset session.user = {
        isLoggedIn = false,
        admin = false
    } />
</cffunction>
<!--------------------------------------------------------------------->
<cffunction name="onMissingView">
   <cfargument name="rc" />
             
   <cfmail from="#application.projectName# <no-reply@acps.k12.md.us>" to="#application.adminEmail#" type="html" subject="404 - Missing Template">            
        Requested View: #rc.action#        
    </cfmail>
    <cfreturn view('home:main/404') />
    
</cffunction>
<!--------------------------------------------------------------------->

</cfcomponent>