app_path = 'app'

config =

  app_path: app_path
  web_path: 'web'
  vendor_path: 'vendor'
  assets_path: app_path + '/assets'

  app_main_file: 'app.js'
  css_main_file: 'app.css'
  less_main_file: app_path + '/app.less'
  templates_file: 'app.templates.js'
  templates_module: 'devops-metrix'
  vendor_main_file: 'vendor.js'

module.exports = config
