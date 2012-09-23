ScanBooth::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => '',
    :password             => '',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

  config.scan_mail = {
    from: [config.action_mailer.smtp_settings[:user_name], config.action_mailer.smtp_settings[:domain]].join('@'),
    subject: "Your 3D scan from our booth",
    thanks_message: "We hope you had a great time getting scanned!"
  }

  # Absolute path to location of the scans to upload to external sites
  config.scans_path = "/scans"
  config.scan_extension = "stl"

  config.scan_viewer_enabled = false
  config.scan_view_url = "https://sketchfab.com/show/"

  config.scan_download_enabled = false
  config.scan_download_url = ""

  config.contact_info = {
    name: '',
    email: ''
  }

  config.tweet = {
    text: "Check out my 3D scan",
    hashtags: ""
  }

end
