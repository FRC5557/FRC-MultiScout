class Admin::AdminController < ApplicationController
  before_action :check_permissions
  
  private
  def check_permissions
    if user_signed_in?
      if !current_user.is_administrator
        redirect_back fallback_location: root_path, alert: I18n.t('admin.permissions')
      end
    else
      redirect_back fallback_location: root_path, alert: I18n.t('admin.sign_in')
    end
  end
end
