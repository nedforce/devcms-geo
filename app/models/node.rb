require_dependency "#{RAILS_ROOT}/vendor/plugins/devcms-core/app/models/node.rb"
require "geokit-rails"

class Node < ActiveRecord::Base
  acts_as_mappable :default_units => :kms
  
  named_scope :geo_coded, {:conditions => "nodes.lat IS NOT NULL AND nodes.lng IS NOT NULL"}
  
  before_save :geocode_location
  
  # Get the geocoding bias from settings, or default to NL
  def self.geocoding_bias
    if SETTLER_LOADED
      bias = Settler[:geocode_bias]
      if bias.present?
        bias = GeoKit::Bounds.normalize(bias) rescue 'NL'
      end
    end
    return bias.present? ? bias : 'NL'
  end
  
  protected
  # Geocode location into lat and lng, also set location field to full address for future reference
  # Set and validation error if the location cannot be geocoded
  def geocode_location
    if self.location.present? && (self.location_changed? || self.lat.blank? || self.lng.blank?)
      res = Geokit::Geocoders::GoogleGeocoder.geocode(self.location, :bias => Node.geocoding_bias)
      if res.success
        self.lat = res.lat
        self.lng = res.lng
        self.location = res.full_address
      else
        self.errors.add_to(:location, I18n.t("nodes.invalid_location"))
      end
    else
      self.lat, self.lng = nil, nil
    end
  end
end