#my_routes = [File.join(File.dirname(__FILE__), "routes.rb")]
#ArchivesSpace::Application.config.paths['config/routes'].concat(my_routes)
ArchivesSpace::Application.extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))
