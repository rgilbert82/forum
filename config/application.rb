require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EmberForum
  class Application < Rails::Application
    config.time_zone = "Pacific Time (US & Canada)"
    config.autoload_paths += %W(#{config.root}/lib)
    config.api_only = true  # for API mode
  end
end
