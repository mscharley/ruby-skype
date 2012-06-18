
require 'skype/communication/windows/win32/types'

class Skype
  module Communication
    class Windows
      module Win32
        # DLL imports from user32.dll
        module User32
          extend DL
          extend DL::Importer
          dlload 'user32'
          include Types

          # @!method RegisterWindowMessage(message_name)
          #
          # Registers a Window Message with Windows or returns a handle to an existing message.
          #
          # @param [String] message_name The name of the message to register
          # @return [Handle]
          # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644947.aspx MSDN
          extern 'UINT RegisterWindowMessage(LPCTSTR)'

          # @!method CreateWindowEx(extended_style, window_class, window_name, style, x, y, width, height, parent, menu, instance)
          #
          # Creates a new window.
          #
          # @param [Integer] extended_style A combination of WS_EX_* constant values defining the extended style for this window.
          # @param [String] window_class This matches up with a registered WindowClass's lpszClassName parameter.
          # @param [String] window_name This is the title of the newly created window.
          # @param [Integer] style A combination of the WS_* constant values defining the style for this window.
          # @param [Integer] x The horizontal position of the window on the screen.
          # @param [Integer] y The vertical position of the window on the screen.
          # @param [Integer] width The width of the window to create.
          # @param [Integer] height The height of the window to create.
          # @param [WindowHandle] parent A parent window for this one.
          # @param [MenuHandle] menu The menu for this window.
          # @param [InstanceHandle] instance
          # @return [WindowHandle]
          # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms632680.aspx MSDN
          extern 'HWND CreateWindowEx(DWORD, LPCTSTR, LPCTSTR, DWORD, int, int, int, int, HWND, HMENU, HINSTANCE)'

          # @!method RegisterClassEx(class_definition)
          #
          # Registers a Window Class for use with CreateWindowEx.
          #
          # @param [WindowClass] class_definition
          # @return [Handle]
          # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633587.aspx MSDN
          extern 'ATOM RegisterClassEx(WNDCLASSEX)'

          # **Usage:**
          #
          # Allocate using `WindowClass#malloc`. You can set the `cbSize` parameter using `WindowClass#size`.
          #
          # @todo Document this better, especially the part where people have to deal with DL
          # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633577.aspx MSDN
          WindowClass = struct [
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

          # This is the callback function used to process window messages.
          #
          # @todo This is only a placeholder while trying to test things out.
          WNDPROC = set_callback DL::TYPE_LONG, 4 do |window_handle, message_id, wParam, lParam|
            puts "WM: #{message_id}"
          end

          # @!group Predefined WindowHandle's
          #
          # These are WindowHandle's provided by the Win32 API for special purposes.

          # Target for SendMessage(). Broadcast to all windows.
          HWND_BROADCAST = 0xffff
          # Used as a parent in CreateWindow(). Signifies that this should be a message-only window.
          HWND_MESSAGE = -3

          # @!endgroup

          # CreateWindow Use Default Value
          CW_USEDEFAULT = 0x80000000

          COLOR_WINDOW = 5
          COLOR_WINDOWFRAME = 6

          # @!group Class Style contants.

          CS_VREDRAW = 0x0001
          CS_HREDRAW = 0x0002

          # @!group Window Style constants
          #
          # This is only a subset.
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
        end
      end
    end
  end
end
