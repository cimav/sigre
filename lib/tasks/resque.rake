require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'resque_bus/tasks'

namespace :resque do
  task :setup => [:environment] do
    require 'resque_scheduler'
    require 'resque/scheduler'
  end
end
