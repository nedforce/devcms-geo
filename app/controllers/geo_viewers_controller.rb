# This +RESTful+ controller is used to orchestrate and control the flow of 
# the application relating to GeoViewer objects.
class GeoViewersController < ApplicationController
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
    else
      @map.center_zoom_on_points_init(*@nodes.collect {|node| [node.lat, node.lng]})
    end
    
    @nodes.each do |node|
      @map.overlay_init GMarker.new([node.lat, node.lng], :title => node.content.title, :max_width => 300, :info_window => render_to_string(:partial => '/shared/google_maps_popup', :locals => {:node => node}))
    end
        
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
