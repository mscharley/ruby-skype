
# This class is the main interface between Ruby and Skype.

class Skype
  # Initialises the Skype library and sets up a communication protocol, but doesn't connect yet.
  #
  # application_name is for DBus's sake. It seems that on Windows/OSX Skype can get an application name for display to
  # the user, but on DBus it expects one to be fed to it.
  def initialize(application_name, communication_protocol = nil)
    if communication_protocol.nil?
      require 'skype/communication/dbus'
      @skype = Skype::Communication::DBus.new(application_name)
    else
      @skype = communication_protocol
    end
  end
end
