<cfcomponent output="false" accessors="true">
<!----------------------------------------------------------------------------------------->
<cffunction name="init" output="false">
  <cfargument name="fw" type="any" required="true" />
  <cfset variables.fw = arguments.fw />
    
  <cfreturn this />
</cffunction>  
<!----------------------------------------------------------------------------------------->
<cffunction name="error" output="false">
  <cfargument name="rc" />
  
  <cfmail from="#application.projectName# <no-reply@acps.k12.md.us>" to="#application.adminEmail#" type="html" subject="#application.projectName# Error">
    <h3>Session Data:</h3>
    <cfdump var="#session#" />

    <h3>Exception Data</h3>
    <cfdump var="#request.exception#" />
  </cfmail>
  
</cffunction>
<!----------------------------------------------------------------------------------------->
</cfcomponent>