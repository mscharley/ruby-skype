
class Skype
  module Errors
    # A generalised Exception. This adds an error code field which holds the
    # numeric error code as returned by Skype. The Exception's message is a
    # plain text version of the error code, usually suitable for display to
    # users.
    class GeneralError < Exception
      # This is the error code reported by Skype.
      attr_reader :code

      # Create a new GeneralError with the specified code. The error message
      # should be provided to raise from ERROR_MESSAGES
      def initialize(error_code)
        @code = error_code
      end
    end
  end
end
