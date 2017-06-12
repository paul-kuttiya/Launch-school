module ApplicationHelper
  def title(name)
    name.capitalize.pluralize
  end
end
