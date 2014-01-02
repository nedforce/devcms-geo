require File.expand_path('../../test_helper.rb', __FILE__)

class GeoViewersControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  def test_should_show_geo_viewer
    get :show, :id => geo_viewers(:geo_viewer).id
    assert_response :success

    assert assigns(:geo_viewer)
  end

  def test_should_return_map
    get :map, :id => geo_viewers(:geo_viewer).id, :format => 'json'
    assert_response :success

    assert assigns(:geo_viewer)
    assert assigns(:nodes)
    assert assigns(:bounds)
  end

  def test_should_show_fullscreen_geo_viewer
    get :fullscreen, :id => geo_viewers(:geo_viewer).id
    assert_response :success

    assert assigns(:geo_viewer)
    assert assigns(:nodes)
  end

  def test_should_show_screenreader_geo_viewer
    get :screenreader, :id => geo_viewers(:geo_viewer).id
    assert_response :success
    assert assigns(:geo_viewer)
    assert assigns(:nodes)
  end


  def test_should_increment_hits_on_show
    geo_viewer = geo_viewers(:geo_viewer)
    old_hits = geo_viewer.node.hits
    get :show, :id => geo_viewer
    assert_equal old_hits + 1, geo_viewer.node.reload.hits
  end

end
