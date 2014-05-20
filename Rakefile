require 'puppetlabs_spec_helper/rake_tasks'

# from https://github.com/thomasvandoren/puppet-build-files/blob/1626f3986eaa2b9cc3ef96be4aa80b651887e636/Rakefile
desc 'Validate syntax for all manifests.'
task :syntax do
  successes = []
  failures = []
  Dir.glob('**/*.pp').each do |puppet_file|
    puts "Checking syntax for #{puppet_file}"

    # Run syntax checker in subprocess.
    system("puppet parser validate #{puppet_file}")

    # Keep track of the results.
    if $?.success?
      successes << puppet_file
    else
      failures << puppet_file
    end
  end

  # Print the results.
  total_manifests = successes.count + failures.count
  puts "#{total_manifests} files total."
  puts "#{successes.count} files succeeded."
  puts "#{failures.count} files failed:"
  puts
  failures.each do |filename|
    puts filename
  end

  # Fail the task if any files failed syntax check.
  if failures.count > 0
    fail("#{failures.count} failed failed syntax check.")
  end
end
