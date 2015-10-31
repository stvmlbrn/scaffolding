component accessors=true {
	property logErrorsService;
  //------------------------------------------------------------------------------------------
  function init(fw) {
    variables.fw = fw;
  }
  //------------------------------------------------------------------------------------------
  function error(rc) {
    if (structKeyExists(request.exception, "rootcause")) {
      if (request.exception.rootcause.message eq "SessionTimeout") {
        getPageContext().getResponse().setHeader("sessionTimeout","1");
        abortController();
      }
    }
  	variables.logErrorsService.recordError(session, request.exception);
  }
  //------------------------------------------------------------------------------------------
}
