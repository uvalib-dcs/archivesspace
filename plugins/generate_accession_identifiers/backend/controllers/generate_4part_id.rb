require 'time'
#require 'awesome_print'
#require 'pry'

class ArchivesSpaceService < Sinatra::Base

  # frontend controller now calls the endpoint below, not this one.
  Endpoint.post('/plugins/generate_accession_identifiers/next')
    .description("Generate a new identifier based on the year and a running number")
    .params()
    .permissions([])
    .returns([200, "{'year', 'YYYY', 'number', N}"]) \
  do
    year = Time.now.strftime('%Y')
    number = Sequence.get("GENERATE_ACCESSION_IDENTIFIER_#{year}")

    json_response(:year => year, :number => number)
  end


  Endpoint.post( '/plugins/repositories/:repo_id/generate_accession_identifiers/next' )
  .description("Generate a new identifier based on the :repo_id, year and a running number")
  .params(["repo_id", :repo_id])
  .permissions([])
  .returns([200, "{'repo_id' :repo_id, 'year', 'YYYY', 'number', N}"]) \
do
  other_id = nil
  repo = Repository.find( :id => params[:repo_id].to_i ).values
  org_code = repo[:org_code] || repo[:repo_code]
  year = Time.now.strftime('%Y')
  number = Sequence.get("GENERATE_ACCESSION_IDENTIFIER_#{org_code}_#{year}")
  if number == 0  # we don't want zero based sequence numbers; start with 1 
    number = Sequence.get("GENERATE_ACCESSION_IDENTIFIER_#{org_code}_#{year}")
  end
  identifier = [ org_code, year, sprintf( "%04d", number), nil ].to_json  # Format string here ("%04d") must match padding in javascript! 
  Log.debug( "@@@@@@@@@@@@@@ Generate Accession Identifiers @@@@@@@@@@@@@@@@@")
  Log.debug( "identifier => #{identifier}")
  DB.open(true) do |db|
    other = db[:accession].filter( :repo_id => params[:repo_id].to_i )
    Log.debug( "accession :repo_id => #{params[:repo_id].to_i} Count = #{other.count}" )
#    Log.debug  (other.all.collect { |x| x[:identifier] }).ai
    other = db[:accession].filter( :identifier => identifier )
    Log.debug( "accession :identifier => #{identifier} Count = #{other.count}")
#    Log.debug other.all.ai
    (1..20).each do |i|
      break if db[:accession].filter( :repo_id => params[:repo_id].to_i, :identifier => identifier ).count == 0 
      other_id = db[:accession].filter( :repo_id => params[:repo_id].to_i, :identifier => identifier ).get( :identifier )
      number = Sequence.get("GENERATE_ACCESSION_IDENTIFIER_#{org_code}_#{year}")
      Log.debug "@@@@@@@@@@@@ Duplicate Identifier: #{identifier} -- Incrementing number #{number} "
      identifier = [ org_code, year, sprintf( "%04d", number), nil ].to_json  # Format string here ("%04d") must match padding in javascript! 
      Log.debug( "identifier => #{identifier}")
    end
  end
  json_response(:org_code => org_code, :year => year, :number => number, :identifier => identifier )
end
  

end
