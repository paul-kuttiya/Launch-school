module ApplicationHelper
  def display_datetime(dt)
    dt.in_time_zone("Eastern Time (US & Canada)")
  end  
end
