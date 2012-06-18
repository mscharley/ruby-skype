
require 'skype/communication/protocol'
require 'skype/communication/windows/win32'

class Skype
  module Communication
    # Utilises the Windows API to send and receive Window Messages to/from Skype.
    # 
    # This protocol is only available on Windows and Cygwin.
    class Windows
      include Skype::Communication::Protocol

      # @see http://msdn.microsoft.com/en-us/library/bb384843.aspx
      def initialize
        # Get the message id's for the Skype Control messages
        @api_discover_message_id = Win32::User32::RegisterWindowMessage('SkypeControlAPIDiscover')
        @api_attach_message_id = Win32::User32::RegisterWindowMessage('SkypeControlAPIAttach')

        puts "wndproc: #{Win32::User32::WNDPROC}"

        hInstance = Win32::Kernel32::GetModuleHandle(DL::NULL)
        puts "hInstance: #{hInstance}"

        puts "Entering RegisterClassEx"

        @window_class_struct = Win32::User32::WindowClass.malloc
        @window_class_struct.cbSize        = Win32::User32::WindowClass.size
        @window_class_struct.style         = Win32::User32::CS_HREDRAW | Win32::User32::CS_VREDRAW
        @window_class_struct.lpfnWndProc   = Win32::User32::WNDPROC
        @window_class_struct.cbClsExtra    = 0
        @window_class_struct.cbWndExtra    = 0
        @window_class_struct.hInstance     = hInstance
        @window_class_struct.hIcon         = DL::NULL
        @window_class_struct.hCursor       = DL::NULL
        @window_class_struct.hbrBackground = Win32::User32::COLOR_WINDOWFRAME
        @window_class_struct.lpszMenuName  = DL::NULL
        @window_class_struct.lpszClassName = 'ruby-skype'
        @window_class_struct.hIconSm       = DL::NULL

        @window_class = Win32::User32::RegisterClassEx(@window_class_struct.to_i)
        puts "Window Class: #{@window_class}"

        puts "Entering CreateWindowEx"
        @window = Win32::User32::CreateWindowEx(0, 'ruby-skype', 'ruby-skype', Win32::User32::WS_OVERLAPPEDWINDOW,
                                                0, 0, 0, 0, DL::NULL, DL::NULL, DL::NULL)
        puts "Exited CreateWindowEx"

        p @window
      end

      # LRESULT CALLBACK WindowProc(
      #   __in  HWND hwnd,
      #   __in  UINT uMsg,
      #   __in  WPARAM wParam,
      #   __in  LPARAM lParam
      # );
      def message_pump(window_handle, message_id, wParam, lParam)
        puts "WM: #{message_id}"
      end
    end
  end
end
