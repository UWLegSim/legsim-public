# frozen_string_literal: true
class CourseManagerJob < ApplicationJob

  def perform
    now = Time.now
    Course.to_be_made_pending.each do |course|
      course.update!( :status => 'pending' )
    end

    Course.to_be_made_active.each do |course|
      course.update!( :status => 'active' )
    end

    Course.to_be_made_inactive.each do |course|
      course.update!( :status => 'inactive' )
    end

    Course.to_be_made_archive.each do |course|
      course.update!( :status => 'archive' )
    end
  end
end