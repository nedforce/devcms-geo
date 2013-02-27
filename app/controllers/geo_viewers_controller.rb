# This +RESTful+ controller is used to orchestrate and control the flow of 
# the application relating to GeoViewer objects.
require 'open-uri'

class GeoViewersController < ApplicationController  
  before_filter :find_geo_viewer, :only => [:show, :fullscreen, :screenreader]

  # * GET /geo_viewers/:id
  # * GET /geo_viewers/:id.xml
  def show
    respond_to do |format|
      format.html { generate_map(true) }
    end
  end

  def fullscreen
    respond_to do |format|
      format.html do
        generate_map(false)

        render :layout => false
      end
    end
  end

  def screenreader
    respond_to do |format|
      format.html { generate_map(true) }
    end
  end

  protected

  def generate_map(static)
    @filters = {}

    @filters[:from_date]   = params[:from_date]
    @filters[:from_date] ||= @geo_viewer.filter_settings[:from_date]

    @filters[:until_date]   = params[:until_date]
    @filters[:until_date] ||= @geo_viewer.filter_settings[:until_date]

    if @geo_viewer.combined_viewer?
      @filters[:layers]   = params[:layers]
      @filters[:layers] ||= @geo_viewer.filter_settings[:layers]
    else
      @filters[:search_scope]   = params[:search_scope]
      @filters[:search_scope] ||= @geo_viewer.filter_settings[:search_scope]

      if @filters[:search_scope] == 'separator'
        @filters[:search_scope] = ''
      end
    end

    @filters[:legislation_subject_available] = params[:legislation_subject_available].present? ? params[:legislation_subject_available] : @geo_viewer.filter_settings[:legislation_subject_available]
    @filters[:permit_product_type]           = params[:permit_product_type].present?           ? params[:permit_product_type]           : @geo_viewer.filter_settings[:permit_product_type]
    @filters[:permit_phase]                  = params[:permit_phase].present?                  ? params[:permit_phase]                  : @geo_viewer.filter_settings[:permit_phase]
    @filters[:legislation_subject_available] = params[:legislation_subject_available].present? ? params[:legislation_subject_available] : @geo_viewer.filter_settings[:legislation_subject_available]
    @filters[:location]                      = params[:location].present?                      ? params[:location]                      : @geo_viewer.map_settings[:center]

    @nodes = @geo_viewer.filtered_nodes(@filters)

    @map = GMap.new("geo_viewer_#{@geo_viewer.id}")
    @map.control_init :small_map => true, :map_type => true
    @map.interface_init :continuous_zoom => true

    pin_variables = {}
    Pin.all.each do |pin|
      width = pin.geometry.first; height = pin.geometry.last
      @map.icon_global_init( GIcon.new(:image => pin.file.url, :icon_size => GSize.new(width, height), :icon_anchor => GPoint.new(width/2, height), :info_window_anchor => GPoint.new(width/2,2)), "pin_#{pin.id}" )
      pin_variables["pin_#{pin.id}"] = Variable.new("pin_#{pin.id}")
    end

    if params[:location].present? || @nodes.blank?
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@filters[:location], :bias => Node.geocoding_bias) 
      @bounds = res.suggested_bounds
      @map.center_zoom_on_bounds_init(@bounds.to_a)
      @center = res.full_address
    else
      coordinates    = @nodes.collect { |node| [ node.lat, node.lng ]}.transpose
      
      north = coordinates.first.max
      south = coordinates.first.min
      west  = coordinates.last.min
      east  = coordinates.last.max
      
      longitudinal_margin = (east  - west)  * 0.05
      latitudinal_margin  = (north - south) * 0.05

      sw = [south - latitudinal_margin, west - longitudinal_margin]
      ne = [north + latitudinal_margin, east + longitudinal_margin]
     
      @map.center_zoom_on_bounds_init GeoKit::Bounds.normalize(sw, ne)
    end

    if static
      node_list = [] # Array nodes for static view
    end
    index = 0 # Counter for labels and colors (For static view as well)
    if @nodes.present?
      markers = {}

      @nodes.each do |node|
        markers[node.id] = (marker = "marker_#{node.id}")

        if static && (@bounds.blank? || @bounds.contains?(node))
          node_list << { :color => DevcmsGeo::StaticMap::COLOURS[index % DevcmsGeo::StaticMap::COLOURS.size], :label => DevcmsGeo::StaticMap::LABELS[index % DevcmsGeo::StaticMap::LABELS.size], :node => node }
          index += 1
        end

        marker_opts = { :title => node.content.title, :maxWidth => 400, :info_window => render_to_string(:partial => '/shared/google_maps_popup', :locals => { :node => node, :geo_viewer => @geo_viewer }) }

        if @geo_viewer.inherit_pins?
          marker_opts[:icon] = pin_variables["pin_#{node.own_or_inherited_pin.id}"] if node.own_or_inherited_pin.present?
        elsif node.pin.present?
          marker_opts[:icon] = pin_variables["pin_#{node.pin.id}"]
        end

        @map.declare_global_init(GMarker.new([node.lat, node.lng], marker_opts), marker)
        @map.overlay_init Variable.new(marker)
      end

      # Record markers for highlighting
      @map.record_global_init("var markers = { #{markers.map{|k,v| "'marker-#{k}':#{v}"}.join(', ')  } };\n")
    end

    if (static)
      @node_list_lettered = render_to_string(:partial => 'node_list_lettered', :locals => { :node_list => node_list }).html_safe
      @node_list_bulleted = render_to_string(:partial => 'node_list_bulleted', :locals => { :node_list => node_list }).html_safe
    end
  end

  # Finds the GeoViewer object corresponding to the passed in +id+ parameter.
  def find_geo_viewer
    @geo_viewer = @node.content
  end
end
