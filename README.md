Scaffolding
===========

Boilerplate for starting my CF - FW/1 - DI/1 projects

I often being new projects with the same basic structure and got tired of creating it manually. This configuration
assumes the entire application needs password protected (the most likely scenario for my purposes), starts with
2 basic subsystems (home, admin). 

Authentication is performed against the local LDAP server. If the user is authenticated with LDAP they have access
to the application. If we need to limit the user to only those who have permission to the current application, then need to
write code for that after successful LDAP authentication. This will need to be done in home/services/security.cfc.

### Before Starting New Project
* Run "bower install" to download front-end dependencies (be sure assets/libs exists)
* Change the reload password in application.cfc for the production environment
* Change the application.projectName and application.dsn variables in application.cfc
* Change/add any necessary information in the /config JSON files (change adminEmail is required)
* Run the db.sql script to create the userLog and failedLogins tables. This file can then be removed from the project