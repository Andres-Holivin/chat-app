# Override javascript tasks since assets are already built by bun
Rake::Task["javascript:build"].clear if Rake::Task.task_defined?("javascript:build")
Rake::Task["javascript:install"].clear if Rake::Task.task_defined?("javascript:install")
Rake::Task["css:build"].clear if Rake::Task.task_defined?("css:build")

namespace :javascript do
  task :install do
    # Dependencies already installed by Bun
    puts "Skipping javascript:install - dependencies already installed by Bun"
  end
  
  task :build do
    # Assets are already built by Bun, skip this step
    puts "Skipping javascript:build - assets already built by Bun"
  end
end

namespace :css do
  task :build do
    # CSS already built by Bun
    puts "Skipping css:build - CSS already built by Bun"
  end
end
