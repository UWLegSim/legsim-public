LEGSIM_COPYRIGHT = '2001 - 2020'

Time::DATE_FORMATS[:long_with_time] = "%B %e, %Y %I:%M %p"
Time::DATE_FORMATS[:long] = "%B %e, %Y"
Time::DATE_FORMATS[:short_with_time] = "%b %e, %I:%M %p"
Time::DATE_FORMATS[:short] = "%b %e"
Time::DATE_FORMATS[:short_with_year] = "%b %e, %Y"

Time::DATE_FORMATS[:date_entry] = "%m/%d/%Y"
Time::DATE_FORMATS[:time_entry] = "%I:%M %p"

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x)
    (self * 10**x).floor.to_f / 10**x
  end
end