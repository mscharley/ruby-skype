
require 'skype/communication/windows/win32/types'

class Skype
  module Communication
    class Windows
      module Win32
        # DLL imports from kernel32.dll
        module Kernel32
          extend DL
          extend DL::Importer
          dlload 'kernel32'
          include Types

          # @!method GetModuleHandle(module_name)
          #
          # Used to obtain a handle to a module loaded by the application. If passed DL::NULL then returns a
          # handle to the current module.
          #
          # @param [String|DL::NULL] module_name The name of the module to return a handle to.
          # @return [ModuleHandle]
          # @see http://msdn.microsoft.com/en-us/library/windows/desktop/ms683199.aspx MSDN
          extern 'HMODULE GetModuleHandle(LPCTSTR)'
        end
      end
    end
  end
end
