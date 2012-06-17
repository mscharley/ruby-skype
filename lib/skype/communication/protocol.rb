
require 'observer'

class Skype
  module Communication
    # Interface for the Skype::Communication::* classes. This provides basic input and output functionality with Skype.
    #
    # Includes Observable. Notifications sent will have a single string parameter which is the incoming command from
    # Skype.
    module Protocol
      include Observable

      attr_reader :protocol_version

      # Sends a message to Skype.
      #
      # Must be implemented by Protocol implementers.
      def send(message)
        raise "#send(message) must be implemented."
      end

      # Connects to Skype.
      #
      # Must be implemented by Protocol implementers.
      def connect
        raise "#connect must be implemented"
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