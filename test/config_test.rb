# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/test_helper"
 
class ConfigTest < Test::Unit::TestCase

  def setup
    setup_config_fixture
    @config = GvoiceRuby::Configurator.load_config(@config_file)
  end
  
  should "have project root constant" do
    assert_equal(File.expand_path(File.dirname(__FILE__) + '/..'), GvoiceRuby::Configurator.const_get(:PROJECT_ROOT))
  end
  
  should "load configuration file correctly" do
    @config.each_pair do |k,v| 
      assert_equal(v, @config[k.to_sym])
    end
  end
  
  should "write configuration file" do
    @config[:foo] = 'bar'
    GvoiceRuby::Configurator.write_config(@config, File.dirname(__FILE__) + '/fixtures/config_fixture.yml')
    newly_loaded_config = GvoiceRuby::Configurator.load_config(File.dirname(__FILE__) + '/fixtures/config_fixture.yml')
    assert_equal('bar', newly_loaded_config[:foo].to_s)
    @config.delete(:foo)
    GvoiceRuby::Configurator.write_config(@config, File.dirname(__FILE__) + '/fixtures/config_fixture.yml')
  end
  
  should "raise IOError when config file not loaded" do
    begin
      assert_raise(IOError) { GvoiceRuby::Configurator.load_config('foo') }
    rescue StandardError
    end
  end
  
  should "raise IOError when config file not written" do
    begin
      assert_raise(IOError) { GvoiceRuby::Configurator.write_config(@config, 'foo') }
    rescue StandardError
    end
  end
  
  should "Load a logger" do
    assert_equal(@config[:logfile], 'test_log.log')
    assert_not_nil(GvoiceRuby::Client.new(@config).logger)
  end
end