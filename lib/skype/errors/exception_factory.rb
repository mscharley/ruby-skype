
require 'skype/errors/error_messages'
require 'skype/errors/general_error'

class Skype
  # This module is entirely for organisation purposes. Do not attempt to include it.
  module Errors
    # This class allows the library to generate exceptions based on error codes from Skype easily.
    class ExceptionFactory
      # This function will raise an exception. It never returns.
      #
      # @param [String] error_message The ERROR #error_id response from Skype.
      def self.generate_exception(error_message)
        data = error_message.match(/^ERROR\s+(\d+)(?:\s+(.+))?$/)
        error_code = data[1].to_i
        exception_message = ERROR_MESSAGES[error_code] || data[2] || "Unknown error: #{error_code}"

        raise ::Skype::Errors::GeneralError.new(error_code), exception_message, caller
      end
    end
  end
end
