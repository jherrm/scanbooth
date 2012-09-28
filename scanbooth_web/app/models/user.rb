class User < ActiveRecord::Base
  attr_accessible :name, :email, :scan_file, :mailed, :printed, :external_view_id, :external_download_id
  before_create :generate_filename
  after_create :async_upload_model

  def generate_filename
    self.scan_file = self.name.gsub(/[^a-z0-9\\-]/i,'')
    self.scan_file = self.id if self.scan_file.blank?;
  end

  def scan_file_with_ext
    [self.scan_file, ScanBooth::Application.config.scan_extension].join('.')
  end

  def unique_file_with_ext
    [self.scan_file, self.created_at.strftime('%Y-%m-%d-%H%M%S')].join('_')
  end

  def async_upload_model
    Resque.enqueue(SketchfabUpload, self.id) if ScanBooth::Application.config.scan_viewer_enabled
    Resque.enqueue(FtpUpload, self.id) if ScanBooth::Application.config.scan_download_enabled
  end
end
