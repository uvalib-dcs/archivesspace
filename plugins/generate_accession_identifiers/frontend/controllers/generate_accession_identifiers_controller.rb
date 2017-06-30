#require 'awesome_print'
#require 'pry'

class GenerateAccessionIdentifiersController < ApplicationController

  skip_before_filter :unauthorised_access

  def generate
#   response = JSONModel::HTTP::post_form('/plugins/generate_accession_identifiers/next') 
    response = JSONModel::HTTP::post_form("/plugins/repositories/#{JSONModel.repository}/generate_accession_identifiers/next")

    if response.code == '200'
      render :json => ASUtils.json_parse(response.body)
    else
      render :status => 500
    end
  end

  def default_values
#   Rails.logger.debug( user_prefs.ai )
    render :json => user_prefs['default_values']
  end

end
