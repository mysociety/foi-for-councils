# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join(
  'gems', 'hackney_template', 'source', 'assets', 'images'
)
Rails.application.config.assets.paths << Rails.root.join(
  'gems', 'hackney_template', 'source', 'assets', 'javascripts'
)
Rails.application.config.assets.paths << Rails.root.join(
  'gems', 'hackney_template', 'source', 'assets', 'stylesheets'
)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[
  favicon.ico
  hackney-template*.css
  fonts*.css
  hackney-template.js
  ie.js
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
  apple-touch-icon-152x152.png
  apple-touch-icon.png
  gov.uk_logotype_crown_invert.png
  gov.uk_logotype_crown_invert_trans.png
  gov.uk_logotype_crown.svg
  opengraph-image.png
  hackney-logo-green.svg
  hackney-logo-green-trans.png
]
