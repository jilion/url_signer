require 'spec_helper'

describe UrlSigner do
  let(:url) { "http://google.com/foo/bar?test=true&abc=def" }
  let(:key) { "123456abcdef" }

  describe ".sign_url" do
    it "returns the result of UrlSigner::Signer.sign_url" do
      described_class.sign_url(url, key) == UrlSigner::Signer.new(url, key).sign_url
    end
  end
end
