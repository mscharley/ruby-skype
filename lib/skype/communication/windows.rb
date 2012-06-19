
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
      def initialize(application_name)
        @application_name = application_name

        # Get the message id's for the Skype Control messages
        @api_discover_message_id = Win32::RegisterWindowMessage('SkypeControlAPIDiscover')
        @api_attach_message_id = Win32::RegisterWindowMessage('SkypeControlAPIAttach')

        instance = Win32::GetModuleHandle(nil)

        @window_class = Win32::WNDCLASSEX.new
        @window_class[:style]         = Win32::CS_HREDRAW | Win32::CS_VREDRAW
        @window_class[:lpfnWndProc]   = method(:message_pump)
        @window_class[:hInstance]     = instance
        @window_class[:hbrBackground] = Win32::COLOR_WINDOW
        @window_class[:lpszClassName] = FFI::MemoryPointer.from_string 'ruby-skype'

        @window = Win32::CreateWindowEx(Win32::WS_EX_LEFT, ::FFI::Pointer.new(@window_class.handle), 'ruby-skype', Win32::WS_OVERLAPPEDWINDOW,
                                        0, 0, 0, 0, Win32::NULL, Win32::NULL, instance, nil)
      end

      # Connects to Skype.
      #
      # @return [void]
      def connect
        Win32::SendMessage(Win32::HWND_BROADCAST, @api_discover_message_id, @window, 0)

        # Setup a message for use by #tick. Do this just once so we're not setting up and tearing down local variables
        # all the time.
        @msg = Win32::MSG.new
        @authorized = nil
      end

      # Update processing.
      #
      # This executes a Windows event loop while there are messages still pending, then dumps back out to let other
      # things take over and do their thing.
      #
      # @return [void]
      def tick
        while Win32::PeekMessage(@msg, Win32::NULL, 0, 0, Win32::PM_REMOVE) > 0
          Win32::TranslateMessage(@msg)
          Win32::DispatchMessage(@msg)
        end

        # Don't simplify this as we rely on false != nil for tribool values
        #noinspection RubySimplifyBooleanInspection
        Skype::Errors::ExceptionFactory.generate_exception("ERROR 68") if @authorized == false
      end

      # Attached to Skype successfully.
      API_ATTACH_SUCCESS = 0
      # Skype indicated that we should hold on.
      API_ATTACH_PENDING = 1
      # Attachment to Skype was refused.
      API_ATTACH_REFUSED = 2
      # Attachment to Skype isn't available currently. Typically there is no user logged in.
      API_ATTACH_NOT_AVAILABLE = 3

      private

      # This is our message pump that receives messages from Windows.
      #
      # The return value from DefWindowProc is important and must be returned somehow.
      #
      # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms633573.aspx MSDN
      def message_pump(window_handle, message_id, wParam, lParam)
        case message_id
          when @api_attach_message_id
            # Drop API_ATTACH messages on the floor
          when @api_discover_message_id
            case lParam
              when API_ATTACH_SUCCESS
                @skype_window = wParam
              when API_ATTACH_REFUSED
                # Signal to the message pump that we were deauthorised
                @authorized = false
              else
                # Ignore pending signal
                "WM: Ignoring API_DISCOVER response: #{lParam}"
            end
          when Win32::WM_COPYDATA
            unless wParam == @skype_window
              puts "WARNING: Dropping WM_COPYDATA on the floor from HWND #{wParam} (not Skype [#{@skype_window}])"
              return 0
            end

            puts "Incoming data from Skype: #{lParam}"

            # Let Windows know we got it successfully
            1
          else
            puts "Unhandled WM: #{sprintf("0x%04x", message_id)}" if Skype.DEBUG
            Win32::DefWindowProc(window_handle, message_id, wParam, lParam)
        end
      end
    end
  end
end
