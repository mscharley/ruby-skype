
class Skype
  # This class is used to manage updates coming back from Skype.
  #
  # @see #process_message
  class CommandManager
    def initialize(skype)
      @skype = skype
    end

    def process_command(command)
      (command, args) = command.split(/\s+/, 2)
      command = command.downcase.to_sym

      self.send(command, args) if self.public_methods.include? command
    end

    def connstatus(args)
      @skype.send :update_connection_status, args.downcase.to_sym
    end

    def userstatus(args)
      @skype.send :update_user_status, DataMaps::USER_VISIBILITY.invert[args]
    end
  end
end
