require File.expand_path('../../../test_helper.rb', __FILE__)

class Admin::GeoViewersControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  setup do
    @geo_viewer = GeoViewer.create!(parent: Node.root, title: 'GeoViewer')
  end

  test 'should get show' do
    login_as :admin

    get :show, id: @geo_viewer.id
    assert_response :success
    assert assigns(:geo_viewer)
  end

  test 'should get new' do
    login_as :admin

    get :new, parent_node_id: nodes(:root_section_node).id
    assert_response :success
    assert assigns(:geo_viewer)
  end

  test 'should create geo viewer' do
    login_as :admin

    assert_difference('GeoViewer.count') do
      create_geo_viewer
      assert_response :success
      assert !assigns(:geo_viewer).new_record?, assigns(:geo_viewer).errors.full_messages.join('; ')
    end
  end

  test 'should create combined geo viewer' do
    login_as :admin

    assert_difference('GeoViewerPlacement.count') do
      assert_difference('GeoViewer.count') do
        create_combined_geo_viewer
        assert_response :success
        assert !assigns(:geo_viewer).new_record?, assigns(:geo_viewer).errors.full_messages.join('; ')
      end
    end
  end

  test 'should get valid preview for create' do
    login_as :admin

    assert_no_difference('GeoViewer.count') do
      create_geo_viewer({ title: 'foobar' }, commit_type: 'preview')
      assert_response :success
      assert assigns(:geo_viewer).new_record?
      assert_equal 'foobar', assigns(:geo_viewer).title
      assert_template 'create_preview'
    end
  end

  test 'should not get invalid preview for create' do
    login_as :admin

    assert_no_difference('GeoViewer.count') do
      create_geo_viewer({ title: nil }, commit_type: 'preview')
      assert_response :unprocessable_entity
      assert assigns(:geo_viewer).new_record?
      assert assigns(:geo_viewer).errors[:title].any?
      assert_template 'new'
    end
  end

  test 'should not create geo viewer' do
    login_as :admin

    assert_no_difference('GeoViewer.count') do
      create_geo_viewer(title: nil)
    end
    assert_response :unprocessable_entity
    assert assigns(:geo_viewer).new_record?
    assert assigns(:geo_viewer).errors[:title].any?
  end

  test 'should get edit' do
    login_as :admin

    get :edit, id: @geo_viewer.id
    assert_response :success
    assert assigns(:geo_viewer)
  end

  test 'should get edit with params' do
    login_as :admin

    get :edit, id: @geo_viewer.id, geo_viewer: { title: 'foo' }
    assert_response :success
    assert assigns(:geo_viewer)
    assert_equal 'foo', assigns(:geo_viewer).title
  end

  test 'should update geo viewer' do
    login_as :admin

    put :update, id: @geo_viewer.id, geo_viewer: { title: 'updated title', description: 'updated_description' }

    assert_response :success
    assert_equal 'updated title', assigns(:geo_viewer).title
  end

  test 'should get valid preview for update' do
    login_as :admin

    geo_viewer = @geo_viewer
    old_title = geo_viewer.title
    put :update, id: geo_viewer.id, geo_viewer: { title: 'updated title', description: 'updated_description' }, commit_type: 'preview'
    assert_response :success
    assert_equal 'updated title', assigns(:geo_viewer).title
    assert_equal old_title, geo_viewer.reload.title
    assert_template 'update_preview'
  end

  test 'should not get invalid preview for update' do
    login_as :admin

    geo_viewer = @geo_viewer
    old_title = geo_viewer.title
    put :update, id: geo_viewer.id, geo_viewer: { title: nil, description: 'updated_description' }, commit_type: 'preview'
    assert_response :unprocessable_entity
    assert assigns(:geo_viewer).errors[:title].any?
    assert_equal old_title, geo_viewer.reload.title
    assert_template 'edit'
  end

  test 'should not update geo viewer' do
    login_as :admin

    put :update, id: @geo_viewer.id, geo_viewer: { title: nil }
    assert_response :unprocessable_entity
    assert assigns(:geo_viewer).errors[:title].any?
  end

  protected

  def create_geo_viewer(attributes = {}, options = {})
    post :create, { parent_node_id: nodes(:root_section_node).id, geo_viewer: { title: 'new title' }.merge(attributes) }.merge(options)
  end

  def create_combined_geo_viewer(attributes = {}, options = {})
    post :create, { parent_node_id: nodes(:root_section_node).id, geo_viewer: { title: 'new title', combined_viewer: '1', geo_viewer_placeables_attributes: { '0' => { geo_viewer_id: @geo_viewer.id, is_toggable: true } } }.merge(attributes) }.merge(options)
  end
end
