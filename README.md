ScanBooth
=========

ScanBooth is a collection of software for running a 3D photo booth.

What's a 3D photo booth? It's a place where people can get scanned in 3D and get a printout of themselves from a 3D printer. The current version of ScanBooth works with [ReconstructMe](http://reconstructme.net), a 3D scanning app that uses depth cameras like the xbox kinect.

Here's what ScanBooth has to offer:

  - A rails webapp
    - Allows users to enter their contact information when they get scanned.
    - Stores status of user prints, uploads and emails.
  - Delayed job framework
    - Upload scans to [sketchfab](http://sketchfab.com).
    - Upload scans to an FTP server.
    - Email users links to their scans for viewing/downloading.
  - Scan workflow automation
    - Auto launch ReconstructMe and start scan
    - Automated scan cleanup with [meshlab](http://sourceforge.net/projects/meshlab)

How to use ScanBooth
--------------------

This project was used to help scan and print over 90 people at the 2012 [Pittsburgh Mini Maker Faire](http://pghmakerfaire.com). Here is the setup we used:

  - Xbox Kinect mounted on a tripod ([using this kinect tripod mount adapter](http://www.thingiverse.com/thing:6930)).
  - Office chair with the back removed.
  - Makerbot Replicator and Makerbot Cupcake 3D printers.
  - Scanning machine: A windows 7 box running ReconstructMe, meshlab and the automated tools.
  - Printing machine: A mac running the rails web server, [netfabb](http://www.netfabb.com) for print preparation and [replicatorg](http://replicat.org) for slicing and printing.

Each person would enter their name and email address on the scanning machine which had the rails app loaded in a browser. The rails app then saves the information and generates a filename based on the user's name. Since the rails app was hosted by the printing machine, the two needed to be on the same network.

The scanning machine operator would explain what the user needed to do to produce a good scan. The user had to spin around in a circle while keeping completely still. This is a tough concept for children to understand.

The scanning machine operator would start the scan by opening ReconstructMe.ahk. Once the scan was complete the operator would save the scan with the filename provided by the rails app when the user was entered into the system.

The automated cleanup tools scale, rotate, cleanup the scan and move it to a directory that was being shared between the scanning machine and printing machine. We ended up using dropbox for this. Scanning a person took about 4 minutes from them sitting down to having a cleaned scan waiting for the printing machine operator.

The printing machine operator would open the cleaned scans and prepare them for printing using netfabb. The prepped scans are then sent to the printer through replicatorg. Prepping and slicing took about 5-8 minutes total per scan. Printing took about 10-15 minutes per scan. Out of the 90 people we scanned in the 6 hours of the faire, we printed over 40 on the two printers we had.

Installation and configuration
------------------------------

Prerequisites:

  - Ruby 1.9.3, Rails 3
  - AutoHotkey
  - Meshlab
  - ReconstructMe
  - Redis

Download this repository, save it to C:\ScanBooth. *You can place the folder elsewhere, but you'll have to change the paths in the automation scripts.*


Change directory into the scanbooth_web folder, install the required gems, setup your database and start the rails server

    > bundle install
    > rake db:migrate
    > rails s

*You should now be able to see the scanbooth app at [http://localhost:3000](http://localhost:3000)*

Delayed Jobs
------------

Here's how to run the delayed jobs like sketchfab upload, FTP upload, and email delivery:

First, you'll need to enter your settings in `scanbooth_web/config/environments/development.rb`

Configure scan upload path:

    config.scans_path = "/path/to/printable/scans"

To enable sketchfab upload:

    config.scan_view_enabled = true
    config.sketchfab = {
      api_key: "YOUR_API_KEY",
      description: "This is a cool 3D scan.",
      tags: "3Dscan"
    }

To enable ftp upload:

    config.scan_download_enabled = true
    config.ftp = {
      server: "exmaple.com",
      username: "ftp@example.com",
      password: "password"
    }


Start redis

    > redis-server

Start the resque worker

    > QUEUE=* rake environment resque:work

Start the upload process by going to [http://localhost:3000/users](http://localhost:3000/users) and clicking "Upload and Mail"

Currently there's no way to bulk upload/email. A workaround is to start `rails console` and execute the following code:

    User.all.each do |user|
      if !user.mailed && !user.email.blank?
        user.async_upload_model
        puts user.scan_file
      end
    end




TODO
----
- Authentication/authorization
- Admin dashboard
- Bulk user upload/mail

