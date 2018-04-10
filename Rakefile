namespace :deploy do
  def deploy(env)
    puts "Deploying to #{env}"
    system "TARGET=#{env} bundle exec middleman deploy"
  end

  task :azure do
    deploy :azure
  end

  task :biomed do
    deploy :biomed
  end
end