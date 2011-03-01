class ApplicationController < ActionController::Base
  protect_from_forgery

  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
    config.search.link.label = 'Cauta'
    config.create.link.label = 'Adauga'

    config.show.link.label = 'Detalii'
    config.update.link.label = 'Modifica'
    config.delete.link.label = 'Sterge'
  end
end
