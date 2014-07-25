require File.expand_path('../../../test_helper.rb', __FILE__)

class Admin::ContentNodeTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  def setup
    @controller = Admin::PagesController.new
    @page = pages(:news_page)
  end

  def test_should_update_page_with_location
    login_as :admin

    put :update, :id => @page.id, :page => { :location => 'Welle, Deventer', :expires_on => 1.day.from_now.to_date.to_s }

    assert_response :success
    assert assigns(:page).node.valid?
    assert assigns(:page).node.location =~ /Deventer/
  end

  def test_should_not_update_page_location_with_identical_location
    login_as :admin

    @page.update_attributes(:location => 'Polstraat')

    put :update, :id => @page.id, :page => { :location => @page.node.location, :expires_on => 1.day.from_now.to_date.to_s }
    assert_response :success
    assert_not_nil assigns(:page).node.location
    assert assigns(:page).node.valid?
  end
end
