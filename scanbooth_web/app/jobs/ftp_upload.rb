require 'net/ftp'

module FtpUpload
  @queue = :upload
  FTP_SERVER   = ""
  FTP_USERNAME = ""
  FTP_PASSWORD = ""

  def self.perform(user_id)

    user = User.find(user_id)
    filename = user.scan_file_with_ext
    path = [ScanBooth::Application.config.scans_path, filename].join('/')

    ftp = Net::FTP.new(server)
    ftp.login(username, password)
    ftp.putbinaryfile(path, File.basename( path ))
    ftp.quit()

    user.external_download_id = filename
    user.save!
  end
end
