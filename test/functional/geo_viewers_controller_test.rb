require File.dirname(__FILE__) + '/../test_helper'

class GeoViewersControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  def test_should_show_geo_viewer
    get :show, :id => geo_viewers(:geo_viewer).id
    
    assert_response :success
    assert assigns(:geo_viewer)
  end

  def test_should_increment_hits_on_show
    geo_viewer = geo_viewers(:geo_viewer)
    old_hits = geo_viewer.node.hits
    get :show, :id => geo_viewer
    assert_equal old_hits + 1, geo_viewer.node.reload.hits
  end
  
end
