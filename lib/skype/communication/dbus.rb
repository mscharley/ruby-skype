
require 'dbus'
require 'skype/communication/protocol'

class Skype
  module Communication
    # This class handles communication with Skype via DBus.
    #
    # This communication method is available under Linux.
    class DBus
      include Skype::Communication::Protocol

      SKYPE_DBUS_SERVICE = 'com.Skype.API'
      SKYPE_SERVER_PATH = '/com/Skype'
      SKYPE_SERVER_INTERFACE = 'com.Skype.API'
      SKYPE_CLIENT_PATH = '/com/Skype/Client'

      def connected?
        @connected
      end

      def initialize(application_name)
        @application_name = application_name
        @dbus = ::DBus::SessionBus.instance
        @dbus_service = @dbus.service(SKYPE_DBUS_SERVICE)
        @skype = @dbus_service.object(SKYPE_SERVER_PATH)
        @skype.introspect
        @skype.default_iface = SKYPE_SERVER_INTERFACE
      end

      def connect
        value = @skype.Invoke("NAME " + @application_name)
        unless value == %w{OK}
          Skype::Errors::ExceptionFactory.generate_exception *value
        end
        @protocol_version = @skype.Invoke("PROTOCOL 8")[0].sub(/^PROTOCOL\s+/, '').to_i
        @connected = true
      end

      def send(message)
        unless @connected
          raise "You must be connected before sending data."
        end
        @skype.Invoke(message)
      end
    end
  end
end
