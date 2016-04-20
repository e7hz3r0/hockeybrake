require 'active_support/core_ext'

#
# This class converts the given Airbrake XML data to the log format of the HockeyApp server
#
module HockeyBrake
  class HockeyLog

    #
    # Generates a string which can be sent to the hockey service
    def self.generate_safe(data)
      output = ""

      begin
        output = HockeyLog.generate(data)
      rescue HockeyBrake::HockeyLogException => e
        output += e.message.to_s
      end

      # go ahead
      output
    end

    #
    # Generates a string which can be sent to the hockey service
    # Package: PACKAGE NAME
    # Version: VERSION
    # OS: OS VERSION
    # Manufacturer: DEVICE OEM
    # Model: DEVICE MODEL
    # Date: DATETIME

    # EXCEPTION REASON STRING
    # at CLASS.METHOD(FILE:LINE)
    # at CLASS.METHOD(FILE:LINE)
    # at CLASS.METHOD(FILE:LINE)
    # at CLASS.METHOD(FILE:LINE)
    # at CLASS.METHOD(FILE:LINE)
    def self.generate(data)
      begin
        # the output
        output = ""

        # generate our time string
        dtstr = Time.now.strftime("%a %b %d %H:%M:%S %Z %Y")

        # write the header so that we have something to send
        output += "Package: #{HockeyBrake.configuration.app_bundle_id}\n"
        output += "Version: #{HockeyBrake.configuration.app_version}\n"
        output += "Date: #{dtstr}\n"

        # try to get the hostname
        hostname = ""
        begin
          hostname = `hostname`.strip
        rescue
        end
        # add the optional values if possible
        begin
          output += "Model: #{hostname}\n"
          output += "OS: #{RUBY_PLATFORM}\n"
          output += "Ruby: #{RUBY_VERSION}\n"
          output += "Rails: #{Rails.version}\n"
        rescue
          # nothing to do
        end

        # add the empty line
        output += "\n"

        # parse the XML and convert them to the HockeyApp format
        if ( data.is_a?(String))
          output += generate_from_xml(data)
        else
          output += generate_from_notice(data)
        end

        # return the output
        output
      rescue Exception => e
        raise HockeyLogException.new(e)
      end
    end

    # EXCEPTION REASON STRING
    # at CLASS.METHOD(FILE:LINE)
    def self.generate_from_notice(data)
      output = ""

      # write the first line
      data[:errors].each do |error|
        output += "#{data[:message]}\n"

        # generate the call stacke
        error[:backtrace].each do |line|
          if line.has_key? :file
            class_name =   File.basename(line[:file], ".rb").classify

            begin
              output += "    at #{class_name}.#{line[:method]}(#{line[:file]}:#{line[:number]})\n"
            rescue
              #FIXME this _was_ method_name not method...
              output += "    at #{class_name}.#{line[:method]}(#{line[:file]}:#{line[:number]})\n"
            end
          end
        end
      end

      # emit
      output
    end

    # EXCEPTION REASON STRING
    # at CLASS.METHOD(FILE:LINE)
    def self.generate_from_xml(data)
      # the output
      output = ""

      # xml parser
      crashData = Hash.from_xml(data)

      # write the first line
      output += "#{crashData['notice']['error']['class']}: #{crashData['notice']['error']['message']}\n"

      # parse the lines
      lines = crashData['notice']['error']['backtrace']['line']
      lines.each do |line|
        class_name =   File.basename(line['file'], ".rb").classify
        output += "    at #{class_name}.#{line['method']}(#{line['file']}:#{line['number']})\n"
      end

      # emit
      output
    end
  end

end
