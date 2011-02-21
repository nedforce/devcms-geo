require File.dirname(__FILE__) + '/../../test_helper'

class Admin::GeoViewersControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  def setup
    @geo_viewer = GeoViewer.create!({:parent => Node.root, :title => "GeoViewer"})
  end

  def test_should_get_show
    login_as :admin

    get :show, :id => @geo_viewer.id
    assert_response :success
    assert assigns(:geo_viewer)
  end

  def test_should_render_404_if_not_found
    login_as :admin

    get :show, :id => -1
    assert_response :not_found
  end

  def test_should_get_new
    login_as :admin

    get :new, :parent_node_id => nodes(:root_section_node).id
    assert_response :success
    assert assigns(:geo_viewer)
  end

  def test_should_create_geo_viewer
    login_as :admin

    assert_difference('GeoViewer.count') do
      create_geo_viewer
      assert_response :success
      assert !assigns(:geo_viewer).new_record?, :message => assigns(:geo_viewer).errors.full_messages.join('; ')
    end
  end

  def test_should_get_valid_preview_for_create
    login_as :admin

    assert_no_difference('GeoViewer.count') do
      create_geo_viewer({ :title => 'foobar' }, { :commit_type => 'preview' })
      assert_response :success
      assert assigns(:geo_viewer).new_record?
      assert_equal 'foobar', assigns(:geo_viewer).title
      assert_template 'create_preview'
    end
  end

  def test_should_not_get_invalid_preview_for_create
    login_as :admin

    assert_no_difference('GeoViewer.count') do
      create_geo_viewer({ :title => nil }, { :commit_type => 'preview' })
      assert_response :unprocessable_entity
      assert assigns(:geo_viewer).new_record?
      assert assigns(:geo_viewer).errors.on(:title)
      assert_template 'new'
    end
  end

  def test_should_not_create_geo_viewer
    login_as :admin

    assert_no_difference('GeoViewer.count') do
      create_geo_viewer({ :title => nil })
    end
    assert_response :unprocessable_entity
    assert assigns(:geo_viewer).new_record?
    assert assigns(:geo_viewer).errors.on(:title)
  end

  def test_should_get_edit
    login_as :admin

    get :edit, :id => @geo_viewer.id
    assert_response :success
    assert assigns(:geo_viewer)
  end

  def test_should_get_edit_with_params
    login_as :admin

    get :edit, :id => @geo_viewer.id, :geo_viewer => { :title => 'foo' }
    assert_response :success
    assert assigns(:geo_viewer)
    assert_equal 'foo', assigns(:geo_viewer).title
  end

  def test_should_update_geo_viewer
    login_as :admin

    put :update, :id => @geo_viewer.id, :geo_viewer => { :title => 'updated title', :description => 'updated_description' }

    assert_response :success
    assert_equal 'updated title', assigns(:geo_viewer).title
  end

  def test_should_get_valid_preview_for_update
    login_as :admin

    geo_viewer      = @geo_viewer
    old_title = geo_viewer.title
    put :update, :id => geo_viewer.id, :geo_viewer => { :title => 'updated title', :description => 'updated_description' }, :commit_type => 'preview'
    assert_response :success
    assert_equal 'updated title', assigns(:geo_viewer).title
    assert_equal old_title, geo_viewer.reload.title
    assert_template 'update_preview'
  end

  def test_should_not_get_invalid_preview_for_update
    login_as :admin

    geo_viewer      = @geo_viewer
    old_title = geo_viewer.title
    put :update, :id => geo_viewer.id, :geo_viewer => { :title => nil, :description => 'updated_description' }, :commit_type => 'preview'
    assert_response :unprocessable_entity
    assert assigns(:geo_viewer).errors.on(:title)
    assert_equal old_title, geo_viewer.reload.title
    assert_template 'edit'
  end

  def test_should_not_update_geo_viewer
    login_as :admin

    put :update, :id => @geo_viewer.id, :geo_viewer => { :title => nil }
    assert_response :unprocessable_entity
    assert assigns(:geo_viewer).errors.on(:title)
  end

  def test_should_require_roles
    assert_user_can_access  :admin,       [ :new, :create ], { :parent_node_id => nodes(:root_section_node).id }
    assert_user_can_access  :final_editor, [ :new, :create ], { :parent_node_id => nodes(:economie_section_node).id }
    assert_user_cant_access :editor,       [ :new, :create ], { :parent_node_id => nodes(:root_section_node).id }
    assert_user_cant_access :final_editor, [ :new, :create ], { :parent_node_id => nodes(:root_section_node).id }
  end

protected

  def create_geo_viewer(attributes = {}, options = {})
    post :create, { :parent_node_id => nodes(:root_section_node).id, :geo_viewer => { :title => 'new title' }.merge(attributes) }.merge(options)
  end
  
end
