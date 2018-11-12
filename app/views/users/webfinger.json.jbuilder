# WebFinger Response

json.subject "acct:#{@user.handle}"
json.array! :links do |link|
  link.rel 'self'
  link.type 'application/activity+json'
  link.href url_for(@user, format: :json)
end
