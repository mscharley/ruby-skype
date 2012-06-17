
require 'dl/import'
require 'skype/communication/protocol'

class Skype
  module Communication
    # Utilises the Windows API to send and receive Window Messages to/from Skype.
    # 
    # This protocol is only available on Windows and Cygwin.
    class Windows
      include Skype::Communication::Protocol

      def initialize
        # Get the message id's for the Skype Control messages
        @api_discover_message_id = Win32::RegisterWindowMessage('SkypeControlAPIDiscover')
        @api_attach_message_id = Win32::RegisterWindowMessage('SkypeControlAPIAttach')

        puts "#{@api_discover_message_id} #{@api_attach_message_id}"
      end

      module Win32
        extend DL::Importer
        dlload 'user32'

        typealias('HWND', 'void *')
        typealias('LPCTSTR', 'unsigned char *')
        typealias('UINT', 'unsigned int')

        extern 'UINT RegisterWindowMessage(LPCTSTR)'
      end
    end
  end
end
