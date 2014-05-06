var Errors = (function() {

    var showErrors = function(errors) {
        var str = "Please review the following errors:\n";
        
        $.each(errors,function(i, err) {
            //str += "<li>" + err + "</li>";
            str += "\n- " + err;
        });
        
        alert(str);
    };
    
    return {
        showErrors: showErrors
    };

}());