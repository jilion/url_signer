require 'spec_helper'

describe UrlSigner do
  let(:url) { "http://google.com/foo/bar?test=true&abc=def" }
  let(:key) { "123456abcdef" }

  describe ".signed_url" do
    it "returns the result of UrlSigner::Signer.signed_url" do
      described_class.signed_url(url, key) == UrlSigner::Signer.new(url, key).signed_url
    end

    describe "with normal arguments and passing a block" do
      before(:all) do
        @signed_url = described_class.signed_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key') do |signer|
          signer.path                 = false
          signer.digest_key_encoding  = :base64
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

  describe ".signature" do
    it "returns the result of UrlSigner::Signer.signature" do
      described_class.signature(url, key) == UrlSigner::Signer.new(url, key).signature
    end

    describe "with normal arguments and passing a block" do
      before(:all) do
        @signature1 = described_class.signature(url, key, :path => false, :digest_key_encoding => :base64)
        @signature2 = described_class.signature(url, key) do |signer|
          signer.path                = false
          signer.digest_key_encoding = :base64
        end
        @signature3 = described_class.signature(url, key) do |signer|
          signer.url                 = url
          signer.digest_key          = key
          signer.path                = false
          signer.digest_key_encoding = :base64
        end
      end

      it "accepts the 3 syntax" do
        @signature1.should == @signature2
        @signature2.should == @signature3
      end
    end
  end

end
