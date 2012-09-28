require "uri"
require "net/https"
require "base64"
require "rubygems"
require "json"

module SketchfabUpload
  @queue = :upload
  API_KEY = ""
  # Get your API key from your sketchfab account dashboard.
  URL = "https://api.sketchfab.com/model"

  def self.perform(user_id)

    user = User.find(user_id)
    filename = user.scan_file_with_ext
    path = [ScanBooth::Application.config.scans_path, filename].join('/')
    # thumbnail_filepath = [ScanBooth::Application.config.scans_path, filename<<".png"].join('/')
    title = user.name || filename
    desc = ""
    tags = ""


    contents = Base64.encode64(File.read(path))
    # thumbnail = Base64.encode64(File.read(thumbnail_filepath))

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

      if !user.mailed && ScanBooth::Application.config.scan_download_enabled && !user.external_download_id.blank?
        puts 'mailing user from sketchfab'
        UserMailer.scan_email(user).deliver
        user.mailed = true
        user.save!
      end
      p "https://sketchfab.com/show/#{data['id']}"
    else
      p "Upload to sketchfab failed: #{response.body}"
    end

  end
end
