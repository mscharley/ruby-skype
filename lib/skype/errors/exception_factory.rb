
require 'skype/errors/error_messages'
require 'skype/errors/general_exception'

class Skype
  # This module is entirely for organisation purposes. Do not attempt to include it.
  module Errors
    # This class allows the library to generate exceptions based on error codes from Skype easily.
    class ExceptionFactory
      # This function will raise an exception. It never returns.
      #
      # error_message should be the ERROR #error_id response from Skype.
      def self.generate_exception(error_message)
        error_code = error_message.sub(/^ERROR\s+/, '').to_i
        exception_message = ERROR_MESSAGES[error_code] || "Unknown error: #{error_code}"

        raise ::Skype::Errors::GeneralException.new(error_code), exception_message, caller
      end
    end
  end
end
