require 'devcms_core'
require 'geokit'
require 'geokit-rails'

module DevcmsGeo
  extend ActiveSupport::Autoload

  autoload :StaticMap
end

require 'devcms_geo/engine'
