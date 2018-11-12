# ActivityStreams Actor JSON Response

json.set! :@context, Rails.configuration.activity_streams_context
json.id url_for(@user, format: :json)
json.type 'Person'
json.preferred_username @user.name
json.inbox inbox_url
json.public_key do |key|
  key.id url_for(@user, anchor: 'main-key')
  key.owner url_for(@user, format: :json)
  key.public_key_pem @user.public_key.to_pem
end
