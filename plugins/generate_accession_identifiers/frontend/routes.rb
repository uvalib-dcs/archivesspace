ArchivesSpace::Application.routes.draw do

  match('/plugins/generate_accession_identifier/generate' => 'generate_accession_identifiers#generate',
        :via => [:post])
  match('/plugins/generate_accession_identifier/default_values' => 'generate_accession_identifiers#default_values', :via => [:get] )

end
