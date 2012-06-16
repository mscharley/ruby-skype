
require 'dbus'
require 'skype/communication/protocol'

class Skype
  module Communication
    # This class handles communication with Skype via DBus.
    #
    # This communication method is available under linux.
    class DBus
      include Skype::Communication::Protocol
    end
  end
end
