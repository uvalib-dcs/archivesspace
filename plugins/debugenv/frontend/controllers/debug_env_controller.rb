class DebugEnvController < ApplicationController
  
  set_access_control  "administer_system" => [ :index ]

  def index
    
    @app_context = I18n.t("plugins.debug_env.label")

    @info = request.env
    
  end

end
