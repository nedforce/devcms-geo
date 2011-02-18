p "Initializing DevCMS Geo.."

plugin_root = File.dirname(__FILE__)

Dir["#{plugin_root}/config/initializers/**/*.rb"].sort.each do |initializer|
  require(initializer)
end

require File.join(plugin_root, "app", "models", "node.rb")

if Rails.env.development?
  ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end