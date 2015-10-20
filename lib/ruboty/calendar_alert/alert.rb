# coding: utf-8
module Ruboty
  module CalendarAlert
    class Alert
      attr_reader :event

      def initialize(event)
        @event = event
      end

      def margin
        10
      end

      def id
        event.uid.to_s
      end

      def body
        body = "#{event.summary} まで#{margin}分です。"
        body << "\n#{event.description}" unless event.description.blank?
        unless event.url.blank?
          body << "\n#{event.url}" unless (event.description || '').include?(event.url.to_s)
        end
        body.strip
      end

      def schedule
        datetime = margin.minutes.ago(event.dtstart.value)
        datetime.strftime("%M %H %d %m *")
      end

      def to_hash
        {id: id, body: body, schedule: schedule}
      end

      def future?
        Time.now < event.dtstart
      end

      def today?
        future? and event.dtstart < 1.days.since
      end

    end
  end
end

