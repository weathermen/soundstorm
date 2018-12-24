# frozen_string_literal: true

module ReleasesHelper
  def cue_link_to(text, href)
    link_to text, href, remote: true, data: { action: 'ajax:success->release#cue' }
  end

  def upload_form_with(**kwargs, &block)
    stimulus = {
      controller: 'upload',
      action: 'direct-uploads:start->upload#start'
    }
    form_with(**kwargs, class: 'form', data: stimulus, &block)
  end
end
