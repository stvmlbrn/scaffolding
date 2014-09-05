$(function() {       
    "use strict";
    $.ajaxSetup({
        cache:false,
        error:function(x,e){
            var sessionTimeout = x.getResponseHeader("sessionTimeout");
            if (sessionTimeout) {
                alert("Your session has expired");
                location.href = "index.cfm?action=home:security.login"; 
            } else {
                alert("An error occurred accessing remote method."); 
            }               
        }
    }); 
});   

var Errors = (function() {
    "use strict";
    var showErrors = function(errors) {
        var str = "Please review the following errors:\n";
        
        $.each(errors,function(i, err) {
            str += "\n- " + err;
        });
        
        alert(str);
    };
    
    return {
        showErrors: showErrors
    };

}());