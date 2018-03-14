
class UserGroupsReport < AbstractReport

  register_report

  def template
    'user_groups_report.erb'
  end

  def headers
    [ 'user_id', 'name', 'department', 'title', 'groups' ]
  end

  def query

    #    db[:user].join( :group_user, :user_id => :id ).join( :group, :id => :group_id ).select(
    #    :name, :department, :title, Sequel.as(  Sequel.function(:GROUP_CONCAT, :description ), :groups ), :user_id ).group_by(:user_id)

    db[:user].select( Sequel.as( :id, :user_id ), :name, :department, :title )
    
  end
end
