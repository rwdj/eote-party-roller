# frozen_string_literal: true

module LogHandler
  # Logs error messages
  class Error < Info
    LOGGER_MSG_COLOR = 'red'

    class << self
      def _log_msg(error, msg)
        LogMailer.error_email(error, msg).deliver

        super(msg)
      end

      def _log_pair(error, msg, value)
        LogMailer.error_email(error, msg, value).deliver

        super(msg, value)
      end
    end
  end
end
