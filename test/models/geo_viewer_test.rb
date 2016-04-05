require File.expand_path('../../test_helper.rb', __FILE__)

class GeoViewerTest < ActiveSupport::TestCase
  test 'should create geo viewer' do
    assert_nothing_raised do
      geo_viewer = create_geo_viewer
      assert_not_nil geo_viewer
      assert geo_viewer.valid?
    end
  end

  test 'should serialize settings' do
    geo_viewer = create_geo_viewer(filter_settings: { setting: [:value] }, map_settings: { setting_2: [:value_a] })
    assert_equal({ setting:   [:value]   }, GeoViewer.find(geo_viewer.id).filter_settings)
    assert_equal({ setting_2: [:value_a] }, GeoViewer.find(geo_viewer.id).map_settings)
  end

  test 'should return empty hash for missing setting' do
    geo_viewer = create_geo_viewer
    assert_not_nil geo_viewer.filter_settings
    assert geo_viewer.filter_settings.is_a?(Hash)
  end

  test 'should return node scope' do
    geo_viewer = create_geo_viewer
    assert_equal Node.all, geo_viewer.nodes
  end

  test 'should return placeable conditions' do
    placeable_viewer  = create_geo_viewer(filter_settings: { from_date: 2.weeks.from_now.to_s })
    placeable_viewer2 = create_geo_viewer

    geo_viewer = create_geo_viewer(combined_viewer: true, geo_viewer_ids: [placeable_viewer.id, placeable_viewer2.id])
    geo_viewer.geo_viewer_placeables.each { |placeable| placeable.update_attributes(is_toggable: true) }

    assert_not_nil geo_viewer.placeable_conditions
    assert_not_nil geo_viewer.placeable_conditions(toggled_only_for_empty_selection: true)
    assert_not_nil geo_viewer.placeable_conditions(selection: [placeable_viewer.id])
    assert_equal geo_viewer.placeable_conditions, geo_viewer.placeable_conditions(selection: [])
  end

  test 'placeable conditions should override with user filters' do
    from_date         = 2.weeks.from_now
    placeable_viewer  = create_geo_viewer(filter_settings: { from_date: from_date.to_s })
    placeable_viewer2 = create_geo_viewer

    geo_viewer = create_geo_viewer(combined_viewer: true, geo_viewer_ids: [placeable_viewer.id, placeable_viewer2.id])

    assert geo_viewer.filtered_nodes_scope.to_sql.include?(from_date.to_formatted_s(:db))
    refute geo_viewer.filtered_nodes_scope(from_date: from_date + 2.weeks).to_sql.include?(from_date.to_formatted_s(:db))
  end

  protected

  def create_geo_viewer(options = {})
    GeoViewer.create!({ parent: Node.root, title: 'GeoViewer' }.merge(options))
  end
end
