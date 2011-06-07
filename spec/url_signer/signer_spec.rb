require 'spec_helper'

describe UrlSigner::Signer do
  let(:url) { "http://google.com/foo/bar?test=true&abc=def" }
  let(:key) { "123456abcdef" }

  describe ".sign_url" do
    it "returns an URL with the same original scheme" do
      URI.parse(described_class.new(url, key).sign_url).scheme.should == URI.parse(url).scheme
    end

    it "returns an URL with the same original host" do
      URI.parse(described_class.new(url, key).sign_url).host.should == URI.parse(url).host
    end

    it "returns an URL with the same query params ordered" do
      URI.parse(described_class.new(url, key).sign_url).query.should =~ /^abc=def&test=true.+/
    end

    it "returns an URL with a new signature param appended" do
      URI.parse(described_class.new(url, key).sign_url).query.should =~ /^abc=def&test=true&signature=.+/
    end
  end

end
