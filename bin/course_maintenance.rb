Course.all.each do |course|
  course.set_status.save
end