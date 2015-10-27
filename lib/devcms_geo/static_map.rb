module DevcmsGeo
  class StaticMap
    COLOURS        = %w(red green brown blue orange gray purple yellow)
    LABELS         = ('A'..'Z').to_a
    URL_TEMPLATE   = "http://maps.google.com/maps/api/staticmap?%s"
    MAX_MARKERS    = 30
    DEFAULT_WIDTH  = 480
    DEFAULT_HEIGHT = 400

    def initialize(options = {})
      @addresses = []
      @bounds = options.fetch(:bounds, nil)
      @width, @height = options.fetch(:width, DEFAULT_WIDTH), options.fetch(:height, DEFAULT_HEIGHT)
      @params = Hash.new.tap do |p|
        p[:sensor]  = false
        p[:size]    = "#{@width}x#{@height}"
        p[:maptype] = options.fetch(:type, 'roadmap')
        # p[:zoom]    = options.fetch(:zoom, 2)
        p[:center]  = options.fetch(:center, nil)
      end
    end

    def <<(address)
      @addresses << address if @bounds.blank? || @bounds.contains?(address)
    end

    def to_url
      params = @params.to_param
      params << '&'
      params << build_marker_params
      (URL_TEMPLATE % params)
    end

    def self.for_address(address, opts = {})
      map = new(opts.reverse_merge(zoom: 10))
      map << address
      map.to_url
    end

    def self.for_addresses(*addresses)
      map = new(addresses.extract_options!)
      addresses.flatten.each { |a| map << a }
      map.to_url
    end

    protected

    def build_marker_params
      params = []
      @addresses.sort { |x, y| x.updated_at <=> y.updated_at }[0..MAX_MARKERS].each_with_index do |address, index|
        return "markers=#{to_ll @addresses.first}" if @addresses.size == 1
        color = COLOURS[index % COLOURS.size]
        label = LABELS[index % LABELS.size]
        params << "markers=color:#{color}|label:#{label}|#{to_ll(address)}"
      end
      params.join('&')
    end

    def to_ll(address)
      "#{address.lat},#{address.lng}"
    end
  end
end
