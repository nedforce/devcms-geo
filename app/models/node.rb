require_dependency "#{RAILS_ROOT}/vendor/plugins/devcms-core/app/models/node.rb"
require "geokit-rails"

class Node < ActiveRecord::Base
  acts_as_mappable :default_units => :kms
  
  validates_presence_of :lng, :lat, :if => :location
  validate :valid_location
  
  named_scope :geo_coded, {:conditions => "nodes.lat IS NOT NULL AND nodes.lng IS NOT NULL"}
  
    
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
  
  # Geocode location into lat and lng, also set location field to full address for future reference
  # Set and validation error if the location cannot be geocoded
  def location=(address)
    if address.present? && (self.location.blank? || self.location != address)
      begin
        @geocode = Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => Node.geocoding_bias)
      rescue Geokit::TooManyQueriesError
        self.errors.add(:location, I18n.t("nodes.to_many_queries"))
      end

      if @geocode.success
        self.lat = @geocode.lat
        self.lng = @geocode.lng
        self.write_attribute(:location, @geocode.full_address)
      end
    else
      self.lat, self.lng = nil, nil
      self.write_attribute(:location, nil)
    end
  end
  
  private
  def valid_location
    self.errors.add(:location, I18n.t("nodes.invalid_location")) if @geocode.present? && !@geocode.success
  end
end