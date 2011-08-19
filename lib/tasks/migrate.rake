namespace :db do
  task :migrate => [:sync_migrations]

  desc "Copies all migrations from DevCMS Geo to the application migration directory."
  task :sync_migrations do
    plugin_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    Engines.mirror_files_from(File.join(plugin_root, 'db', 'migrate'), File.join(RAILS_ROOT, 'db', 'migrate'))
  end
end
