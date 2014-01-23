module Music
  class Engine < ::Rails::Engine
    isolate_namespace Music

    #to avoid copy engine migration to main app migration, just tell the main app that there is migration in this engine
    #see: http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    require 'rubygems'
    require 'activerecord-tableless'
    require 'cancan'
  end
end
