# coding: utf-8
require 'openssl'
require 'cgi'

module JugemKey
  class Auth
    JUGEMKEY_URL = 'https://secure.jugemkey.jp'
    AUTH_API_URL = 'https://api.jugemkey.jp/api/auth'

    def initialize(params)
      @api_key = params[:api_key]
      @secret = params[:secret]
    end

    def uri_to_login(params)
      query = {
        mode:    "auth_issue_frob",
        api_key: @api_key,
        perms:   "read",
        api_sig: api_sig(params)
      }.merge(params).map { |k, v|
        k.to_s + "=" + CGI.escape(v)
      }.join('&')

      URI.join(JUGEMKEY_URL, '?', query)
    end

    private
    def api_sig(params)
      value = "#{@api_key}#{params[:callback_uri]}read"
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, @secret, value)
    end
  end
end

if __FILE__ == $0
  api = JugemKey::Auth.new({
    api_key: '40025ab515df245d2483d758ca9d0680',
    secret:  '1d4c74a7cc19aeb1'
  })
  puts api.uri_to_login({
    callback_url: 'http://jugemkey.jp/' 
  })
end
