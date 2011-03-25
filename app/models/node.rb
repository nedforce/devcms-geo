require_dependency "#{RAILS_ROOT}/vendor/plugins/devcms-core/app/models/node.rb"
require 'geokit-rails'

class Node < ActiveRecord::Base
  acts_as_mappable :default_units => :kms

  validates_presence_of :lng, :lat, :if => :location
  validate :valid_location

  named_scope :geo_coded, { :conditions => 'nodes.lat IS NOT NULL AND nodes.lng IS NOT NULL' }
  named_scope :published_after, lambda { |date| {
    :conditions => ["(publication_start_date >= DATE(:date) OR publication_start_date IS NULL) AND (publication_end_date >= DATE(:date) OR publication_end_date IS NULL)", { :date => date }] }
  }
  named_scope :published_before, lambda { |date| {
    :conditions => ["(publication_end_date <= DATE(:date) OR publication_end_date IS NULL) AND (publication_start_date <= DATE(:date) OR publication_start_date IS NULL)", { :date => date }] }
  }

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
    if address.present? 
      if self.location != address
        begin
          @geocode = Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => Node.geocoding_bias)
        rescue Geokit::TooManyQueriesError
          self.errors.add(:location, I18n.t('nodes.too_many_queries'))
        end

        if @geocode && @geocode.success
          self.lat = @geocode.lat
          self.lng = @geocode.lng
          self.write_attribute(:location, @geocode.full_address)
        end
      end
    else
      self.lat, self.lng = nil, nil
      self.write_attribute(:location, nil)
    end
  end

  private

  def valid_location
    self.errors.add(:location, I18n.t('nodes.invalid_location')) if @geocode.present? && !@geocode.success
  end
end
