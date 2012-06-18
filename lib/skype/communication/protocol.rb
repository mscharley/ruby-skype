
require 'observer'

class Skype
  # You shouldn't try including this module, it is used purely for organisation.
  # @private
  module Communication
    # Interface for the Skype::Communication::* classes. This provides basic input and output functionality with Skype.
    #
    # Includes Observable. Notifications sent will have a single string parameter which is the incoming command from
    # Skype.
    module Protocol
      include Observable

      # The protocol version supported by this communication protocol
      #
      # @return [Boolean]
      attr_reader :protocol_version

      # Sends a message to Skype.
      #
      # Must be implemented by Protocol implementers.
      #
      # @return [void]
      def send(message)
        raise "#send(message) must be implemented."
      end

      # Connects to Skype.
      #
      # Must be implemented by Protocol implementers.
      #
      # @return [void]
      def connect
        raise "#connect must be implemented"
      end

      # Update processing. This is where you get a chance to check for input.
      #
      # Should be implemented by Protocol implementers, but no error is thrown if not.
      #
      # @return [void]
      def tick
      end

      private

      # Internal method to implement Observable.
      #
      # Protocol implementers may use this to send notifications of incoming commands.
      def receive(message)
        changed
        notify_observers(message)
      end
    end
  end
end