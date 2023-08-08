# frozen_string_literal: true

module FrameDecorator

  def to_html(preload: false, gender: :male, **attributes)
    url = media(gender).url

    if preload
      attributes['src'] = url
    else
      attributes['data-src'] = url
    end

    if video?
      attributes.merge!(muted: true, loop: true, preload: 'auto')
    end

    attributes['data-id'] = id
    content_tag (video? ? :video : :img), nil, **attributes
  end

end
