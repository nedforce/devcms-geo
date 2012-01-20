# This +RESTful+ controller is used to orchestrate and control the flow of 
# the application relating to GeoViewer objects.
class GeoViewersController < ApplicationController
  before_filter :find_geo_viewer, :only => [:show, :fullscreen]

  # * GET /geo_viewers/:id
  # * GET /geo_viewers/:id.xml
  def show
    generate_map(true)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def fullscreen
    generate_map(false)

    render :layout => false
  end

  protected

  def generate_map(static)
    @filters = {}
    @filters[:from_date]   = params[:from_date]
    @filters[:from_date] ||= @geo_viewer.filter_settings[:from_date]

    @filters[:until_date]   = params[:until_date]
    @filters[:until_date] ||= @geo_viewer.filter_settings[:until_date]

    @filters[:search_scope]   = params[:search_scope]
    @filters[:search_scope] ||= @geo_viewer.filter_settings[:search_scope]

    if @filters[:search_scope] == 'separator'
      @filters[:search_scope] = ''
    end
    # 2011.10.30 RvdH: Why are these two lines repeated a few lines down as well?
    @filters[:permit_product_type] = params[:permit_product_type].present? ? params[:permit_product_type] : @geo_viewer.filter_settings[:permit_product_type]
    @filters[:permit_phase]        = params[:permit_phase].present?        ? params[:permit_phase]        : @geo_viewer.filter_settings[:permit_phase]

    @filters[:legislation_subject_available] = params[:legislation_subject_available].present? ? params[:legislation_subject_available] : @geo_viewer.filter_settings[:legislation_subject_available]
    @filters[:permit_product_type]           = params[:permit_product_type].present?           ? params[:permit_product_type]           : @geo_viewer.filter_settings[:permit_product_type]
    @filters[:permit_phase]                  = params[:permit_phase].present?                  ? params[:permit_phase]                  : @geo_viewer.filter_settings[:permit_phase]
    @filters[:legislation_subject_available] = params[:legislation_subject_available].present? ? params[:legislation_subject_available] : @geo_viewer.filter_settings[:legislation_subject_available]
    @filters[:location]                      = params[:location].present?                      ? params[:location]                      : @geo_viewer.map_settings[:center]

    @nodes = @geo_viewer.nodes(@filters)

    @map = GMap.new("geo_viewer_#{@geo_viewer.id}")
    @map.control_init :small_map => true, :map_type => true
    @map.interface_init :continuous_zoom => true

    if params[:location].present? || @nodes.blank?
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@filters[:location], :bias => Node.geocoding_bias) 
      @bounds = res.suggested_bounds
      @map.center_zoom_on_bounds_init(@bounds.to_a)
      @center = res.full_address
    else
      @map.center_zoom_on_points_init(*@nodes.collect { |node| [ node.lat, node.lng ]})
    end

    if static
      nodes_expl = [] # Array nodes for static view
    end
    index = 0 # Counter for labels and colors (For static view as well)
    if @nodes.present?
      @nodes.each do |node|
        if static && (@bounds.blank? || @bounds.contains?(node))
          nodes_expl << { :color => StaticMap::COLOURS[index % StaticMap::COLOURS.size], :label => StaticMap::LABELS[index % StaticMap::LABELS.size], :node => node }
          index += 1
        end
        @map.overlay_init GMarker.new([node.lat, node.lng], :title => node.content.title, :maxWidth => 400, :info_window => render_to_string(:partial => '/shared/google_maps_popup', :locals => { :node => node }))
      end
    end

    if (static)
      @expl = render_to_string(:partial => 'node_list', :object => nodes_expl)
    end
  end

  # Finds the GeoViewer object corresponding to the passed in +id+ parameter.
  def find_geo_viewer
    @geo_viewer = @node.content
  end  
end
