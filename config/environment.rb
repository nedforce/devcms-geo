# Geo environement.rb
config.plugin_paths   += Dir["#{File.dirname(__FILE__)}/../vendor/plugins"]
config.autoload_paths   += Dir["#{File.dirname(__FILE__)}/../app/uploaders"]
config.i18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '**', '*.{rb,yml}')]

config.gem 'geokit', :version => '~> 1.6.7'
config.gem 'carrierwave', :version => '~> 0.4.10'