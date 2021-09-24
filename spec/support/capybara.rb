require "capybara/rspec"
require "capybara/rails"
require "capybara-inline-screenshot/rspec"

Capybara.default_max_wait_time = 2 # the default is 2

Capybara.register_driver :selenium_chrome do |app|
  # increase default http timeout to prevent timeouts in CI
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 120
  client.read_timeout = 120

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument "--window-size=1024,768"
  options.add_argument "--headless" if ENV.fetch("HEADLESS", "false") == "true"
  options.add_argument "--ssl-key-log-file=tmp/chrome.sslkeylog"
  options.add_argument "--disable-quic"

  Capybara::Selenium::Driver.new(
    app,
    http_client: client,
    browser: :chrome,
    clear_local_storage: true,
    clear_session_storage: true,
    options: options,
  )
end

Capybara.javascript_driver = :selenium_chrome unless ENV.fetch("NOT_CHROME", false)

Capybara::Screenshot.webkit_options = {
  width: 1024,
  height: 768,
}

# Webdrivers.cache_time = 1.month.to_i
# Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_driver(:selenium_chrome) do |driver, path|
  needed_height = Capybara.current_session.evaluate_script("document.documentElement.scrollHeight") + 150
  current_width = driver.browser.manage.window.size[0]
  driver.browser.manage.window.resize_to(current_width, needed_height)

  driver.browser.save_screenshot(path)
end
