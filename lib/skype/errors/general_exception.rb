
class Skype
  module Errors
    class GeneralException < Exception
      attr_reader :code

      def initialize(error_code)
        @code = error_code
      end
    end
  end
end
