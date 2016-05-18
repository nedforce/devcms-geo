module DevcmsGeo
  class Engine < Rails::Engine
    register_cms_modules

    ActiveSupport.on_load(:node) do
      include NodeExtensions::GeoLocation
    end
    DevcmsCore.config.node_field_partials << 'admin/geo_viewers/node_fields'
    initializer 'devcms_precompile' do |app|
      app.config.assets.precompile << 'oms.js'
      app.config.assets.precompile << 'devcms-geo.js'
      app.config.assets.precompile << 'devcms_geo_fullscreen.css'
    end
  end
end
