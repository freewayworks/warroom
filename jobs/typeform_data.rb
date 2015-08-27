require 'curb'

SCHEDULER.every '15m', first_in: 0 do
  forms = [{name: 'Pilot Booking', id: 'mBaqXS'}]
  
  forms.map do |form|
    res = Curl.get("https://api.typeform.com/v0/form/#{form[:id]}?key=#{ENV['TYPEFORM_API_KEY']}&completed=true&limit=1000") do |http|
    end

    json_result = JSON.parse(res.body_str)
    puts json_result
    puts json_result["stats"]["responses"]["completed"]
  
    send_event("#{form[:id]}-response-completions", { current: json_result["stats"]["responses"]["completed"] })
    send_event("#{form[:id]}-response-total", { current: json_result["stats"]["responses"]["total"] })
  end
end
