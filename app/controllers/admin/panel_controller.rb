class Admin::PanelController < Admin::AdminController
  def index

  end

  def tba_imports
    @events = Event.events_this_year
    @year = Time.current.strftime("%Y")
  end
end
