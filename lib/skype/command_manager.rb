
class Skype
  # This class is used to manage updates coming back from Skype.
  #
  # @see ::Skype#received_command
  # @see #process_command
  class CommandManager
    # Create a new CommandManager.
    #
    # There is one of these created per connection to Skype.
    #
    # @param [Skype] skype This is the skype connection to handle for. Used to
    #     pass updates back to the library after processing.
    def initialize(skype)
      @skype = skype
    end

    # This is a single entry point that delegates out to other methods based on
    # the command that was sent from Skype.
    #
    # @param [string] command The full command as a single string
    # @return [void]
    def process_command(command)
      (command, args) = command.split(/\s+/, 2)
      command = command.downcase.to_sym

      self.send(command, args) if self.public_methods.include? command
    end

    # @api private
    # @return [void]
    def connstatus(args)
      @skype.send :update_connection_status, args.downcase.to_sym
    end

    # @api private
    # @return [void]
    def userstatus(args)
      @skype.send :update_user_status, DataMaps::USER_VISIBILITY.invert[args]
    end
  end
end
