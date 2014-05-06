<cfcomponent output="false">
<!----------------------------------------------------------------------------------------->
<cffunction name="init" access="public" output="false">
  <cfreturn this />
</cffunction>
<!----------------------------------------------------------------------------------------->
<cffunction name="authenticate" access="public" output="false" returntype="struct">
  <cfargument name="username" type="string" required="yes" />
  <cfargument name="password" type="string" required="yes" />
  <cfargument name="ipAddress" type="string" required="yes" />
  <cfargument name="user_agent" type="string" required="yes" />
  
  <cfset local.authenticated = false />
  <cfset local.user = {} />

  <cfset local.objAD = createObject("webservice", "http://webservices.allconet.org/activeDirectory.cfc?wsdl") />

  <cfif local.objAD.authenticate(arguments.username, arguments.password)> <!--- LDAP authentication successful --->
    <cfset local.employeeNumber = local.objAD.getEmployeeNumber(arguments.username) />
    
    <cfif len(trim(local.employeeNumber))> <!--- make sure the user is a teacher, not a student --->
      <!---
        May need to ensure the user has access to the application by checking a "users" table in the database for this project.
        This boilerplate code assumes that LDAP authentication is enough to access the app. If we need to also check
        that the user has access to the application, the code to do so would go here.
        
        Also may need to add return additional attributes for certain applications. Add them to local.user if needed.
      --->
      <cfset local.details = local.objAD.getUserDetails(local.employeeNumber) />
      <cfset local.user = {
        employeeNumber = local.details.employeeNumber,
        fname = local.details.fname,
        lname = local.details.lname,
        email = local.details.email
      } />
      
      <cfset logUser(arguments.username, local.user.userID, arguments.ipAddress, arguments.user_agent) />   
    </cfif>
    
  <cfelse> <!--- failed LDAP authentication --->
    <cfset failedLogin(arguments.username, arguments.password, arguments.ipAddress, 'LDAP Failed') />
  </cfif>
 
  <cfreturn local.user />

</cffunction>
<!----------------------------------------------------------------------------------------->
<cffunction name="logUser" access="private" output="false" returntype="void">
  <cfargument name="username" type="string" required="yes" />
  <cfargument name="userID" type="numeric" required="yes" />
  <cfargument name="ipAddress" type="string" required="yes" />
  <cfargument name="user_agent" type="string" required="yes" />
  
  <cfquery datasource="#application.dsn#">
    insert into userLog (userID, userName, loginDate, IPAddress, browser) values (
      <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_bigint" />,
      <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" />,
      <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />,
      <cfqueryparam value="#arguments.ipAddress#" cfsqltype="cf_sql_varchar" />,
      <cfqueryparam value="#arguments.user_agent#" cfsqltype="cf_sql_varchar" />
    )
  </cfquery>     
  
</cffunction>
<!----------------------------------------------------------------------------------------->
<cffunction name="failedLogin" access="private" output="false" returntype="void">
  <cfargument name="username" type="string" required="yes" />
  <cfargument name="password" type="string" required="yes" />
  <cfargument name="ipAddress" type="string" required="yes" />
  <cfargument name="reason" type="string" required="yes" />
  
  <cfquery datasource="#application.dsn#">
    insert into failedLogins (userName, password, ipaddress, reason) values (
      <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" />,
      <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar" />,
      <cfqueryparam value="#arguments.ipAddress#" cfsqltype="cf_sql_varchar" />,
      <cfqueryparam value="#arguments.reason#" cfsqltype="cf_sql_varchar" />,
    )
  </cfquery>     
  
</cffunction>
<!----------------------------------------------------------------------------------------->  
</cfcomponent>