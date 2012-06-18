
require 'skype/communication/protocol'
require 'skype/communication/windows/win32'

class Skype
  module Communication
    # Utilises the Windows API to send and receive Window Messages to/from Skype.
    # 
    # This protocol is only available on Windows and Cygwin.
    class Windows
      include Skype::Communication::Protocol

      # Sets up access to Skype
      #
      # @see http://msdn.microsoft.com/en-us/library/bb384843.aspx Creating Win32-Based Applications
      def initialize
        # Get the message id's for the Skype Control messages
        @api_discover_message_id = Win32::RegisterWindowMessage('SkypeControlAPIDiscover')
        @api_attach_message_id = Win32::RegisterWindowMessage('SkypeControlAPIAttach')

        instance = Win32::GetModuleHandle(nil)

        @window_class = Win32::WNDCLASSEX.new
        @window_class[:style]         = Win32::CS_HREDRAW | Win32::CS_VREDRAW
        @window_class[:lpfnWndProc]   = method(:message_pump)
        @window_class[:hInstance]     = instance
        @window_class[:hbrBackground] = Win32::COLOR_WINDOWFRAME
        @window_class[:lpszClassName] = FFI::MemoryPointer.from_string 'ruby-skype'

        @window = Win32::CreateWindowEx(Win32::WS_EX_LEFT, ::FFI::Pointer.new(@window_class.handle), 'ruby-skype', Win32::WS_OVERLAPPEDWINDOW,
                                        0, 0, 0, 0, Win32::NULL, Win32::NULL, instance, nil)
      end

      # This is our message pump that receives messages from Windows.
      #
      # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633573.aspx MSDN
      def message_pump(window_handle, message_id, wParam, lParam)
        puts "WM: #{sprintf("0x%04x", message_id)}" if Skype.DEBUG
        Win32::DefWindowProc(window_handle, message_id, wParam, lParam)
      end
    end
  end
end
