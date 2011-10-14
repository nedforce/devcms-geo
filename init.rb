p 'Initializing DevCMS Geo..'

plugin_root = File.dirname(__FILE__)

Dir["#{plugin_root}/config/initializers/**/*.rb"].sort.each do |initializer|
  require(initializer)
end

if ActiveRecord::Base.connection.table_exists?(:nodes)
  require File.join(plugin_root, 'app', 'models', 'node.rb')
end

if Rails.env.development?
  ActiveSupport::Dependencies.autoload_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end

# Register module
DevCMSCore.root
DevCMSCore::register_module(:DevCMSGeo)
