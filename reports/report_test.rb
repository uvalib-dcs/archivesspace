# helper function for debugging my reports
require 'awesome_print'
ap ReportRunner.reports

def report_html( fname, rclass )
  db = DB.instance_variable_get( :@default_pool ).instance_variable_get( :@pool ) 
  params = { :repo_id => 3, :format => "html" }  
  r = rclass.new( params, Job.new, db )
  File.open( fname, 'w' ) { |w| w.write( ReportResponse.new(r).generate ) }
  fname
end
