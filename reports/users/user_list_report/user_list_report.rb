
class UserListReport < AbstractReport

  register_report

  def template
    'generic_listing.erb'
  end

  def headers
    [ 'name', 'department', 'groups' ]
  end

  def query

    db[:user].join( :group_user, :user_id => :id ).join( :group, :id => :group_id ).select(
    :name, :department, Sequel.as(  Sequel.function(:GROUP_CONCAT, :description ), :groups )).group_by(:user_id)
    
  end
end
