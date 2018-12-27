# frozen_string_literal: true

module ReleasesHelper
  START_DIRECT_UPLOAD_ACTION = 'direct-uploads:start->upload#start'

  # Link to cue the next track into the multi-player.
  def cue_link_to(text, href)
    link_to text, href, remote: true, data: { action: 'ajax:success->release#cue' }
  end

  # Override +form_with+ so we're always using Soundstorm's
  # base +FormBuilder+ class unless otherwise noted.
  def form_with(builder: FormBuilder, **kwargs, &block)
    super(builder: builder, **kwargs, &block)
  end

  def release_form(release, &block)
    form_with(
      builder: NestedBuilder,
      model: release,
      data: {
        controller: 'upload nested',
        action: START_DIRECT_UPLOAD_ACTION
      },
      &block
    )
  end

  def upload_form_with(**kwargs, &block)
    upload = {
      controller: 'upload',
      action: START_DIRECT_UPLOAD_ACTION
    }
    form_with(**kwargs, data: upload, &block)
  end
end
