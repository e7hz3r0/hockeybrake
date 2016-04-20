Airbrake.configure do |config|
  config.ignore_environments.delete("test")
  config.project_key = ''
  config.project_id = 0
end

HockeyBrake.configure do |config|
  config.app_bundle_id= "com.test.app"
  config.app_id="secret"
  config.app_version="test"
end
