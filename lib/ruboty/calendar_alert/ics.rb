module Ruboty
  module CalendarAlert
    class Ics
      attr_reader :url

      def initialize(url)
        @url = url
      end

      def fetch
        cals = Icalendar.parse(open(url))
        cal = cals.first

        cal.events.map { |e|
          Ruboty::CalendarAlert::Alert.new(e)
        }.select { |a|
          a.today?
        }.map { |a|
          a.to_hash
        }
      end

      def url
        @url
      end

      def to_s
        url
      end

    end
  end
end

if __FILE__ == $0
  URL = "https://niconico-anime-sp-ics.herokuapp.com/ics"
  require_relative '../calendar_alert.rb'
  Ruboty::CalendarAlert::Ics.new(URL).fetch.map do |job|
    puts job
  end
end
