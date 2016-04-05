require File.expand_path('../../../test_helper.rb', __FILE__)

class Admin::PinsControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  setup do
    @pin = Pin.create(title: 'Pin 1', file: fixture_file_upload('files/pin.png', 'image/png', true))
  end

  test 'should list pins' do
    login_as :admin

    get :index

    assert_response :success
    assert_select '#pins td.title', count: 1, text: 'Pin 1'
  end

  test 'should create pin' do
    login_as :admin

    xhr :post, :create, pin: { title: 'Pin 2', file: fixture_file_upload('files/pin.png', 'image/png', true) }, format: :js
    assert_response :success

    xhr :get, :index
    assert response.body.include?('Pin 2')
  end

  test 'should not create invalid pin' do
    login_as :admin

    xhr :post, :create, pin: { file: fixture_file_upload('files/pin.png', 'image/png', true) }, format: :js
    assert assigns(:pin)
    refute assigns(:pin).valid?
  end

  test 'should destroy pin' do
    login_as :admin

    xhr :delete, :destroy, id: @pin.id, format: :js
    assert_response :success

    assert_nil Pin.find_by_id(@pin.id)
  end
end
