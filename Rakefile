require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


task :environment do 
    require_relative './config/environment'
end

desc "Test data structures in console environment"
task :console => :environment do
    require 'pry'
    pry.start
end

desc "Loads data for console tests, runs console"
task :console_tests => :environment do
    require 'pry'
    require_relative './console_tests.rb'
 
end

desc "Env playground, same as console tests but not for testing"
task :play => :environment do 
    require 'pry'
    require_relative './playground.rb'
end

namespace :examples do 
    desc "run an example file"
    task :run, [:file] => :environment do |task, args|
        require_relative "./examples/#{args[:file]}.rb"
    end
end