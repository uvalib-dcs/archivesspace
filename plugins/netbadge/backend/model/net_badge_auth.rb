require 'net/ldap'

# Backend Auth plugin to handle users that have been authenticated by NetBadge.
#
# In this configuration, all URLs of ArchivesSpace are protected by NetBadge, meaning
# that users will not be able to access the site unless their credentials have between
# verified by NetBadge. Once done, the user is considered authenticated and allowed accession
# to the site
#
# Since they are externally authenticated, this auth plugin is mostly a passthru - no need
# to validate credentials. It just returns the JSONModel for the use based on username.
#
# If the user is not found, their details are looked up via LDAP and a new record is created
#
class NetBadgeAuth

   include JSONModel

   def initialize(definition)
      required = [:hostname, :port, :base_dn, :username_attribute, :attribute_map]
      optional = [:bind_dn, :bind_password, :encryption, :extra_filter]

      required.each do |param|
         raise "LDAPAuth: Need a value for parameter :#{param}" if !definition[param]
         instance_variable_set("@#{param}", definition[param])
      end

      optional.each do |param|
         instance_variable_set("@#{param}", definition[param])
      end
   end

   def name
      "NetBadgeAuth"
   end

   def bind
      conn = Net::LDAP.new.tap do |conn|
         conn.host = @hostname
         conn.port = @port

         conn.auth(@bind_dn, @bind_password) if @bind_dn
         conn.encryption(@encryption) if @encryption
      end


      if conn.bind
         @connection = conn
      else
         msg = "Failed when binding to LDAP directory:\n\n#{self.inspect}\n\n"
         msg += "Error: #{conn.get_operation_result.message} (code = #{conn.get_operation_result.code})"
         raise LDAPException.new(msg)
      end
   end

   def find_user(username)
      filter = Net::LDAP::Filter.eq(@username_attribute, username)

      if @extra_filter
         filter = Net::LDAP::Filter.join(Net::LDAP::Filter.construct(@extra_filter), filter)
      end

      @connection.search(:base => @base_dn, :filter => filter).first
   end


   def authenticate(username, password)
      # Build and return a JSONModel(:user) instance from fields in the database
      user = User.find(:username => username)
      return JSONModel(:user).from_hash(:username => username, :name => user.name ) if !user.nil?

      puts "User not found in DB... looking up via LDAP"
      bind
      ldap_user = find_user(username)
      attributes = Hash[@attribute_map.map {|ldap_attribute, aspace_attribute|
         [aspace_attribute, ldap_user[ldap_attribute].first]
         }]
      attributes[:username] = username
      ju = JSONModel(:user).from_hash(attributes)
      User.create_from_json(ju, :source => "local")
      puts "Created new user #{username}"

      # TODO add to group

      return ju
   end
end
