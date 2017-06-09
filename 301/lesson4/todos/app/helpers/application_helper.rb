module ApplicationHelper
  def shorten(string, limit=7)
    string.size > limit ? string[0..limit] + '...' : string
  end
end
