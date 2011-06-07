module UrlSigner

  autoload :Signer, 'url_signer/signer'

  def self.sign_url(*args)
    Signer.new(*args).sign_url
  end

end
