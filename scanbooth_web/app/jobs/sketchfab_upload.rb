require "uri"
require "net/https"
require "base64"
require "rubygems"
require "json"

module SketchfabUpload
  @queue = :upload
  API_KEY = ""
  URL = "https://api.sketchfab.com/model"

  def self.perform(user_id)

    user = User.find(user_id)
    filename = user.scan_file_with_ext
    path = [ScanBooth::Application.config.scans_path, filename].join('/')
    title = user.name || filename
    desc = ""
    tags = ""
    # thumbnail_filename="/data/thumbnail.png"

    contents = Base64.encode64(File.read(path))

    # thumbnail = Base64.encode64(File.read(thumbnail_filename))
    data = {
        title: title,
        description: desc,
        contents: contents,
        filename: filename,
        tags: tags,
        # thumbnail: thumbnail,
        token: API_KEY
    }

    uri = URI.parse(URL)
    p uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request.body = data.to_json

    response = http.request(request)

    data = JSON.parse(response.body)

    if data['success']
      user.external_view_id = data['id']
      user.save!
      UserMailer.scan_email(user).deliver
      p "https://sketchfab.com/show/#{data['id']}"
    else
      p "Upload to sketchfab failed: #{response.body}"
    end

  end
end
