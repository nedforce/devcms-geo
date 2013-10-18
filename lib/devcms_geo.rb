require 'devcms_core'
require 'geokit'
require 'geokit-rails'
require 'rmagick'

module DevcmsGeo
  extend ActiveSupport::Autoload
  
  autoload :StaticMap
end

require 'devcms_geo/engine'
