require 'geokit-rails'

module Node::GeoLocation
  def self.included(base)
    base.acts_as_mappable :default_units => :kms

    base.belongs_to :pin

    base.before_validation :geocode_if_location_changed

    base.validates_presence_of :lng, :lat, :if => :location_present_and_valid?
    base.validate :valid_location

    base.named_scope :geo_coded, { :conditions => 'nodes.lat IS NOT NULL AND nodes.lng IS NOT NULL' }

    base.named_scope :published_after, lambda { |date| {
      :conditions => ["(publication_start_date >= DATE(:date) OR publication_start_date IS NULL) AND (publication_end_date >= DATE(:date) OR publication_end_date IS NULL)", { :date => date }] }
    }

    base.named_scope :published_before, lambda { |date| {
      :conditions => ["(publication_end_date <= DATE(:date) OR publication_end_date IS NULL) AND (publication_start_date <= DATE(:date) OR publication_start_date IS NULL)", { :date => date }] }
    }

    base.extend(ClassMethods)
  end

  module ClassMethods
    # Get the geocoding bias from settings, or default to NL
    def geocoding_bias
      if SETTLER_LOADED
        bias = Settler[:geocode_bias]
        bias = GeoKit::Bounds.normalize(bias) rescue 'NL' if bias.present?
      end
      bias.present? ? bias : 'NL'
    end
  end

  def own_or_inherited_pin
    @own_or_inherited_pin ||= pin.present? ? pin : ancestors.all(:select => :pin_id, :include => :pin, :order => ['nodes.ancestry_depth desc'], :conditions => 'nodes.pin_id is not null').first.try(:pin)
  end

  def location_present?
    location.present?
  end

  private

  # Geocode location into lat and lng, also set location field to full address
  # for future reference.
  # Set a validation error if the location cannot be geocoded.
  def geocode_if_location_changed
    geocode! if (location_changed? && !(lat_changed? || lng_changed?))
  end

  def geocode!
    if location.present?
      if location.is_a?(Geokit::GeoLoc)
        @geocode = location
      else
        begin
          @geocode = Geokit::Geocoders::GoogleGeocoder3.geocode(location, :bias => Node.geocoding_bias)
        rescue Geokit::TooManyQueriesError
          errors.add(:location, I18n.t('nodes.too_many_queries'))
        end
      end

      if @geocode && @geocode.success
        self.lat = @geocode.lat
        self.lng = @geocode.lng
        self.location = @geocode.full_address
      end
    else
      self.lat = nil
      self.lng = nil
    end
  end

  def valid_location
    errors.add_to_base(I18n.t('nodes.invalid_location')) if location_invalid?
  end

  def location_invalid?
    @geocode.present? && !@geocode.success
  end

  def location_present_and_valid?
    location_present? && @geocode.present? && !location_invalid?
  end
end
