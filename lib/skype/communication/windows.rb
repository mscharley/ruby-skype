
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

        puts "wndproc: #{Win32::WNDPROC}"

        puts "Entering RegisterClassEx"

        @window_class_struct = Win32::WNDCLASSEX.malloc
        @window_class_struct.cbSize        = Win32::WNDCLASSEX.size
        @window_class_struct.style         = Win32::CS_HREDRAW | Win32::CS_VREDRAW
        @window_class_struct.lpfnWndProc   = Win32::WNDPROC
        @window_class_struct.cbClsExtra    = 0
        @window_class_struct.cbWndExtra    = 0
        @window_class_struct.hInstance     = 0
        @window_class_struct.hIcon         = 0
        @window_class_struct.hCursor       = 0
        @window_class_struct.hbrBackground = Win32::COLOR_WINDOWFRAME
        @window_class_struct.lpszMenuName  = DL::NULL
        @window_class_struct.lpszClassName = 'ruby-skype'
        @window_class_struct.hIconSm       = 0

        p @window_class_struct

        @window_class = Win32::RegisterClassEx(@window_class_struct.to_i)
        puts "Window Class: #{@window_class}"

        puts "Entering CreateWindowEx"
        @window = Win32::CreateWindowEx(0, 'ruby-skype', 'ruby-skype', Win32::WS_OVERLAPPEDWINDOW,
                                        0, 0, 200, 200, DL::NULL, DL::NULL, DL::NULL)
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

      module Win32
        extend DL
        extend DL::Importer
        dlload 'user32'
        include DL::Win32Types

        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/aa383751.aspx
        typealias('HBRUSH', 'HANDLE')
        typealias('HCURSOR', 'HANDLE')
        typealias('HICON', 'HANDLE')
        typealias('HMENU', 'HANDLE')
        typealias('LPCTSTR', 'unsigned char *')
        typealias('LPVOID', 'void *')
        typealias('WNDPROC', 'void *') # Actually a function pointer
        typealias('WNDCLASSEX', 'void *') # struct

        WNDCLASSEX = struct [
          'UINT      cbSize',
          'UINT      style',
          'WNDPROC   lpfnWndProc',
          'int       cbClsExtra',
          'int       cbWndExtra',
          'HINSTANCE hInstance',
          'HICON     hIcon',
          'HCURSOR   hCursor',
          'HBRUSH    hbrBackground',
          'LPCTSTR   lpszMenuName',
          'LPCTSTR   lpszClassName',
          'HICON     hIconSm',
        ]

        WNDPROC = set_callback DL::TYPE_LONG, 4 do |window_handle, message_id, wParam, lParam|
          puts "WM: #{message_id}"
        end

        # Window handle to broadcast to all windows
        HWND_BROADCAST = 0xffff
        HWND_MESSAGE = -3

        # CreateWindow Use Default Value
        CW_USEDEFAULT = 0x80000000

        # Class Style contants.
        CS_VREDRAW = 0x0001
        CS_HREDRAW = 0x0002

        COLOR_WINDOW = 5
        COLOR_WINDOWFRAME = 6

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
        extern 'ATOM RegisterClassEx(WNDCLASSEX)'
      end
    end
  end
end
