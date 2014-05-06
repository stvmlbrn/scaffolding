<cfcomponent output="false">
 
 
<cffunction
    name="GetNewResponse"
    access="public"
    returntype="struct"
    output="false"
    hint="I return a new API response struct.">
     
    <!--- Define the local scope. --->
    <cfset var LOCAL = {} />
     
    <!--- Create new API response. --->
    <cfset LOCAL.Response = {
        Success = true,
        Errors = [],
        Data = ""
    } />
     
    <!--- Return the empty response object. --->
    <cfreturn LOCAL.Response />
</cffunction>
 
</cfcomponent>