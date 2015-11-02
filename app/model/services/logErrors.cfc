component {
	//---------------------------------------------------------------------------
	function recordError(session, exception) {
		var mailer = new mail();
    var messageBody = "";

		savecontent variable="messageBody" {
			writedump(var="#arguments.session#", label="Session Data");
			writeoutput("<p>");
			writedump(var="#arguments.exception#", label="Exception Data");
			writeoutput("</p>");
		};

		mailer.setTo(application.config.adminEmail);
		mailer.setFrom("#application.config.projectName# <#application.config.adminEmail#>");
		mailer.setSubject("#application.config.projectName# Error");
		mailer.setType("html");
		mailer.send(body = messageBody);
	}
	//---------------------------------------------------------------------------
}
