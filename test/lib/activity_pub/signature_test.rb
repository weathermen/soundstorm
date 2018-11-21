require 'test_helper'

module ActivityPub
  class SignatureTest < ActiveSupport::TestCase
    setup do
      @host = 'test.host'
      @date = Time.current.utc
      private_key_path = Rails.root.join('test', 'fixtures', 'files', 'actor.pem')
      private_key = OpenSSL::PKey::RSA.new(private_key_path.read)
      @actor = Actor.new(
        name: 'actor',
        host: @host,
        key: private_key,
        secret: 'foo',
        summary: 'Foo Bar'
      )
      @signature = Signature.new(
        id: "https://#{@host}/actor#main-key",
        host: @host,
        key: @actor.private_key,
        date: @date
      )
    end

    test 'unsigned string' do
      assert_includes @signature.to_unsigned_s, "host: https://#{@host}"
      assert_includes @signature.to_unsigned_s, "date: #{@date.httpdate}"
      assert_includes @signature.to_unsigned_s, "(request-target): post /inbox"
    end

    test 'signed string' do
      assert @signature.to_s.present?
      assert @signature.key.verify(ActivityPub.digest, @signature.to_s, @signature.to_unsigned_s)
    end

    test 'attributes' do
      assert_equal @signature.id, @signature.attributes[:keyId]
      assert_equal Signature::DEFAULT_HEADERS, @signature.attributes[:headers]
      assert_equal @signature.to_s, @signature.attributes[:signature]
    end

    test 'http header' do
      assert_includes @signature.header, %(keyId="#{@signature.id}")
      assert_includes @signature.header, %(headers="#{Signature::DEFAULT_HEADERS}")
      assert_includes @signature.header, %(signature="#{@signature.to_s}")
    end
  end
end
