require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PinsControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true
  
  def setup
    @pin = Pin.create({ :title => 'Pin 1', :file => File.open(File.dirname(__FILE__) + '/../../fixtures/files/pin.png') })    
  end

  def test_should_list_pins
    login_as :admin
    
    get :index

    assert_response :success
    assert_select '#pins td.title', {:count => 1, :text => "Pin 1"}
  end
  
  def test_should_create_pin
    login_as :admin
    
    post :create, :pin => { :title => 'Pin 2', :file => File.open(File.dirname(__FILE__) + '/../../fixtures/files/pin.png') }
    assert_response :success
    
    get :index    
    assert_select '#pins td.title', {:count => 1, :text => "Pin 2"}    
  end
  
  def test_should_not_create_invalid_pin
    login_as :admin
    
    post :create, :pin => { :file => File.open(File.dirname(__FILE__) + '/../../fixtures/files/pin.png') }
    assert !assigns(:pin).valid?
  end  
  
  def test_should_destroy_pin
    login_as :admin
    
    delete :destroy, :id => @pin.id
    assert_response :success
    
    assert_nil Pin.find_by_id @pin.id  
  end  
    
end
