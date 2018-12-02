# frozen_string_literal: true

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
    @track = @user.tracks.build(
      name: 'audio one',
      description: 'foo'
    )
    @track.audio.attach(
      io: Rails.root.join('test', 'fixtures', 'files', 'one.mp3').open,
      filename: 'one.mp3'
    )
    @track.save!
  end

  test 'activitypub representation' do
    assert_equal @track.activity_id, @track.as_activity[:id]
    assert_equal 'Audio', @track.as_activity[:type]
    assert_equal @track.name, @track.as_activity[:name]
    assert @track.as_activity.key?(:url)
    assert_equal 'Link', @track.as_activity[:url][:type]
    assert_equal @track.audio_url, @track.as_activity[:url][:href]
    assert_equal @track.audio.content_type, @track.as_activity[:url][:mediaType]
  end

  test 'waveform generated after create' do
    assert_enqueued_jobs 1, only: GenerateWaveformJob
  end
end
