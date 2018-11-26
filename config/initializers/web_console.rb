# frozen_string_literal: true

# Allow web console in Docker
if Rails.env.development?
  docker_ips = Socket.ip_address_list.reduce([]) do |res, addrinfo|
    addrinfo.ipv4? ? res << IPAddr.new(addrinfo.ip_address).mask(24) : res
  end
  WebConsole::Request.whitelisted_ips = WebConsole::Whitelist.new(docker_ips)
end
