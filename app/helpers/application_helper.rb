module ApplicationHelper
  # Creates a clickable div with an action filled in by javascript
  def nav_button_cell(action_type, *icon_names, **options)
    return generate_empty_nav_cell unless action_type.present?

    nav_cell(nav_button(action_type, icon_names, options))
  end

  private

  def generate_empty_nav_cell
    tag.div(class: 'nav-td')
  end

  def nav_cell(contents)
    content_tag(:div, contents, class: 'nav-td')
  end

  # Creats an action link for a nav <div> containing listed icons
  def nav_button(action_type, icon_names, options)
    options[:class] = [
      'btn', action_type, options[:class]
    ].keep_if(&:present?).join(' ')

    content_tag(:div, nav_icons(icon_names), options)
  end

  # Creates inline icons from provided names
  def nav_icons(icon_names)
    icon_names.map { |icon_name| nav_icon(icon_name) }.join.html_safe
  end

  # Creates an icon from a provided name
  def nav_icon(icon_name)
    content_tag(:i, '', class: "nav-icn #{icon_name}")
  end

  def hrule(**options)
    if options[:padding]
      options[:style] ||= ''
      options[:style] += ";padding: #{options.delete(:padding)};"
    end
    if options[:margin]
      options[:style] ||= ''
      options[:style] += ";margin: #{options.delete(:margin)};"
    end
    tag.div(class: 'hrule', **options)
  end
end
