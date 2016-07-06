require "active_job/logging"

ActiveSupport::Notifications.unsubscribe "perform_start.active_job"
ActiveSupport::Notifications.unsubscribe "perform.active_job"
ActiveSupport::Notifications.unsubscribe "enqueue_at.active_job"
ActiveSupport::Notifications.unsubscribe "enqueue.active_job"

module ActiveJob
  module Logging
    class LogSubscriber
      # Remove all public methods so that we can use the class
      # as the base class for our two new subscriber classes.
      remove_method :enqueue
      remove_method :enqueue_at
      remove_method :perform_start
      remove_method :perform
    end

    class EnqueueSubscriber < LogSubscriber
      def enqueue(event)
        info do
          job = event.payload[:job]
          "class=\"#{job.class.name}\" job_id=#{job.job_id} queue=#{queue_name(event)}"
        end
      end

      def enqueue_at(event)
        info do
          job = event.payload[:job]
          "class=\"#{job.class.name}\" job_id=#{job.job_id} queue=#{queue_name(event)} at=#{scheduled_at(event)}"
        end
      end
    end

    class ExecutionSubscriber < LogSubscriber
      def perform_start(event)
        info do
          job = event.payload[:job]
          "class=\"#{job.class.name}\" job_id=#{job.job_id} queue=#{queue_name(event)}"
        end
      end

      def perform(event)
        info do
          job = event.payload[:job]
          "class=\"#{job.class.name}\" job_id=#{job.job_id} queue=#{queue_name(event)} duration=#{event.duration.round(2)}"
        end
      end
    end
  end
end

# Subscribe to Active Job notifications
ActiveJob::Logging::EnqueueSubscriber.attach_to :active_job
ActiveJob::Logging::ExecutionSubscriber.attach_to :active_job
