module Ym4r
  module GmPlugin
    
    #Class fo the manipulation of the API key
    class ApiKey

      def self.get(options = {})
        SETTLER_LOADED ? Settler[:yahoo_maps_key] : ''
      end
      
    end
  end
end

require 'gm_plugin/mapping'
require 'gm_plugin/map'
require 'gm_plugin/control'
require 'gm_plugin/point'
require 'gm_plugin/overlay'
require 'gm_plugin/layer'
require 'gm_plugin/helper'
require 'gm_plugin/geocoding'
require 'gm_plugin/encoder'

include Ym4r::GmPlugin

