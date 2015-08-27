require 'curb'

SCHEDULER.every '30m', first_in: 0 do
  res = Curl.get("https://api.mongolab.com/api/1/databases/heroku_f6jcf8sl/collections/rides?q={\"state\":\"ended\"}&apiKey=#{ENV['MONGOLAB_API_KEY']}") do |http|
  end
  puts "++++++++++++++++++++++++++++++"
  puts "https://api.mongolab.com/api/1/databases/heroku_f6jcf8sl/collections/rides?q={\"state\":\"ended\"}&apiKey=#{ENV['MONGOLAB_API_KEY']}"
  json_response = JSON.parse(res.body_str)
  puts json_response
  send_event("ended-ride-count", { current: json_response.count })
end

