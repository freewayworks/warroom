require 'date'
require 'time_difference'

start_day = DateTime.new(2015, 8, 1, 8, 0)
demo_day = DateTime.new(2015, 11, 17, 15, 0)

SCHEDULER.every '1s' do
  total_timespan = TimeDifference.between(start_day, demo_day)
  elapsed_timespan = TimeDifference.between(start_day, DateTime.now)
  remaining_timespan = TimeDifference.between(demo_day, DateTime.now)

  send_event('seconds_till_demoday', { current: remaining_timespan.in_seconds })
  send_event('hours_till_demoday', { current: remaining_timespan.in_hours })
  send_event('days_till_demoday', { current: remaining_timespan.in_days })
  send_event('time_elapsed',   { value: (elapsed_timespan.in_seconds/total_timespan.in_seconds)*100 })
end
