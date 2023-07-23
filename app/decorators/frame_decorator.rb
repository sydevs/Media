# frozen_string_literal: true

module FrameDecorator

  def url
    # folder = video? ? 'videos' : 'images'
    # image_url("prototype/#{folder}/#{media.filename}")
    #folder = video? ? 'videos' : 'images'
    #filename = media.filename.base + '.' + (video? ? 'webm' : 'webp')
    #image_url("prototype/#{folder}/#{filename}")
    media.url
  end

  def to_html(preload: false, **attributes)
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
