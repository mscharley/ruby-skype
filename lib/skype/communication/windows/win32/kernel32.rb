
require 'skype/communication/windows/win32/types'

class Skype
  module Communication
    class Windows
      module Win32
        module Kernel32
          extend DL
          extend DL::Importer
          dlload 'kernel32'
          include Types

          extern 'HMODULE GetModuleHandle(LPCTSTR)'
        end
      end
    end
  end
end
