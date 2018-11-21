require 'test_helper'

module ActivityPub
  class VerificationTest < ActiveSupport::TestCase
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
      @verification = Verification.new(@signature.header, @date, host: "https://#{@host}")
    end

    test 'comparison includes additional headers' do
      assert_equal "https://#{@host}", @verification.options[:host]
      assert_includes @verification.comparison, '(request-target): post /inbox'
      assert_includes @verification.comparison, "host: https://#{@host}"
      assert_includes @verification.comparison, "date: #{@date.httpdate}"
      assert_equal @verification.comparison, @signature.to_unsigned_s
    end

    test 'verify key from remote server' do
      Actor.stub :find, @actor do
        assert_equal @actor.public_key.to_pem, @verification.public_key.to_pem
        assert @verification.verified?, "'#{@verification.comparison}' \n\ncould not be verified by signature '#{@verification.signature}' \n\nwith key '#{@actor.public_key.to_pem}'"
        assert @verification.valid?
      end
    end

    test 'verify date header is not too old' do
      assert @verification.fresh?

      @verification.stub :date, 16.minutes.ago do
        refute @verification.fresh?
      end
    end
  end
end
