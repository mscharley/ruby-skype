
# This class is the main interface between Ruby and Skype.

class Skype
  def initialize(communication_protocol = nil)
    if communication_protocol.nil?
      require 'skype/communication/dbus'
      @skype = Skype::Communication::DBus.new
    else
      @skype = communication_protocol
    end
  end
end
