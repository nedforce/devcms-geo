require_dependency "#{RAILS_ROOT}/vendor/plugins/devcms-core/app/models/node.rb"
require "geokit-rails"

class Node < ActiveRecord::Base
  acts_as_mappable :default_units => :kms
  
  before_save :geocode_location
  
  protected
  def geocode_location
    if self.location.present? && self.location_changed?
      res = Geokit::Geocoders::GoogleGeocoder.geocode(self.location, :bias => GeoKit::Bounds.normalize([[52.2071891, 6.0874344], [52.3164578, 6.3435532]])) 
      self.lat, self.lng, self.location = res.lat, res.lng, res.full_address if res.success
    else
      self.lat, self.lng = nil, nil
    end
  end
end