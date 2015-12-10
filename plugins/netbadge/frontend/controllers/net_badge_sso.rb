class NetBadgeSSO
   def self.authorize(  context, request )
      puts "Checking for NetBadge SSO token in request data"

      # NOTE: authentication info can be found in request object here:
      #    NetBadge: request.env['REMOTE_USER']
      #    Shibboleth: request.env['eppon'] and request.env['affiliation'] (email address)

      # NOTE: at the moment NetBadge is not configured, so pretend we are pulling
      # a NetBadge generated UID below by hardcoding one
      uid = "lf6f"
      backend_session = User.login(uid, "#{uid}Password!")
      if backend_session
        User.establish_session(context, backend_session, uid)
        return true
      end

      return false
   end
end
