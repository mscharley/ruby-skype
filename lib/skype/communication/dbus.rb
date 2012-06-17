
require 'dbus'
require 'skype/communication/protocol'
require 'observer'

class Skype
  module Communication
    # This class handles communication with Skype via DBus.
    #
    # This communication method is available under Linux.
    class DBus
      include Skype::Communication::Protocol

      # DBus service name to connect to.
      SKYPE_DBUS_SERVICE = 'com.Skype.API'
      # DBus communication path for client -> Skype communication.
      SKYPE_SERVER_PATH = '/com/Skype'
      # Interface for the client -> Skype communication function.
      SKYPE_SERVER_INTERFACE = 'com.Skype.API'
      # DBus communication path for Skype -> client communication.
      SKYPE_CLIENT_PATH = '/com/Skype/Client'

      # Have we connected to Skype yet?
      def connected?
        @connected
      end

      # Create a communication link to Skype via DBus. This initialises DBus, but doesn't attempt to connect to Skype
      # yet. See #connect.
      def initialize(application_name)
        @application_name = application_name
        @dbus = ::DBus::SessionBus.instance
        @dbus_service = @dbus.service(SKYPE_DBUS_SERVICE)
        @skype = @dbus_service.object(SKYPE_SERVER_PATH)
        @skype.introspect
        @skype.default_iface = SKYPE_SERVER_INTERFACE
      end

      # Attempt to connect to Skype.
      #
      # For DBus, this includes exporting the client interface and then identifying ourselves and negotiating protocol
      # version.
      #
      # @return [void]
      def connect
        @skype_client = Client.new(SKYPE_CLIENT_PATH)
        @skype_client.add_observer(self)
        @dbus_service.export(@skype_client)
        value = @skype.Invoke("NAME " + @application_name)
        unless value == %w{OK}
          Skype::Errors::ExceptionFactory.generate_exception *value
        end
        @protocol_version = @skype.Invoke("PROTOCOL 8")[0].sub(/^PROTOCOL\s+/, '').to_i
        @connected = true
      end

      # Send a command to Skype.
      #
      # @param [string] message The message to send to Skype
      # @return [string] The direct response from Skype
      def send(message)
        unless @connected
          raise "You must be connected before sending data."
        end
        puts "-> #{message}"
        @skype.Invoke(message)[0]
      end

      # Public callback for receiving commands from the Client interface. Should not be called manually. This simply
      # passes data through to #receive.
      #
      # @param [string] command The command to notify upstream about
      # @return [void]
      def update(command)
        puts "<- #{command}"
        receive(command)
      end

      # This is the DBus Client object that is exported to DBus to provide a target for Skype -> client communication.
      class Client < ::DBus::Object
        include Observable

        dbus_interface "com.Skype.Client" do
          dbus_method :Notify, "in command:s" do |command|
            changed
            notify_observers(command)
          end
        end
      end
    end
  end
end
