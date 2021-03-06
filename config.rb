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

helpers do
  def prefix
    build? ? "/neuroergonomics/" : "/"
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
  activate :livereload,  :no_swf => true, :host => '0.0.0.0'

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
  case ENV['TARGET'].to_s.downcase
    when 'biomed'
      activate :deploy do |deploy|
        deploy.deploy_method   = :ftp
        deploy.host            = ENV["BIOMED_HOST"]
        deploy.path            = ENV["BIOMED_PATH"] + "neuroergonomics"
        deploy.user            = ENV["BIOMED_USER"]
        deploy.password        = ENV["BIOMED_PASS"]
        deploy.build_before = true
      end
    when 'azure'
      activate :deploy do |deploy|
        deploy.deploy_method   = :ftp
        deploy.host            = ENV["AZURE_HOST"]
        deploy.path            = ENV["AZURE_PATH"] + "/events/neuroergonomics"
        deploy.user            = ENV["AZURE_USER"]
        deploy.password        = ENV["AZURE_PASS"]
        deploy.build_before = true
      end
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
