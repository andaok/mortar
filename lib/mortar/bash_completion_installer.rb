#!/usr/bin/env ruby

require 'pathname'
require 'fileutils'

completion_file = File.expand_path('../../opt/bash-completion.sh', Pathname.new(__dir__).realpath)

paths = %w(
  /etc/bash_completion.d/mortar.bash
  /usr/local/etc/bash_completion.d/mortar.bash
  /usr/share/zsh/site-functions/_mortar
  /usr/local/share/zsh/site-functions/_mortar
  /usr/local/share/zsh-completions/_mortar
)
paths << File.join(Dir.home, '.bash_completion.d', 'mortar.bash')

installed = []

paths.each do |path|
  if File.directory?(File.dirname(path))
    begin
      FileUtils.ln_sf(completion_file, path)
      installed << path
    rescue Errno::EACCES, Errno::EPERM
    end
  end
end

if installed.empty?
  warn "Installation failed"
  warn "Try with sudo or set up user bash completions in ~/.bash_completion to include files from ~/.bash_completion.d"
  exit 1
else
  puts "Completions installed to:"
  installed.each do |path|
    puts "  - #{path}"
  end
  puts
  puts "The completions will be reloaded when you start a new shell. To load now, use:"
  puts "  source \"#{completion_file}\""
  exit 0
end

