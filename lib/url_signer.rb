module UrlSigner

  autoload :Signer, 'url_signer/signer'

  def self.signed_url(*args)
    Signer.new(*args) do |signer|
      yield(signer) if block_given?
    end.signed_url
  end

  def self.signature(*args)
    Signer.new(*args) do |signer|
      yield(signer) if block_given?
    end.signature
  end

end
