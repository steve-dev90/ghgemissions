module ApplicationHelper
  # Available for all views
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Carbon Foot Prints'
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def previous_month
    Date.parse(Time.new.to_s).prev_month
  end
end
