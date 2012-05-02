require File.expand_path('../../../test_helper.rb', __FILE__)

class Admin::PinsControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true
  
  def setup
    @pin = Pin.create({ :title => 'Pin 1', :file => fixture_file_upload("files/pin.png", 'image/png', true) }) 
  end

  def test_should_list_pins
    login_as :admin
    
    get :index

    assert_response :success
    assert_select '#pins td.title', {:count => 1, :text => "Pin 1"}
  end
  
  def test_should_create_pin
    login_as :admin
    
    post :create, :pin => { :title => 'Pin 2', :file => fixture_file_upload("files/pin.png", 'image/png', true) }, :format => 'js'
    assert_response :success
    
    get :index
    assert @response.body.include?("Pin 2")
  end
  
  def test_should_not_create_invalid_pin
    login_as :admin
    
    post :create, :pin => { :file => fixture_file_upload("files/pin.png", 'image/png', true) }, :format => 'js'
    assert !assigns(:pin).valid?
  end  
  
  def test_should_destroy_pin
    login_as :admin
    
    delete :destroy, :id => @pin.id, :format => 'js'
    assert_response :success
    
    assert_nil Pin.find_by_id @pin.id  
  end  
    
end
