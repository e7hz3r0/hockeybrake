require 'spec_helper'

describe 'Hockeybrake configuration' do

  it 'accepts basic settings' do
    HockeyBrake.configure do |config|
      config.app_bundle_id= "com.test.app"
      config.app_id="secret"
      config.app_version="test"
    end

    expect(HockeyBrake.configuration.app_bundle_id).to eq('com.test.app')
    expect(HockeyBrake.configuration.app_id).to eq('secret')
    expect(HockeyBrake.configuration.app_version).to eq('test')
  end

  it 'accepts resque specific settings' do
    HockeyBrake.configure do |config|
      config.no_resque_handler = true
    end

    expect(HockeyBrake.configuration.no_resque_handler).to be true
  end

end
