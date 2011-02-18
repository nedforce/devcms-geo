# Geo environement.rb
config.plugin_paths += Dir["#{File.dirname(__FILE__)}/../vendor/plugins"]
config.i18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '**', '*.{rb,yml}')]

config.gem 'geokit', :version => '~> 1.5.0'
