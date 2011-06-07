require 'base64'
require 'uri'
require 'hmac'
require 'hmac-sha1'

module UrlSigner
  class Signer

    attr_accessor :url_to_sign, :private_key

    def initialize(url_to_sign, private_key)
      @url_to_sign = url_to_sign
      @private_key = private_key
    end

    def sign_url
      @parsed_url_to_sign = URI.parse(@url_to_sign)
      query_string = sorted_query_string

      url_to_sign  = @parsed_url_to_sign.path + '?'
      url_to_sign += "#{query_string}&" unless query_string.empty?

      signature = generate_signature(url_to_sign)

      "#{@parsed_url_to_sign.scheme}://#{@parsed_url_to_sign.host}#{url_to_sign}signature=#{signature}"
    rescue
      ''
    end

  private

    def sorted_query_string
      @parsed_url_to_sign.query.split('&').sort.join('&')
    rescue
      ''
    end

    def generate_signature(url_to_sign)
      # 1/ decode the private key
      decoded_private_key = url_safe_base64_decode(@private_key)

      # 2/ create a signature using the private key and the URL
      signature = HMAC::SHA1.digest(decoded_private_key, url_to_sign)

      # 3/ encode the signature into base64 for url use form.
      url_safe_base64_encode(signature)
    end

    def url_safe_base64_decode(base64_string)
      Base64.decode64(base64_string.tr('-_','+/'))
    end

    def url_safe_base64_encode(raw_string)
      Base64.encode64(raw_string).tr('+/','-_')
    end

  end
end
