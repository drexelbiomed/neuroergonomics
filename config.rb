###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
# which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

require 'yaml'


YAML.load(File.open('data/ftp.yml')).each do |key, value|
  ENV[key.to_s] = value
end if File.exists?('data/ftp.yml')

helpers do
  def data
    cnf = YAML::load(File.open('data/ftp.yml'))
  end

  def prefix
    build? ? ENV["alias"] : "/"
  end

  def parent_pages
    ["Call for Abstracts", "Submissions", "Venue", "About", "Program", "Other"]
  end

  def sidebar?
    s = current_resource.data.category
    parent_pages.any? { |i| i[s] }
  end
end

###
# Environment List
###

# Server Environment
configure :server do

  # Debug assets
  set :debug_assets, true

end

# Development Environment
configure :development do

  #To activate the middleman-sprockets
  activate :sprockets
  sprockets.append_path File.join root, "bower_components"

  # Automatic image dimensions on image_tag helpers
  activate :automatic_image_sizes

  # Reload the browser automatically whenever files change
  activate :livereload,  :no_swf => true

  # Haml Configuration
  # Disable Haml warnings
  Haml::TempleEngine.disable_option_validator!
  Haml::Options.defaults[:format] = :html5

  # Assets Pipeline Sets
  set :css_dir, 'assets/stylesheets'
  set :js_dir, 'assets/javascripts'
  set :images_dir, 'assets/images'
  set :fonts_dir, 'assets/fonts'

  # Pretty URLs
  # activate :directory_indexes

end

# Build Environment
configure :build do

  #To activate the middleman-sprockets
  activate :sprockets

  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # GZIP text files
  # activate :gzip

  # Use relative URLs
  activate :relative_assets

  ignore "*.psd"

  # Middleman Deploy (https://github.com/middleman-contrib/middleman-deploy/)
  activate :deploy do |deploy|
    deploy.deploy_method   = :ftp
    deploy.host            = ENV["host"]
    deploy.path            = ENV["path"]
    deploy.user            = ENV["user"]
    deploy.password        = ENV["pass"]
    deploy.build_before = true
  end

end

# Production Environment
configure :production do

  # Assets Pipeline Sets
  set :css_dir, 'assets/stylesheets'
  set :js_dir, 'assets/javascripts'
  set :images_dir, 'assets/images'
  set :fonts_dir, 'assets/fonts'

  # Middleman Production dev server run code
  # 'middleman server -e production'

end
