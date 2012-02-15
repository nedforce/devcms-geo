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
  
  def test_should_return_node_scope
    geo_viewer = create_geo_viewer
    assert_equal Node.scoped({}), geo_viewer.nodes
    
    geo_viewer = create_geo_viewer(:combined_viewer => true, :geo_viewer_ids => [create_geo_viewer(:filter_settings => { :from_date => 2.weeks.from_now.to_s }).id])
    assert geo_viewer.nodes.current_scoped_methods[:find][:conditions].include?('publication_start_date')
  end
  
  def test_should_return_placeable_conditions
    placeable_viewer = create_geo_viewer(:filter_settings => { :from_date => 2.weeks.from_now.to_s })
    placeable_viewer2 = create_geo_viewer
       
    geo_viewer = create_geo_viewer(:combined_viewer => true, :geo_viewer_ids => [placeable_viewer.id, placeable_viewer2.id])
    geo_viewer.geo_viewer_placeables.each{|placeable| placeable.update_attribute(:is_toggable, true) }
    
    assert_not_nil geo_viewer.placeable_conditions
    assert_not_nil geo_viewer.placeable_conditions(:toggled_only_for_empty_selection => true)
    assert_not_nil geo_viewer.placeable_conditions(:selection => [placeable_viewer.id])
    assert_equal geo_viewer.placeable_conditions, geo_viewer.placeable_conditions(:selection => [])
  end
  
  protected

  def create_geo_viewer(options = {})
    GeoViewer.create!({ :parent => Node.root, :title => 'GeoViewer' }.merge(options))
  end
end
