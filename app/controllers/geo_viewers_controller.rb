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

    # Register pins
    @pins = {}
    Pin.all.each{|pin| @pins[pin.id] = { :image => URI.join(root_url, pin.file.url).to_s } }

    # Define map bounds
    if @filters[:location].present? || @nodes.blank?
      res = Node.try_geocode(@filters[:location].to_s, :bias => Node.geocoding_bias)
      @bounds = res.suggested_bounds
    else
      coordinates = @nodes.collect { |node| [ node.lat, node.lng ]}.transpose
      north = coordinates.first.max; south = coordinates.first.min; west  = coordinates.last.min; east  = coordinates.last.max
      longitudinal_margin = (east  - west)  * 0.05; latitudinal_margin  = (north - south) * 0.05

      sw = [south - latitudinal_margin, west - longitudinal_margin]
      ne = [north + latitudinal_margin, east + longitudinal_margin]

      @bounds = GeoKit::Bounds.normalize(sw, ne)
    end

    # Add node markers
    @markers = {}
    node_list = [] if static

    index = 0 # Counter for labels and colors (For static view as well)
    if @nodes.present?
      @nodes.each do |node|
        marker_id = "marker-#{node.id}"

        if static && (@bounds.blank? || @bounds.contains?(node))
          node_list << { :color => DevcmsGeo::StaticMap::COLOURS[index % DevcmsGeo::StaticMap::COLOURS.size], :label => DevcmsGeo::StaticMap::LABELS[index % DevcmsGeo::StaticMap::LABELS.size], :node => node }
          index += 1
        end

        @markers[marker_id] = { :title => node.content.title, :lat => node.lat, :lng => node.lng, :info_window => render_to_string(:partial => '/shared/google_maps_popup', :locals => { :node => node, :geo_viewer => @geo_viewer }) }

        if @geo_viewer.inherit_pins?
          @markers[marker_id][:pin_id] = node.own_or_inherited_pin.id if node.own_or_inherited_pin.present?
        elsif node.pin.present?
          @markers[marker_id][:pin_id] = node.pin.id
        end
      end
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
