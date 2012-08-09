
require 'dbus'
require 'skype/communication/protocol'

# Monkey-patch dbus to fix an error till it makes it into a release
class DBus::Connection
  def update_buffer
    @buffer += @socket.read_nonblock(MSG_BUF_SIZE)
  rescue EOFError
    raise                     # the caller expects it
  rescue Errno::EWOULDBLOCK
    # simply fail the read if it would block
    return
  rescue Exception => e
    puts "Oops:", e
    raise if @is_tcp          # why?
    puts "WARNING: read_nonblock failed, falling back to .recv"
    @buffer += @socket.recv(MSG_BUF_SIZE)
  end
end

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
      # Interface for the Skype -> client communication function.
      SKYPE_CLIENT_INTERFACE = 'com.Skype.API.Client'

      # Create a communication link to Skype via DBus. This initialises DBus,
      # but doesn't attempt to connect to Skype yet.
      #
      # @see #connect.
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
      # For DBus, this includes exporting the client interface and then
      # identifying ourselves and negotiating protocol version.
      #
      # @return [void]
      def connect
        value = @skype.Invoke("NAME " + @application_name)
        unless value == %w{OK}
          Skype::Errors::ExceptionFactory.generate_exception *value
        end
        @protocol_version = @skype.Invoke("PROTOCOL 8")[0].
            sub(/^PROTOCOL\s+/, '').to_i
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
        puts "-> #{message}" if ::Skype.DEBUG
        ret = @skype.Invoke(message)[0]
        puts "<- #{ret}" if ::Skype.DEBUG
        ret
      end

      # Poll DBus for incoming messages. We use this method for watching for
      # our messages as it is simpler, and an event loop is required no matter
      # what.
      #
      # @return [void]
      def tick
        @dbus.update_buffer
        @dbus.messages.each do |msg|
          # Pass messages through DBus
          @dbus.process(msg)

          # Process messages to us.
          if msg.interface == SKYPE_CLIENT_INTERFACE &&
              msg.path == SKYPE_CLIENT_PATH
            receive(msg.params[0])
          end
        end
      end
    end
  end
end
