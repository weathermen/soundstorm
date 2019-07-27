# frozen_string_literal: true

require 'test_helper'

class VersionsControllerTest < ActionDispatch::IntegrationTest
  test 'post activity to inbox' do
    queue = ApplicationJob.queue_adapter
    host = 'other.host'
    date = Time.current.utc
    private_key_path = Rails.root.join('test', 'fixtures', 'files', 'actor.pem')
    private_key = OpenSSL::PKey::RSA.new(private_key_path.read)
    actor = ActivityPub::Actor.new(
      name: 'actor',
      host: host,
      key: private_key,
      secret: 'foo',
      summary: 'Foo Bar'
    )
    signature = ActivityPub::Signature.new(
      id: "https://#{host}/actor#main-key",
      host: host,
      key: actor.private_key,
      date: date
    )

    ActivityPub::Actor.stub :find, actor do
      post inbox_path, \
           params: {
             '@context': ActivityPub::ACTIVITYSTREAMS_NAMESPACE,
             id: 'https://test.host/one/untitled/comments/12345',
             type: 'Create',
             actor: actor.id,
             object: {
               type: 'Note',
               id: 'https://test.host/one/untitled/comments/12345',
               content: 'hello world'
             }
           },
           headers: {
             'Signature': signature.header,
             'Date': date.httpdate,
             'Host': "https://#{actor.host}"
           }

      assert_response :ok
      refute_empty queue.enqueued_jobs
      assert_includes queue.enqueued_jobs.map { |j| j[:job] }, UpdateActivityJob
    end
  end
end
