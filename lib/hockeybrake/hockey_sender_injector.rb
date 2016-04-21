module HockeyBrake
  module HockeySenderInjector
    def override_send(data)
      HockeyBrake::HockeySender.new().send(data)
    end
  end
end

module Airbrake
  class SyncSender
    include HockeyBrake::HockeySenderInjector
    alias_method :send, :override_send
  end
end

module Airbrake
  def self.configuration
    @notifiers[:default].instance_variable_get(:@config)
  end
end
