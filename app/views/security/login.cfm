<cfoutput>
  <div class="row">
    <div class="col-md-5">
      <div class="page-header">
        <h2><cfoutput>#application.config.projectName#</cfoutput></h2>
      </div>
      Unauthorized access to this software is prohibited.
      <p>
        &copy;#year(now())# Allegany County Public Schools.
      </p>
    </div>
    <div class="col-md-4 col-md-offset-1">
      <form role="form" class="form-horizontal" id="loginForm" method="post" action="#buildURL('security.login')#">
        <div class="form-group">
          <label form="username" class="control-label col-md-3">Username</label>
          <div class="col-md-6">
            <input type="text" name="username" id="username" class="form-control col-md-6" autofocus />
          </div>
        </div>
        <div class="form-group">
          <label form="password" class="control-label col-md-3">Password</label>
          <div class="col-md-6">
            <input type="password" name="password" id="password" class="form-control col-md-6" />
          </div>
        </div>
        <div class="form-group">
          <div class="col-md-6 col-md-offset2">
            <button type="submit" class="btn btn-default"><i class="glyphicon glyphicon-user"></i> Log In</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>

