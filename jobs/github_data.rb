require 'octokit'

SCHEDULER.every '1h', first_in: 0 do
  github_client = Octokit::Client.new access_token: ENV['GITHUB_API_KEY']

  #hourly_commits = 0
  daily_commits = 0
  repos = github_client.org_repos(ENV['GITHUB_ORG']).map do |repo|
    puts repo
    puts "handling #{repo.full_name}"
    daily_commits = daily_commits + github_client.commits_since(repo.full_name, Date.today).count
  end
  send_event('github_repository_count', { current: repos.count })
  send_event('github_repository_daily_commits', { current: daily_commits })
end
