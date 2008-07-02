# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :add_theme_path
  
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  
  filter_parameter_logging :password, :password_confirmation

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'ad5fcf9cf9a6c79ef7b70f6ff02c6fca8e6692d9cd48306a21f27be3e36658f49234fe'

  # TODO - run this once, not before every instance
  def add_theme_path
    self.prepend_view_path "#{RAILS_ROOT}/themes/#{SITE_SETTINGS['theme']}"
  end
end
