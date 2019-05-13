# frozen_string_literal: true

# name: discourse-spoiler-alert
# about: Uses the Spoiler Alert plugin to blur text when spoiling it.
# version: 0.4
# authors: Robin Ward, Regis Hanol
# url: https://github.com/discourse/discourse-spoiler-alert

enabled_site_setting :spoiler_enabled

register_asset "javascripts/spoiler.js"
register_asset "stylesheets/discourse_spoiler_alert.css"

after_initialize do

  # black out spoilers in emails
  Email::Styles.register_plugin_style do |fragment|
    fragment.css(".spoiler").each do |spoiler|
      spoiler["style"] = "color: #000; background-color: #000;"
    end
  end

  # remove spoilers in embedded comments
  on(:reduce_cooked) do |fragment|
    fragment.css(".spoiler").remove
  end

  on(:pre_notification_alert) do |user, payload|
    payload[:excerpt] = payload[:excerpt].gsub(/\<span class=\"spoiler\"\>.*\<\/span\>/, "[#{I18n.t 'spoiler_alert.excerpt_spoiler'}]")
  end
end
