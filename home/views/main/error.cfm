<cfif structKeyExists(request.exception, "rootcause")>
  <cfif request.exception.rootcause.message eq "SessionTimeout">
	  <cfheader name="sessionTimeout" value="1" />
	  Session Timeout
	  <cfabort />
  </cfif>
</cfif>

<cfmail from="#application.projectName# <no-reply@acps.k12.md.us>" to="#application.adminEmail#" type="html" subject="#application.projectName# Error">
  <h3>Session Data:</h3>
  <cfdump var="#session#" />

  <h3>Exception Data</h3>
  <cfdump var="#request.exception#" />
</cfmail>

<div class="page-header">
	<h3>Error...</h3>
</div>

<p>
	An error occurred while processing your request. The details of the error are below:
	<hr align="left" width="400" />
	<cfoutput>
		#request.exception.cause.message#
	</cfoutput>
</p>