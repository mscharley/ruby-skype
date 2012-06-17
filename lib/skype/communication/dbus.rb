
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

      def initialize(application_name)
        @application_name = application_name
        @dbus = ::DBus::SessionBus.instance
        @dbus_service = @dbus.service(SKYPE_DBUS_SERVICE)
        @skype = @dbus_service.object(SKYPE_SERVER_PATH)
        @skype.introspect
        @skype.default_iface = SKYPE_SERVER_INTERFACE
      end

      def send(message)
        @skype.Invoke(message)
      end
    end
  end
end
