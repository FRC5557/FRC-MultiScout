module ErrorUtil
  def error_not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
