
require 'skype/errors/exception_factory'

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

  # Connect to Skype and negotiate a communication channel
  def connect
    @skype.connect
  end

  # Are we connected to Skype?
  def connected?
    @skype.connected?
  end

  def tick
    @skype.tick
  end

  def run
    until @finished
      tick
      sleep(0.1)
    end
  end

  def quit
    @finished = true
  end

  def send_raw_command(command)
    @skype.send(command)
  end

  # The protocol version in use for the connection with Skype. This value is only reliable once connected.
  def protocol_version
    @skype.protocol_version
  end
end
