
require 'Win32API'
require 'skype/communication/protocol'

class Skype
  module Communication
    # Utilises the Windows API to send and receive Window Messages to/from Skype.
    # 
    # This protocol is only available on Windows and Cygwin.
    class Windows
      include Skype::Communication::Protocol

      def initialize
        # Setup Win32 API calls
        @send_message = Win32API.new("user32", "SendMessage", %w{L L L L}, 'L')
        @register_window_message = Win32API.new("user32", "RegisterWindowMessage", %w{P}, 'I')

        # Get the message id's for the Skype Control messages
        @api_discover_message_id = register_window_message('SkypeControlAPIDiscover')
        @api_attach_message_id = register_window_message('SkypeControlAPIAttach')
      end

      private

      # Ruby handle to the Win32API function SendMessage.
      #
      # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644950.aspx
      # @api win32
      # @param [Integer] window_handle
      # @param [Integer] message_id
      # @param [Integer] wParam
      # @param [Integer] lParam
      # @return [Integer]
      def send_message(window_handle, message_id, wParam, lParam)
        @send_message.Call(window_handle, message_id, wParam, lParam)
      end

      # Ruby handle to the Win32API function RegisterWindowMessage.
      #
      # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644947.aspx
      # @api win32
      # @param [String] message_name
      # @return [Integer]
      def register_window_message(message_name)
        @register_window_message.Call(message_name)
      end
    end
  end
end
