<cfif structKeyExists(request.exception, "rootcause")>
  <cfif request.exception.rootcause.message eq "SessionTimeout">
	  <cfheader name="sessionTimeout" value="1" />
	  Session Timeout
	  <cfabort />
  </cfif>
</cfif>

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