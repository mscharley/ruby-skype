
require 'skype/communication/windows/win32/types'

class Skype
  module Communication
    class Windows
      module Win32
        module User32
          extend DL
          extend DL::Importer
          dlload 'user32'
          include Types

          extern 'UINT RegisterWindowMessage(LPCTSTR)'
          extern 'HWND CreateWindowEx(DWORD, LPCTSTR, LPCTSTR, DWORD, int, int, int, int, HWND, HMENU, HINSTANCE)'
          extern 'ATOM RegisterClassEx(WNDCLASSEX)'

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

          GWLP_HINSTANCE = -6
        end
      end
    end
  end
end
