module ApplicationHelper
  def flash_messages!
    output = ''
    flash.each do |key, value|
      alert_class = {success: 'success', error: 'danger', alert: 'warning', notice: 'info'}[key.to_sym] || key.to_s
      output += '<div role="alert" class="'
      output += 'alert alert-dismissible alert-' + alert_class + '">'
      output += '<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>'
      output += value.to_s + '</div>'
    end
    output.html_safe
  end
end
