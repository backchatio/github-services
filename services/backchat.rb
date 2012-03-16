class Service::BackchatIO < Service
  string :branches

  def receive_push
    branches = data['branches'].to_s.split(/\s+/)
    ref = payload["ref"].to_s
    return unless branches.empty? || branches.include?(ref.split("/").last)

    http.headers['Content-Type'] = 'application/json'

    res = http_post "https://URL_HERE/changesets/github",
      JSON.generate(payload)
      
    if res.status < 200 || res.status > 299
      raise_config_error
    end
  end
end
