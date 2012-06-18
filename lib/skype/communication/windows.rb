
require 'dl/import'
require 'dl/types'
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

        @window = Win32::CreateWindowEx(0, DL::NULL, DL::NULL, Win32::WS_OVERLAPPEDWINDOW, 0, 0, 200, 200, 0, DL::NULL, DL::NULL)

        puts "#{@window}"
      end

      module Win32
        extend DL::Importer
        dlload 'user32'
        include DL::Win32Types

        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/aa383751.aspx
        typealias('HMENU', 'HANDLE')
        typealias('LPCTSTR', 'unsigned char *')

        # Window handle to broadcast to all windows
        HWND_BROADCAST = 0xffff
        HWND_MESSAGE = -3

        # CreateWindow Use Default Value
        CW_USEDEFAULT = 0x80000000

        # Window Style constants. This is only a subset.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms632600.aspx
        WS_BORDER =      0x00800000
        WS_CAPTION =     0x00C00000
        WS_DISABLED =    0x08000000
        WS_OVERLAPPED =  0x00000000
        WS_POPUP =       0x80000000
        WS_SIZEBOX =     0x00040000
        WS_SYSMENU =     0x00080000
        WS_THICKFRAME =  0x00040000
        WS_MAXIMIZEBOX = 0x00010000
        WS_MINIMIZEBOX = 0x00020000

        WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX
        WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU

        extern 'UINT RegisterWindowMessage(LPCTSTR)'
        extern 'HWND CreateWindowEx(DWORD, LPCTSTR, LPCTSTR, DWORD, int, int, int, int, HWND, HMENU, HINSTANCE)'
      end
    end
  end
end
