# frozen_string_literal: true
class VoteManagerJob < ApplicationJob

  def perform
    Course.active.each do |course|

      Time.zone = course.time_zone
      log.debug("#{course.title}: #{Time.zone.now}")

      course.chambers.each do |chamber|

        Vote.pending.after_start_at.where(chamber_id: chamber.id ).each do |vote|
          log.debug("start vote: #{vote.id}")
          begin
            vote.start
          rescue => e
            log.error( e.inspect )
          end
        end

        Vote.in_progress.after_finish_at.where(chamber_id: chamber.id ).each do |vote|
          log.debug("finish vote: #{vote.id}")
          begin
            vote.finish
          rescue => e
            log.error( e.inspect )
          end
        end

      end
    end

  end

  def log
    @log ||= Logger.new( "#{Rails.root}/log/vote_manager_job.log" )
  end  
end