# This +RESTful+ controller is used to orchestrate and control the flow of 
# the application relating to GeoViewer objects.
class GeoViewersController < ApplicationController
  helper GeoHelper
  before_filter :find_geo_viewer, :only => :show
  # * GET /geo_viewers/:id
  # * GET /geo_viewers/:id.xml
  def show
    @nodes = @geo_viewer.nodes
    @map = GMap.new("geo_viewer_#{@geo_viewer.id}")
    @map.control_init :small_map => true, :map_type => false
    if params[:location]
      res = Geokit::Geocoders::GoogleGeocoder.geocode(params[:location], :bias => Node.geocoding_bias) 
      @map.center_zoom_on_bounds_init(res.suggested_bounds.to_a)
      @center = res.full_address
    elsif @nodes.empty?
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@geo_viewer.map_settings[:center], :bias => Node.geocoding_bias) 
      @map.center_zoom_on_bounds_init(res.suggested_bounds.to_a)
      @center = res.full_address
    else
      @map.center_zoom_on_points_init(*@nodes.collect {|node| [node.lat, node.lng]})
    end
    
    nodes_expl = [] # Array van nodes voor static view voor noscript
    index = 0 # Teller om kleuren + labels te kiezen
    @nodes.each do |node|
      nodes_expl << {:color => StaticMap::COLOURS[index % StaticMap::COLOURS.size], :label => StaticMap::LABELS[index % StaticMap::LABELS.size], :node => node}
      @map.overlay_init GMarker.new([node.lat, node.lng], :title => node.content.title, :max_width => 300, :info_window => render_to_string(:partial => '/shared/google_maps_popup', :locals => {:node => node}))
      index += 1
    end
    
    @expl = render_to_string(:partial => 'node_list', :object => nodes_expl)
    
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
protected
  
  # Finds the GeoViewer object corresponding to the passed in +id+ parameter.
  def find_geo_viewer
    @geo_viewer = @node.content
  end  
end
