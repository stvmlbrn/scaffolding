<cfcomponent output="false" accessors="true">
  <cfproperty name="securityService" />
<!----------------------------------------------------------------------------------------->
<cffunction name="init" output="false">
    <cfargument name="fw" type="any" required="true" />
    <cfset variables.fw = arguments.fw />
    
    <cfreturn this />
</cffunction>  
<!----------------------------------------------------------------------------------------->
<cffunction name="login" output="false">
  <cfargument name="rc" />
  
  <cfparam name="rc.username" default="" />
  
  <cfif isdefined("rc.logout")>
    <cfset session.user.isloggedin = false />
  </cfif>
  
  <cfif len(trim(rc.username)) gt 0>
    <cfset local.args = {
      username = rc.username,
      password = rc.password,
      ipAddress = cgi.remote_addr,
      user_agent = cgi.user_agent
    } />
    <cfset local.user = getSecurityService().authenticate(argumentcollection = local.args) />
    
    <cfif not structIsEmpty(local.user)>
      <cfset session.user = {
        isLoggedIn = true,
        fname = local.user.fname,
        lname = local.user.lname,
        email = local.user.email
      } />      
      <!--- Set other session variables here ---> 
      
      <cfset variables.fw.redirect("main") />      
    </cfif>     
  </cfif>
  
</cffunction>
<!----------------------------------------------------------------------------------------->    
</cfcomponent>