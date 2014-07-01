component {
	//---------------------------------------------------------------------------
	function recordError(session, exception) {
		local.mailer = new mail();

		savecontent variable="local.body" {
			writedump(var="#arguments.session#", label="Session Data");
			writeoutput("<p>");
			writedump(var="#arguments.exception#", label="Exception Data");	
			writeoutput("</p>");		
		};

		local.mailer.setTo(application.config.adminEmail);
		local.mailer.setFrom("#application.projectName# <no-rely@acps.k12.md.us>");
		local.mailer.setSubject("#application.projectName# Error");
		local.mailer.setType("html");
		local.mailer.send(body=local.body); 
	}
	//---------------------------------------------------------------------------
}