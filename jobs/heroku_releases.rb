require 'curb'

SCHEDULER.every '1h', first_in: 0 do
  heroku_apps = ['add-campaign', 'freeway-taxi']

  heroku_apps.map do |app_name|
    res = Curl.get("https://api.heroku.com/apps/#{app_name}/releases") do |http|
      http.headers['Accept'] = 'application/vnd.heroku+json; version=3'
      http.headers['Authorization'] = "Bearer #{ENV['HEROKU_API_KEY']}"
      puts http.headers
    end
  
    json_result = JSON.parse(res.body_str)
    last_version = json_result.last["version"]
    version_count = json_result.count
    puts "#{app_name} version: #{last_version}"
    send_event("#{app_name}_last_version", { current: last_version })
    send_event("#{app_name}_version_count", { current: version_count })
  end
end
