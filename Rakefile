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