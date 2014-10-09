plugin_root = File.dirname(__FILE__)

Dir["#{plugin_root}/config/initializers/**/*.rb"].sort.each do |initializer|
  require(initializer)
end

if Rails.env.development?
  ActiveSupport::Dependencies.autoload_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end

# Register module
DevCMSCore::register_module(:DevCMSGeo)
