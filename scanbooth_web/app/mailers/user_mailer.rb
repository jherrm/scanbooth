class UserMailer < ActionMailer::Base
  default from: ScanBooth::Application.config.scan_mail[:from]
  def scan_email(user)
    @user = user
    @scan_view_url = [ScanBooth::Application.config, @user.external_view_id].join
    @scan_download_url = [ScanBooth::Application.config.scan_download_url, @user.external_download_id].join
    mail(:to => @user.email, :subject => ScanBooth::Application.config.scan_mail[:subject])
  end
end
