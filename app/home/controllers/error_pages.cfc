component accessors=true {
	property logErrorsService;
	//------------------------------------------------------------------------------------------
    function init(fw) {
        variables.fw = arguments.fw;
        return this;
    }
    //------------------------------------------------------------------------------------------	
    function error(rc) {
    	getLogErrorsService().recordError(session, request.exception);
    } 
    //------------------------------------------------------------------------------------------	
}