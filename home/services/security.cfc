component {
	public struct function init() {
		return this;
	}
	//-----------------------------------------------------------------------------------------
	public struct function authenticate(string username, string password, string ipAddress, string user_agent) {
		local.authenticated = false;
		local.user = {};
		local.objAD = createObject("webservice","http://webservices.allconet.org/activeDirectory.cfc?wsdl");

		if (local.objAD.authenticate(arguments.username, arguments.password)) { //LDAP authentication successful
			local.employeeNumber = local.objAD.getEmployeeNumber(arguments.username);
			if (len(trim(local.employeeNumber))) { //make sure user is a teacher, not a student
				/* 
				May need to ensure the user has access to the application by checking a "users" table in the database for this project.
		        This boilerplate code assumes that LDAP authentication is enough to access the app. If we need to also check
		        that the user has access to the application, the code to do so would go here.
		        
		        Also may need to add return additional attributes for certain applications. Add them to local.user if needed.
				*/
				local.details = local.objAD.getUserDetails(local.employeeNumber);
				local.user = {
					employeeNumber = local.details.employeeNumber,
					fname = local.details.fname,
					lname = local.details.lname,
					email = local.details.email
				};

				logUser(arguments.username, local.user.employeeNumber, arguments.ipAddress, arguments.user_agent);
			}
		} else { //LDAP authentication failed
			failedLogin(arguments.username, arguments.password, arguments.ipAddress, 'LDAP Failed');
		}

		return local.user;
	}
	//-----------------------------------------------------------------------------------------
	private void function logUser(string username, string userID, string ipAddress, string user_agent) {
		local.query = new Query();
		local.sql = "insert into userLog (userID, userName, IPAddress, user_agent) values (:userID, :userName, :ipAddress, :user_agent)";
		local.query.setAttributes({"datasource" = application.dsn, "sql" = local.sql});
		local.query.addParam(name="userID", value=arguments.userID, cfsqltype="cf_sql_varchar");
		local.query.addParam(name="userName", value=arguments.username, cfsqltype="cf_sql_varchar");
		local.query.addParam(name="ipAddress", value=arguments.ipAddress, cfsqltype="cf_sql_varchar");
		local.query.addParam(name="user_agent", value=arguments.user_agent, cfsqltype="cf_sql_varchar");
		local.query.execute();
	}
	//-----------------------------------------------------------------------------------------
	private void function failedLogin(string username, string password, string ipAddress, string reason) {
		local.query = new Query();
		local.sql = "insert into failedLogins (userName, password, IPAddress, reason) values (:userName, :password, :ipAddress, :reason)";
		local.query.setAttributes({"datasource" = application.dsn, "sql" = local.sql});
		local.query.addParam(name="userName", value=arguments.username, cfsqltype="cf_sql_varchar");
		local.query.addParam(name="password", value=arguments.password, cfsqltype="cf_sql_varchar");
		local.query.addParam(name="ipAddress", value=arguments.ipAddress, cfsqltype="cf_sql_varchar");
		local.query.addParam(name="reason", value=arguments.reason, cfsqltype="cf_sql_varchar");
		local.query.execute();
	}
}
