require 'fileutils'

desc "Create nondigest versions of all ckeditor digest assets"
task "assets:precompile" => :environment do
  fingerprint = /\-([0-9a-f]{32})\./
  for file in Dir["public/assets/ckeditor/**/*"]
    # Skip file unless it has a fingerprint
    next unless file =~ fingerprint

    # Get filename of this file without the digest
    # (example) public/assets/ckeditor/config.js
    nondigest = file.sub fingerprint, '.'

    # Create a filename relative to public/assets
    # (example) public/assets/ckeditor/config.js => ckeditor/config.js
    filename = nondigest.sub 'public/assets/', ''
    filename = filename.sub /.gz$/, ''          # Remove .gz for correct asset checking

    # Debug information
    STDOUT.puts '---- ' + file + ' ----'
    STDOUT.puts 'searching digest for ' + filename
    # Fetch the latest digest for this file from assets
    if Rails.application.assets.find_asset(filename)
      latest_digest = Rails.application.assets.find_asset(filename).digest

      # Compare digest of this file to latest digest
      # [1] is the enclosed capture in the fingerprint regex above
      this_digest = file.match(fingerprint)[1]
      if this_digest == latest_digest
        # This file's digest matches latest digest, copy
        STDOUT.puts 'Matching digest, copying ' + file
        FileUtils.cp file, nondigest, verbose: true
      else
        # This file's digest doesn't match latest digest, ignore
        STDOUT.puts 'Latest digest: ' + latest_digest
        STDOUT.puts 'This digest:   ' + this_digest
        STDOUT.puts 'Non-matching digest, not copying ' + file
      end
    end

    # Debug information
    STDOUT.puts '---- end ----'
  end

  for file in Dir["app/assets/javascripts/ckeditor/plugins/*"]
    FileUtils.cp_r file, 'public/assets/ckeditor/plugins/'
  end
end
