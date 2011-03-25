require File.dirname(__FILE__) + '/../test_helper'

class GeoViewerTest < ActiveSupport::TestCase

  def test_should_create_geo_viewer
    assert_nothing_raised do
      geo_viewer = create_geo_viewer
      assert_not_nil geo_viewer
      assert geo_viewer.valid?
    end
  end

  def test_should_serialize_settings
    geo_viewer = create_geo_viewer({ :filter_settings => { :setting => [:value] }, :map_settings => { :setting_2 => [:value_a] }})
    assert_equal({ :setting   => [:value]  }, GeoViewer.find(geo_viewer.id).filter_settings)
    assert_equal({ :setting_2 => [:value_a]}, GeoViewer.find(geo_viewer.id).map_settings)
  end

  def test_should_return_empty_hash_for_missing_setting
    geo_viewer = create_geo_viewer
    assert_not_nil geo_viewer.filter_settings
    assert geo_viewer.filter_settings.is_a?(Hash)
  end

  protected

  def create_geo_viewer(options = {})
    GeoViewer.create!({ :parent => Node.root, :title => 'GeoViewer' }.merge(options))
  end
end
