# FIXME: Delete this file once the twitter-bootstrap-rails gem is patched.
# Otherise you can't deploy to heroku.
# https://github.com/seyhunak/twitter-bootstrap-rails/issues/338
module BootstrapFlashHelper  
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip Devise :timeout and :timedout flags
      next if type == :timeout
      next if type == :timedout
      type = :success if type == :notice
      type = :error   if type == :alert
      text = content_tag(:div, 
               content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
               message, :class => "alert fade in alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
end
