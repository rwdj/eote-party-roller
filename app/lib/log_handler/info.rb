# frozen_string_literal: true

module LogHandler
  # Logs normal info messages
  class Info
    LOGGER_TYPE = name.match(/::(\w+)$/)[1].downcase
    LOGGER_MSG_COLOR = 'green'

    class << self
      def method_missing(name, *args, &block)
        if name.to_s =~ /^log_(\w*)$/
          send('_log_pair', Regexp.last_match(1).humanize, *args)
        elsif name.to_s.match?(/^log$/)
          send('_log_msg', *args)
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        return name.to_s.match?(/^log(?:_\w+)?$/) || super if include_private

        super
      end

      protected

      def _log_msg(msg)
        Rails.logger.send(
          self::LOGGER_TYPE,
          msg.send(self::LOGGER_MSG_COLOR).bold
        )
      end

      def _log_pair(msg, value)
        Rails.logger.send(
          self::LOGGER_TYPE,
          msg.red.bold + ': ' +
            prep_value(value)
        )
      end

      def prep_value(value)
        value = value.to_s[0...300]
        value.encode!('UTF-8', 'UTF-8', invalid: :replace)
        value.split("\n").map do |line|
          line.send(self::LOGGER_MSG_COLOR).bold
        end.join("\n")
      end
    end
  end
end
