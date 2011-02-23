require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ContentNodeTest < ActionController::TestCase
  self.use_transactional_fixtures = true
    
  def setup
    @controller = Admin::PagesController.new
    @page = pages(:news_page)
  end

  def test_should_update_page_with_location
    login_as :admin

    put :update, :id => @page.id, :page => { :location => "Welle, Deventer" }

    assert_response :success
    assert assigns(:page).node.valid?
    assert assigns(:page).node.location =~ /Netherlands/
  end

  def test_should_not_update_page_location_with_identical_location
    login_as :admin
    
    @page.update_attributes(:location => 'Polstraat')
    
    put :update, :id => @page.id, :page => { :location => @page.node.location }
    assert_response :success
    assert_not_nil assigns(:page).node.location
    assert assigns(:page).node.valid?
  end

protected

  def create_page(attributes = {}, options = {})
    post :create, { :parent_node_id => nodes(:root_section_node).id, :page => { :title => 'new title', :preamble => 'Preamble'}.merge(attributes) }.merge(options)
  end
  
end
