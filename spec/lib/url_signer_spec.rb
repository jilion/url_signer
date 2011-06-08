require 'spec_helper'

describe UrlSigner do
  let(:url) { "http://google.com/foo/bar?test=true&abc=def" }
  let(:key) { "123456abcdef" }

  describe ".sign_url" do
    it "returns the result of UrlSigner::Signer.sign_url" do
      described_class.sign_url(url, key) == UrlSigner::Signer.new(url, key).signed_url
    end
    
    describe "with normal arguments and passing a block" do
      before(:all) do
        @signed_url = described_class.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key') do |signer|
          signer.path                 = false
          signer.base64_digest_key    = true
          signer.signature_param_name = 'sign'
        end
      end
      subject { @signed_url }

      it "sets url" do
        URI.parse(subject).query.should =~ /^tac=tuc&toc=tic.+/
      end
      
      it "returns an URL with a new signature param appended" do
        URI.parse(subject).query.should =~ /^tac=tuc&toc=tic&sign=.+/
      end
    end
    
  end
end
