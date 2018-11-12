# ActivityStreams Actor JSON Response

json.set! :@context, [
  'https://www.w3.org/ns/activitystreams',
  'https://w3id.org/security/v1'
]
json.id url_for(@user, format: :json)
json.type 'Person'
json.preferred_username @user.name
json.inbox inbox_url_for(@user)
json.public_key do |key|
  key.id url_for(@user, format: :json, anchor: 'main-key')
  key.owner url_for(@user, format: :json)
  key.public_key_pem @user.public_key.to_pem
end
