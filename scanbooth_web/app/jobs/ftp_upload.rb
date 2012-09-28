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

    ftp = Net::FTP.new(FTP_SERVER)
    ftp.login(FTP_USERNAME, FTP_PASSWORD)
    ftp.putbinaryfile(path, File.basename( path ))
    ftp.quit()

    user.external_download_id = filename
    user.save!

    if !user.mailed && ScanBooth::Application.config.scan_viewer_enabled && !user.external_view_id.blank?
      puts 'mailing user from ftp'
      UserMailer.scan_email(user).deliver
      user.mailed = true
      user.save!
    end

  end
end
