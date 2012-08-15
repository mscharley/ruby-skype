
require 'skype/communication/protocol'
require 'skype/communication/windows/win32'

class Skype
  module Communication
    # Utilises the Windows API to send and receive Window Messages to/from
    # Skype.
    #
    # This protocol is only available on Windows and Cygwin.
    class Windows
      include Skype::Communication::Protocol

      # Sets up access to Skype
      #
      # @see http://msdn.microsoft.com/en-us/library/bb384843.aspx Creating
      #     Win32-Based Applications
      def initialize(application_name)
        @application_name = application_name

        # Get the message id's for the Skype Control messages
        @api_discover_message_id =
            Win32::RegisterWindowMessage('SkypeControlAPIDiscover')
        @api_attach_message_id =
            Win32::RegisterWindowMessage('SkypeControlAPIAttach')

        instance = Win32::GetModuleHandle(nil)

        @window_class = Win32::WNDCLASSEX.new
        @window_class[:style]         = Win32::CS_HREDRAW | Win32::CS_VREDRAW
        @window_class[:lpfnWndProc]   = method(:message_pump)
        @window_class[:hInstance]     = instance
        @window_class[:hbrBackground] = Win32::COLOR_WINDOW
        @window_class[:lpszClassName] =
            FFI::MemoryPointer.from_string 'ruby-skype'

        @window = Win32::CreateWindowEx(Win32::WS_EX_LEFT,
                                        FFI::Pointer.new(@window_class.handle),
                                        'ruby-skype',
                                        Win32::WS_OVERLAPPEDWINDOW,
                                        0, 0, 0, 0, Win32::NULL, Win32::NULL,
                                        instance, nil)
      end

      # Connects to Skype.
      #
      # @return [void]
      def connect
        # Do setup before sending message as Windows will process messages as
        # well while in SendMessage()
        @msg = Win32::MSG.new
        @authorized = nil
        @message_counter = 0
        @replies = {}

        Win32::PostMessage(Win32::HWND_BROADCAST, @api_discover_message_id,
                           @window, 0)
      end

      # Update processing.
      #
      # This executes a Windows event loop while there are messages still
      # pending, then dumps back out to let other things take over and do their
      # thing.
      #
      # @return [void]
      def tick
        while Win32::PeekMessage(@msg, Win32::NULL, 0, 0, Win32::PM_REMOVE) > 0
          Win32::TranslateMessage(@msg)
          Win32::DispatchMessage(@msg)
        end

        # Don't simplify this as we rely on false != nil for tribool values
        #noinspection RubySimplifyBooleanInspection
        if @authorized == false
          Skype::Errors::ExceptionFactory.generate_exception("ERROR 68")
        end
      end

      # Sends a message to Skype.
      #
      # @param [string] message The message to send to Skype
      # @return [string] The direct response from Skype
      def send(message)
        puts "-> #{message}" if Skype.DEBUG

        counter = next_message_counter
        message = "##{counter} #{message}"

        data = Win32::COPYDATASTRUCT.new
        data[:dwData] = 0
        data[:cbData] = message.length + 1
        data[:lpData] = FFI::MemoryPointer.from_string(message + "\0")

        Win32::SendMessage(@skype_window, Win32::WM_COPYDATA, @window,
                           pointer_to_long(data.to_ptr))

        while @replies[counter].nil?
          tick
          sleep(0.1)
        end

        ret = @replies[counter]
        @replies.delete(counter)
        ret
      end

      # Attached to Skype successfully.
      API_ATTACH_SUCCESS = 0
      # Skype indicated that we should hold on.
      API_ATTACH_PENDING = 1
      # Attachment to Skype was refused.
      API_ATTACH_REFUSED = 2
      # Attachment to Skype isn't available currently. Typically there is no
      # user logged in.
      API_ATTACH_NOT_AVAILABLE = 3

      private

      def next_message_counter
        @message_counter += 1
      end

      LPARAM_BITS = Win32::LPARAM.size * 8

      # Convert a ulong pointer value to a long int for use as a LPARAM because
      # someone at Microsoft thought it'd be a good idea to pass around
      # pointers as signed values.
      def pointer_to_long(pointer)
        pointer = pointer.to_i
        pointer > (2 ** (LPARAM_BITS - 1)) ?
            pointer - (2 ** LPARAM_BITS) : pointer
      end

      # Allows us to unwrap a pointer from a long. See #pointer_to_long
      def long_to_pointer(long)
        long < 0 ? long + (2 ** LPARAM_BITS) : long
      end

      # This is our message pump that receives messages from Windows.
      #
      # The return value from DefWindowProc is important and must be returned
      # somehow.
      #
      # @see
      #   http://msdn.microsoft.com/en-us/library/windows/desktop/ms633573.aspx
      #   MSDN
      def message_pump(window_handle, message_id, wParam, lParam)
        case message_id
          when @api_discover_message_id
            # Drop WM_API_DISCOVER messages on the floor
          when @api_attach_message_id
            case lParam
              when API_ATTACH_SUCCESS
                @skype_window = wParam
                send("NAME " + @application_name)
                @protocol_version = send("PROTOCOL 8").sub(/^PROTOCOL\s+/, '').
                    to_i
                @authorized = true

              when API_ATTACH_REFUSED
                # Signal to the message pump that we were deauthorised
                @authorized = false

              else
                # Ignore pending signal
                puts "WM: Ignoring WM_API_ATTACH response: #{lParam}" if
                    Skype.DEBUG

            end
          when Win32::WM_COPYDATA
            pointer = FFI::Pointer.new(long_to_pointer(lParam))
            data = Win32::COPYDATASTRUCT.new pointer

            input = data[:lpData].read_string(data[:cbData] - 1)
            if input[0] == '#'
              (counter, input) = input.split(/\s+/, 2)
              counter = counter.gsub(/^#/, '').to_i
            else
              counter = nil
            end

            if counter.nil?
              receive(input)
            else
              @replies[counter] = input
              puts "<- #{input}" if Skype.DEBUG
            end

            # Let Skype know we got it successfully
            return 1
          else
            puts "Unhandled WM: #{sprintf("0x%04x", message_id)}" if Skype.DEBUG
            return Win32::DefWindowProc(window_handle, message_id, wParam, lParam)
        end
      end
    end
  end
end
