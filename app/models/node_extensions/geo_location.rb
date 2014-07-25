module NodeExtensions::GeoLocation
  extend ActiveSupport::Concern

  included do
    acts_as_mappable :default_units => :kms

    belongs_to :pin

    # Geocode before validation or after, if defer_geocoding is set
    before_validation :geocode_if_location_changed, :unless => :defer_geocoding
    before_save       :geocode_if_location_changed,     :if => :defer_geocoding

    validates_presence_of :lng, :lat, :if => :location_present_and_valid?
    validate :valid_location

    scope :geo_coded, { :conditions => 'nodes.lat IS NOT NULL AND nodes.lng IS NOT NULL' }

    scope :published_after, lambda { |date| {
      :conditions => ["publication_start_date >= DATE(:date)", { :date => date }] }
    }

    scope :published_before, lambda { |date| {
      :conditions => ["publication_start_date <= DATE(:date)", { :date => date }] }
    }

    attr_accessor :location_coordinates, :defer_geocoding
  end

  module ClassMethods
    # Get the geocoding bias from settings, or default to NL
    def geocoding_bias
      if SETTLER_LOADED
        bias = Settler[:geocode_bias]
        bias = GeoKit::Bounds.normalize(bias) rescue 'NL' if bias.present?
      end
      return bias.present? ? bias : 'NL'
    end

    def try_geocode(*args)
      begin
        Geokit::Geocoders::GoogleGeocoder3.geocode(*args)
      rescue Geokit::TooManyQueriesError
        nil
      end
    end
  end

  def own_or_inherited_pin
    @own_or_inherited_pin ||= pin.present? ? pin : ancestors.all(:select => :pin_id, :include => :pin, :order => ['nodes.ancestry_depth desc'], :conditions => 'nodes.pin_id is not null').first.try(:pin)
  end

  def location_present?
    self.location.present?
  end

  private

  # Geocode location into lat and lng, also set location field to full address for future reference
  def geocode_if_location_changed
    geocode! if (location_changed? && !(lat_changed? || lng_changed?)) || location_coordinates.present?
  end

  def geocode!
    if self.location.present?
      if self.location.is_a?(Geokit::GeoLoc)
        @geocode = self.location
      else
        @geocode = Node.try_geocode(self.location, :bias => Node.geocoding_bias)
      end

      if @geocode && @geocode.success
        self.lat = @geocode.lat
        self.lng = @geocode.lng
        self.location = @geocode.full_address
      end
    elsif self.location_coordinates.present?
      ll = Geokit::LatLng.normalize(location_coordinates)
      self.lat = ll.lat
      self.lng = ll.lng
    else
      self.lat = nil
      self.lng = nil
    end
  end

  def valid_location
    self.errors.add(:base, I18n.t('nodes.invalid_location')) if location_invalid?
  end

  def location_invalid?
    @geocode.present? && !@geocode.success
  end

  def location_present_and_valid?
    location_present? && @geocode.present? && !location_invalid?
  end
end
