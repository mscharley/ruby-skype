
class Skype
  module Errors
    # This is a map of error codes to error messages used by ExceptionFactory to generate it's messages.
    # Missing codes can be added from: http://developer.skype.com/public-api-reference#ERRORS
    ERROR_MESSAGES = {
        68 => 'Access denied',
    }
  end
end
