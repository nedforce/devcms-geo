require File.dirname(__FILE__) + '/../test_helper'

class GeoViewerHelper < ActiveSupport::TestCase
  
  def test_should_create_geo_viewer
    assert_nothing_raised do
      geo_viewer = create_geo_viewer
    end
    assert_not_nil geo_viewer
    assert geo_viewer.valid?
  end
  
  def test_should_serialize_settings
    geo_viewer = create_geo_viewer(:filter_settings => {:setting => [:value]}, :map_settings => {:setting_2 => [:value_a]} )
    assert_equal {:setting => [:value]}, GeoViewer.find(geo_viewer.id).filter_settings
    assert_equal {:setting_2 => [:value_a]}, GeoViewer.find(geo_viewer.id).map_settings
  end
  
  
  protected
  def create_geo_viewer(options = {})
    GeoViewer.create({:title => "GeoViewer"}.merge(options))
  end
end