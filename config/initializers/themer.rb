# TODO - this isn't too convenient for testing
#        would it make sense to have this served dynamically?

File.delete("#{RAILS_ROOT}/public/theme_assets") if File.exist?("#{RAILS_ROOT}/public/theme_assets")
File.symlink("#{RAILS_ROOT}/themes/#{SITE_SETTINGS['theme']}/theme_assets", "#{RAILS_ROOT}/public/theme_assets")
