# frozen_string_literal: true

module ReleasesHelper
  def cue_link_to(text, href)
    link_to text, href, remote: true, data: { action: 'ajax:success->release#cue' }
  end

  # Override +form_with+ so we're always using Soundstorm's
  # base +FormBuilder+ class unless otherwise noted.
  def form_with(builder: FormBuilder, **kwargs, &block)
    super(builder: builder, **kwargs, &block)
  end

  def release_form(release)
    form_with(
      builder: NestedBuilder,
      model: release,
      data: {
        controller: 'upload nested',
        action: 'direct-uploads:start->upload#start'
      }
    ) { |form| yield(form) }
  end
end
