require File.expand_path('../../test_helper.rb', __FILE__)

class GeoViewersControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  test 'should show geo viewer' do
    get :show, id: geo_viewers(:geo_viewer).id
    assert_response :success

    assert assigns(:geo_viewer)
  end

  test 'should return map' do
    get :map, id: geo_viewers(:geo_viewer).id, format: 'json'
    assert_response :success

    assert assigns(:geo_viewer)
    assert assigns(:nodes)
    assert assigns(:bounds)
  end

  test 'should show fullscreen geo viewer' do
    get :fullscreen, id: geo_viewers(:geo_viewer).id
    assert_response :success

    assert assigns(:geo_viewer)
    assert assigns(:nodes)
  end

  test 'should show screenreader geo viewer' do
    get :screenreader, id: geo_viewers(:geo_viewer).id
    assert_response :success
    assert assigns(:geo_viewer)
    assert assigns(:nodes)
  end

  test 'should increment hits on show' do
    geo_viewer = geo_viewers(:geo_viewer)
    old_hits = geo_viewer.node.hits
    get :show, id: geo_viewer
    assert_equal old_hits + 1, geo_viewer.node.reload.hits
  end
end
