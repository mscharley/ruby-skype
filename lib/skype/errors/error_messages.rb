
class Skype
  module Errors
    # This is a map of error codes to error messages used by ExceptionFactory to generate it's messages.
    #
    # @see http://developer.skype.com/public-api-reference#ERRORS Skype Public API error codes
    ERROR_MESSAGES = {
        68 => 'Access denied',
    }
  end
end
