#
# This section contain the standard airbrake configuration and it should be used to manipulate everything
# what the execption handler can do for your. Airbrae API relevant things are ignored from the HockeyApp
# sender except proxy settings.
#
Airbrake.configure do |c|
  c.project_id = 0
  c.project_key = ''
  
  # Configures the root directory of your project. Expects a String or a
  # Pathname, which represents the path to your project. Providing this option
  # helps us to filter out repetitive data from backtrace frames and link to
  # GitHub files from our dashboard.
  # https://github.com/airbrake/airbrake-ruby#root_directory
  c.root_directory = Rails.root

  # By default, Airbrake Ruby outputs to STDOUT. In Rails apps it makes sense to
  # use the Rails' logger.
  # https://github.com/airbrake/airbrake-ruby#logger
  c.logger = Rails.logger

  # Configures the environment the application is running in. Helps the Airbrake
  # dashboard to distinguish between exceptions occurring in different
  # environments. By default, it's not set.
  # NOTE: This option must be set in order to make the 'ignore_environments'
  # option work.
  # https://github.com/airbrake/airbrake-ruby#environment
  c.environment = Rails.env

  # Setting this option allows Airbrake to filter exceptions occurring in
  # unwanted environments such as :test. By default, it is equal to an empty
  # Array, which means Airbrake Ruby sends exceptions occurring in all
  # environments.
  # NOTE: This option *does not* work if you don't set the 'environment' option.
  # https://github.com/airbrake/airbrake-ruby#ignore_environments
  c.ignore_environments = %w(test)


  # A list of parameters that should be filtered out of what is sent to
  # Airbrake. By default, all "password" attributes will have their contents
  # replaced.
  # https://github.com/airbrake/airbrake-ruby#blacklist_keys
  c.blacklist_keys = [/password/i]
  
  # If Airbrake doesn't send any expected exceptions, we suggest to uncomment the
  # line below. It might simplify debugging of background Airbrake workers, which
  # can silently die.
  # Thread.abort_on_exception = ['test', 'development'].include?(Rails.env)
end

#
# This section conains your hockeyapp configuration and should be used to set your HockeyApp relevant
# key and secrets.
#
HockeyBrake.configure do |config|

  # the bundle id
  config.app_bundle_id= "###YOUR BUNDLE IDENTIFIER FROM HOCKEYAPP###"

  # The application ID in hockey app
  config.app_id="###YOUR APP SECRET###"

  # The application version, you can use the different environments
  # as version, otherwise use the name of your version 
  config.app_version="#{Rails.env}"

  # Support for resque exception handling is enabled by default. With this
  # settings the resque support will be disabled. If no resque gem is installed
  # it will be disabled automatically
  # config.no_resque_handler = true


  # Support for sidekiq exception handling is enabled by default. With this
  # settings the sidekiq support will be disabled. If no sidekiq gem is installed
  # it will be disabled automatically
  # config.no_sidekiq_handler = true
end
