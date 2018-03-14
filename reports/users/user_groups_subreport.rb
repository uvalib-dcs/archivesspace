class UserGroupsSubreport < AbstractReport

  def template
    "user_groups_subreport.erb"
  end

  def query
    groups = db[:group_user].select( :group_id ).filter( :user_id => @params.fetch(:user_id))
    db[:group].select( :description, :repo_id ).filter( :id => groups )
  end
  
end
