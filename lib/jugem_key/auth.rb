# coding: utf-8
require 'cgi'
require 'net/http'
require 'openssl'
require 'rexml/document'
require 'time'

module JugemKey
  class Auth
    JUGEMKEY_URL = 'https://secure.jugemkey.jp'
    AUTH_API_URL = 'https://api.jugemkey.jp/api/auth'

    def initialize(params)
      @api_key = params[:api_key]
      @secret = params[:secret]
    end

    def uri_to_login(params)
      sig = api_sig({
        api_key: @api_key,
        callback_url: params[:callback_url],
        perms: "auth"      
      })

      query = {
        mode:    "auth_issue_frob",
        api_key: @api_key,
        perms:   "auth",
        api_sig: sig
      }.merge(params).map { |k, v|
        k.to_s + "=" + CGI.escape(v)
      }.join('&')

      URI(JUGEMKEY_URL + '?' + query)
    end

    def token(frob)
      sig = api_sig({
        api_key: @api_key,
        created: Time.now.iso8601, 
        frob:    frob
      })
      atom = fetch_atom('http://api.jugemkey.jp/api/auth/token', {
        "X-JUGEMKEY-API-CREATED" => Time.now.iso8601,
        "X-JUGEMKEY-API-KEY"     => @api_key,
        "X-JUGEMKEY-API-FROB"    => frob,
        "X-JUGEMKEY-API-SIG"     => sig
      })

      token = REXML::Document.new(atom).elements['entry/token'].text
      require 'pp'
      pp token 
      token
    end

    def user(token)
      sig = api_sig({
        api_key: @api_key,
        created: Time.now.iso8601, 
        token:   token 
      })
      atom = fetch_atom('http://api.jugemkey.jp/api/auth/user', {
        "X-JUGEMKEY-API-CREATED" => Time.now.iso8601,
        "X-JUGEMKEY-API-KEY"     => @api_key,
        "X-JUGEMKEY-API-TOKEN"   => token,
        "X-JUGEMKEY-API-SIG"     => sig
      })

      user = REXML::Document.new(atom).elements['entry/title'].text
      require 'pp'
      pp user 
      user
    end

    private
    def api_sig(params)
      value = params.map{|k, v| v}.join('')
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, @secret, value)
    end

    def fetch_atom(url, header)
      Net::HTTP.version_1_2
      url = URI.parse(url)

      res = nil 
      Net::HTTP.start(url.host, url.port) do |http|
        res = http.get(url.path, header)
      end

      if res.class == Net::HTTPOK
        res.body
      else
        raise res.message
      end
    end

  end
end
