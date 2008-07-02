require File.dirname(__FILE__) + '/../test_helper'

class SettingsTest < ActiveSupport::TestCase

  def setup
    @settings = YAML.load(File.read("#{RAILS_ROOT}/config/settings.yml"))['test']
  end
  
  def test_should_load_site_name
    assert_equal @settings['site_name'], SITE_SETTINGS['site_name']
  end
  
  def test_should_load_site_tagline
    assert @settings['site_tagline'], SITE_SETTINGS['site_tagline']
  end
end
