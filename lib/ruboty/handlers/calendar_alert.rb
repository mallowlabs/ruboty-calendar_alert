module Ruboty
  module Handlers
    class CalendarAlert < Base
      NAMESPACE = "calendar_alert"

      on(/add calendar ?(?<ics_url>.+)?/, name: "add", description: "Add an alerting calendar")

      on(/delete calendar ?(?<ics_url>.+)?/, name: "delete", description: "Delete an alerting calendar")

      on(/list calendars\z/, name: "list", description: "List all alerting calendars")

      def initialize(*args)
        super
        remember
        start_fetch_thread(robot)
      end

      def add(message)
        begin
          url = message[:ics_url]
          create(message)
          message.reply("Calendar #{url} registerd")
        rescue => e
          message.reply("Calendar #{url} failed")
          Ruboty.logger.error e.message
        end
      end

      def delete(message)
        begin
          url = message[:ics_url]
          if delete_url(url)
            message.reply("Calendar #{url} deleted")
          else
            message.reply("Calendar #{url} does not exist")
          end
        rescue => e
          Ruboty.logger.error e.message
        end
      end

      def list(message)
        message.reply(summary, code: true)
      end

      private

      def remember
        brain.each do |url, jobs|
          jobs.each do |id, attributes|
            job = Ruboty::Cron::Job.new(attributes)
            running_jobs[id] = job
            job.start(robot)
          end
        end
      end

      def brain
        robot.brain.data[NAMESPACE] ||= {}
      end

      def create(message)
        refetch_url(message[:ics_url])
      end

      def create_url(url)
        ics = Ruboty::CalendarAlert::Ics.new(url)
        jobs = ics.fetch
        jobs.each do |attributes|
          job = Ruboty::Cron::Job.new(attributes)
          job.start(robot)
          running_jobs[job.id] = job
        end
        hash = {}
        jobs.each do |job|
          hash[job[:id]] = job
        end
        brain[url] = hash
      end

      def delete_url(url)
        if brain.has_key?(url)
          brain[url].each do |id, attributes|
            running_jobs[id].stop
            running_jobs.delete(id)
          end
          brain.delete(url)
          true
        else
          false
        end
      end

      def refetch_url(url)
        delete_url(url)
        create_url(url)
      end

      def summary
        if brain.empty?
          empty_message
        else
          ics_descriptions
        end
      end

      def empty_message
        "Calendar not found"
      end

      def ics_descriptions
        descriptions = ""
        brain.each do |url, jobs|
          descriptions << url << "\n\n"
          jobs.values.each do |attributes|
            descriptions << Ruboty::Cron::Job.new(attributes).description << "\n\n"
          end
        end
        descriptions.strip
      end

      def running_jobs
        @running_jobs ||= {}
      end

      def fetch_schedule
        #"23 2,8,14,20 * * *"
        "10 * * * *"
      end

      def start_fetch_thread(robot)
        Thread.new do
          Chrono::Trigger.new(fetch_schedule) do
            begin
              brain.keys.each do |url|
                Ruboty.logger.info "fetching... #{url}"
                refetch_url(url)
              end
            rescue => e
              Ruboty.logger.error e.message
            end
          end.run
        end
      end
    end
  end
end
