module UrlSigner

  autoload :Signer, 'url_signer/signer'

  def self.sign_url(*args)
    Signer.new(*args) do |signer|
      yield(signer) if block_given?
    end.signed_url
  end

end
