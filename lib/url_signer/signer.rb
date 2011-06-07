require 'base64'
require 'uri'
require 'hmac'
require 'hmac-sha1'

module UrlSigner
  class Signer

    attr_accessor :url_to_sign, :private_key, :options
    ALLOWED_OPTIONS = [:path, :order_query, :base64_private_key, :signature_key]

    def initialize(*args)
      @options = { :path => true, :order_query => true, :base64_private_key => false, :signature_key => 'signature' }
      @options.merge!(args.pop) if args.last.kind_of? Hash
      @url_to_sign, @private_key = args.shift(2)

      block_given? ? yield(self) : self

      raise ArgumentError.new("URL to sign needed (pass it as the first argument, or via the block-definition)!") unless @url_to_sign
      raise ArgumentError.new("Private key needed (pass it as the second argument, or via the block-definition)!") unless @private_key

      @url_to_sign = URI.parse(@url_to_sign)
    end

    def sign_url
      url_part_to_sign = (@options[:path] ? @url_to_sign.path : '') + sorted_query_string

      "#{@url_to_sign.scheme}://" +
      @url_to_sign.host +
      "#{@url_to_sign.path}?" +
      (@url_to_sign.query && !@url_to_sign.query.empty? ? @url_to_sign.query + '&' : '') +
      "#{@options[:signature_key]}=#{signature(url_part_to_sign)}"
    rescue => ex
      puts ex.message
      ''
    end

    def method_missing(method_name, args)
      if opt_key = ALLOWED_OPTIONS.detect { |opt| method_name.to_s =~ /#{opt}(=)?/ }
        $1 ? @options[opt_key] = args : @options[opt_key]
      else
        super
      end
    end

    def respond_to?(method_name)
      ALLOWED_OPTIONS.detect { |opt| method_name.to_s =~ /#{opt}=?/ }
    end

  private

    def sorted_query_string
      '?' + (@options[:order_query] ? @url_to_sign.query.split('&').sort.join('&') : @url_to_sign.query)
    rescue
      '?'
    end

    def signature(url_to_sign)
      # 1/ decode the private key
      decoded_private_key = @options[:base64_private_key] ? url_safe_base64_decode(@private_key) : @private_key

      # 2/ create a signature using the private key and the URL
      signature = HMAC::SHA1.digest(decoded_private_key, url_to_sign)

      # 3/ encode the signature into base64 for url use form.
      @signature ||= url_safe_base64_encode(signature).strip!
    end

    def url_safe_base64_decode(base64_string)
      Base64.decode64(base64_string.tr('-_','+/'))
    end

    def url_safe_base64_encode(raw_string)
      Base64.encode64(raw_string).tr('+/','-_')
    end

  end
end
