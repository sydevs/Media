module ApplicationHelper

  TAG_ICONS = {
    path: 'spa',
    incomplete: 'pencil',
  }

  def tag_icon tag
    tag = tag.to_sym
    TAG_ICONS[tag] if TAG_ICONS.key?(tag)
  end

end
