
require 'dl/types'

class Skype
  module Communication
    class Windows
      module Win32
        # This module simply includes a bunch of Win32 type aliases for the DL library
        # @api private
        module Types
          def included(m)
            m.module_eval {
              include ::DL::Win32Types

              # @see http://msdn.microsoft.com/en-us/library/windows/desktop/aa383751.aspx
              typealias('HBRUSH', 'HANDLE')
              typealias('HCURSOR', 'HANDLE')
              typealias('HICON', 'HANDLE')
              typealias('HMENU', 'HANDLE')
              typealias('HMODULE', 'HANDLE')
              typealias('LPCTSTR', 'unsigned char *')
              typealias('LPVOID', 'void *')
              typealias('WNDPROC', 'void *') # Actually a function pointer
              typealias('WNDCLASSEX', 'void *') # struct
            }
          end
          module_function :included
        end
      end
    end
  end
end