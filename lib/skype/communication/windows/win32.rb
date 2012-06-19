
require 'ffi'

class Skype
  module Communication
    class Windows
      # This module is used to provide access to the Win32 API to Ruby. There is lots of stuff here that is poorly named
      # but tries stick closely to the original Win32 API for ease of reference.
      #
      # BEWARE: Here there be dragons aplenty.
      module Win32
        extend FFI::Library
        ffi_lib('user32', 'kernel32')
        ffi_convention(:stdcall)

        private

        def self._func(*args)
          attach_function *args
          case args.size
            when 3
              module_function args[0]
            when 4
              module_function args[0]
              alias_method(args[1], args[0])
              module_function args[1]
          end
        end

        ULONG_PTR = FFI::TypeDefs[:ulong]
        LONG_PTR = FFI::TypeDefs[:long]

        ULONG = FFI::TypeDefs[:ulong]
        LONG = FFI::TypeDefs[:long]
        LPVOID = FFI::TypeDefs[:pointer]
        INT = FFI::TypeDefs[:int]
        BYTE = FFI::TypeDefs[:uint16]
        DWORD = FFI::TypeDefs[:ulong]
        BOOL = FFI::TypeDefs[:int]
        UINT = FFI::TypeDefs[:uint]
        POINTER = FFI::TypeDefs[:pointer]
        VOID = FFI::TypeDefs[:void]

        HANDLE = ULONG_PTR
        HWND = HANDLE
        HICON = HANDLE
        HCURSOR = HANDLE
        HBRUSH = HANDLE
        HINSTANCE = HANDLE
        HGDIOBJ = HANDLE
        HMENU = HANDLE
        HMODULE = HANDLE

        LPARAM = LONG_PTR
        WPARAM = ULONG_PTR
        LPMSG = LPVOID
        LPCTSTR = LPVOID
        LRESULT = LONG_PTR
        ATOM = BYTE

        public

        # Provide a NULL constant so we can be a little more explicit.
        NULL = 0

        # This is the callback function used to process window messages.
        WNDPROC = callback(:WindowProc, [HWND, UINT, WPARAM, LPARAM], LRESULT)

        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633577.aspx MSDN
        class WNDCLASSEX < FFI::Struct
          layout :cbSize, UINT,
                 :style, UINT,
                 :lpfnWndProc, WNDPROC,
                 :cbClsExtra, INT,
                 :cbWndExtra, INT,
                 :hInstance, HANDLE,
                 :hIcon, HICON,
                 :hCursor, HCURSOR,
                 :hbrBackground, HBRUSH,
                 :lpszMenuName, LPCTSTR,
                 :lpszClassName, LPCTSTR,
                 :hIconSm, HICON

          def initialize(*args)
            super
            self[:cbSize] = self.size
            @atom = 0
          end

          # Register class with Windows.
          def register_class_ex
            # According to MSDN, you must add 1 to this value before registering. We shouldn't expect client code to
            # remember to always do this.
            self[:hbrBackground] = self[:hbrBackground] + 1 if self[:hbrBackground] > 0

            (@atom = Win32::RegisterClassEx(self)) != 0 ? @atom : raise("RegisterClassEx Error")
          end

          # @!attribute [r] handle
          #
          # Returns a handle to use the windo class with CreateWindowEx()
          def handle
            @atom != 0 ? @atom : register_class_ex
          end
        end # WNDCLASSEX

        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/dd162805.aspx
        class POINT < FFI::Struct
          layout :x, LONG,
                 :y, LONG
        end

        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644958.aspx
        class MSG < FFI::Struct
          layout :hwnd, HWND,
                 :message, UINT,
                 :wParam, WPARAM,
                 :lParam, LPARAM,
                 :time, DWORD,
                 :pt, POINT
        end

        # @!method RegisterWindowMessage(message_name)
        #
        # Registers a Window Message with Windows or returns a handle to an existing message.
        #
        # @param [String] message_name The name of the message to register
        # @return [Handle]
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644947.aspx MSDN
        _func(:RegisterWindowMessage, :RegisterWindowMessageA, [LPCTSTR], UINT)

        # @!method GetModuleHandle(module_name)
        #
        # Used to obtain a handle to a module loaded by the application. If passed DL::NULL then returns a
        # handle to the current module.
        #
        # @param [String|DL::NULL] module_name The name of the module to return a handle to.
        # @return [ModuleHandle]
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms683199.aspx MSDN
        _func(:GetModuleHandle, :GetModuleHandleA, [LPCTSTR], HMODULE)

        # @!method RegisterClassEx(class_definition)
        #
        # Registers a Window Class for use with CreateWindowEx.
        #
        # @param [WindowClass] class_definition
        # @return [Handle]
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633587.aspx MSDN
        _func(:RegisterClassEx, :RegisterClassExA, [LPVOID], ATOM)

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
        _func(:CreateWindowEx, :CreateWindowExA, [DWORD, LPCTSTR, LPCTSTR, DWORD, INT, INT, INT, INT, HWND, HMENU, HINSTANCE, LPVOID], HWND)

        # @!method GetMessage(message, window, filter_min, filter_max)
        #
        # Get a message from the message queue. Blocks until there is one to return. Compare with PeekMessage().
        #
        # @param [MSG] message **[out]** A message structure to output the incoming message to.
        # @param [WindowHandle] window Which window to get messages for.
        # @param [Integer] filter_min The first message to return, numerically. For suggestions, see MSDN.
        # @param [Integer] filter_max The last message to return, numerically. If min and max are both 0 then all
        #                             messages are returned. For suggestions, see MSDN.
        # @return [Integer] -1 on error, otherwise 0 or 1 indicating whether to keep processing.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644936.aspx MSDN
        _func(:GetMessage, :GetMessageA, [LPMSG, HWND, UINT, UINT], BOOL)

        # @!method PeekMessage(message, window, filter_min, filter_max, remove_message)
        #
        # Peek at a message from the message queue and optionally remove it. Never blocks. Compare with GetMessage().
        #
        # @param [MSG] message **[out]** A message structure to output the incoming message to.
        # @param [WindowHandle] window Which window to get messages for.
        # @param [Integer] filter_min The first message to return, numerically. For suggestions, see MSDN.
        # @param [Integer] filter_max The last message to return, numerically. If min and max are both 0 then all
        #                             messages are returned. For suggestions, see MSDN.
        # @param [Integer] remove_message One of the PM_* values.
        # @return [Integer] 0 or 1 indicating whether to keep processing.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644943.aspx MSDN
        _func(:PeekMessage, :PeekMessageA, [LPMSG, HWND, UINT, UINT, UINT], BOOL)

        # @!method SendMessage(window, message, wParam, lParam)
        #
        # Send a message to another window.
        #
        # @param [WindowHandle] window Which window to send the message to.
        # @param [Integer] message WM_* message to send.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644950.aspx MSDN
        _func(:SendMessage, :SendMessageA, [HWND, UINT, WPARAM, LPARAM], LRESULT)

        # @!method TranslateMessage(message, window, filter_min, filter_max)
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644955.aspx MSDN
        _func(:TranslateMessage, [LPVOID], BOOL)

        # @!method DispatchMessage(message, window, filter_min, filter_max)
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644934.aspx MSDN
        _func(:DispatchMessage, :DispatchMessageA, [LPVOID], BOOL)

        # @!method DefWindowProc(message, window, filter_min, filter_max)
        # @return [Object] Return value is dependant on message type
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633572.aspx MSDN
        _func(:DefWindowProc, :DefWindowProcA, [HWND, UINT, WPARAM, LPARAM], LRESULT)

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

        #@!group HBRUSH colours

        # System window colour
        COLOR_WINDOW = 5

        # @!group Class Style contants.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ff729176.aspx MSDN

        # Redraws the entire window if a movement or size adjustment changes the height of the client area.
        CS_VREDRAW = 0x0001
        # Redraws the entire window if a movement or size adjustment changes the width of the client area.
        CS_HREDRAW = 0x0002

        # @!group Window Message constants
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms644927.aspx#system_defined MSDN

        # An application sends the WM_COPYDATA message to pass data to another application.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms649011.aspx MSDN
        WM_COPYDATA = 0x004A

        # @!group PeekMessage constants

        # Messages are not removed from the queue after processing by #PeekMessage().
        PM_NOREMOVE = 0
        # Messages are removed from the queue after processing by #PeekMessage().
        PM_REMOVE   = 1

        # @!group Window Style constants
        #
        # This is only a subset.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms632600.aspx

        # The window has a thin-line border.
        WS_BORDER =      0x00800000
        # The window has a title bar
        WS_CAPTION =     0x00C00000
        # The window is initially disabled. A disabled window cannot receive input from the user.
        WS_DISABLED =    0x08000000
        # The window is an overlapped window. An overlapped window has a title bar and a border.
        WS_OVERLAPPED =  0x00000000
        # The windows is a pop-up window.
        WS_POPUP =       0x80000000
        # The window has a sizing border.
        WS_SIZEBOX =     0x00040000
        # The window has a window menu on its title bar.
        WS_SYSMENU =     0x00080000
        # The window has a sizing border.
        WS_THICKFRAME =  0x00040000
        # The window has a maximize button.
        WS_MAXIMIZEBOX = 0x00010000
        # The window has a minimize button.
        WS_MINIMIZEBOX = 0x00020000
        # The window is an overlapped window.
        WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX
        # The window is a pop-up window.
        WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU

        # @!group Window Extended Style constants
        #
        # This is only a subset.
        # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ff700543.aspx

        # The window has generic left-aligned properties. This is the default.
        WS_EX_LEFT = 0

        # @!endgroup
      end
    end
  end
end
