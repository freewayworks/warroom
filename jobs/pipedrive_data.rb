require 'curl'

SCHEDULER.every '1h', first_in: 0 do
  key = ENV['PIPEDRIVE_API_KEY']
  res = Curl.get("https://api.pipedrive.com/v1/pipelines?api_token=#{key}")
  pipelines = JSON.parse(res.body_str)["data"]

  last_three_days = Date.today-3
  
  sbc_start_date = Date.new(2015, 8, 1)
  start_date = Date.today-5
  end_date = Date.today+1
  puts pipelines
  pipelines.each do |pipeline|
    id = 8
    movement_res = Curl.get("https://api.pipedrive.com/v1/pipelines/#{pipeline["id"]}/movement_statistics?start_date=#{start_date}&end_date=#{end_date}&api_token=#{key}")
    pipeline_movement = JSON.parse(movement_res.body_str)
    puts "#{pipeline["name"]} moved #{pipeline_movement["data"]["movements_between_stages"]["count"]}"
    send_event("pipeline_#{pipeline["id"]}_fiveday_movements", { current: pipeline_movement["data"]["movements_between_stages"]["count"] })

    conversion_res = Curl.get("https://api.pipedrive.com/v1/pipelines/#{pipeline["id"]}/conversion_statistics?start_date=#{sbc_start_date}&end_date=#{end_date}&api_token=#{key}")
    pipeline_conversion = JSON.parse(conversion_res.body_str)
    puts "#{pipeline["name"]} converted #{pipeline_conversion["data"]["won_conversion"]} steps"
    send_event("pipeline_#{pipeline["id"]}_won", { current: pipeline_conversion["data"]["won_conversion"] })
    send_event("pipeline_#{pipeline["id"]}_lost", { current: pipeline_conversion["data"]["lost_conversion"] })
  end
end
