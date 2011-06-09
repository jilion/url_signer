require 'spec_helper'

describe UrlSigner::Signer do
  let(:url) { "http://google.com/foo/bar?test=true&abc=def" }
  let(:key) { "123456abcdef" }

  describe ".initialize" do
    describe "only-arguments syntax" do
      before(:all) do
        @signer = described_class.new("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false, :digest_key_encoding => :base64, :signature_param_name => 'sign')
      end
      subject { @signer }

      it "sets url" do
        subject.url.to_s.should == "http://google.com/foo/bar?toc=tic&tac=tuc"
      end

      it "sets digest_key" do
        subject.digest_key.should == 'your_secret_key'
      end

      it "sets options" do
        subject.options.should == { :path => false, :digest_key_encoding => :base64, :signature_param_name => 'sign' }
      end
    end

    describe "only-block syntax" do
      before(:all) do
        @signer = described_class.new do |signer|
          signer.url                  = "http://google.com/foo/bar?toc=tic&tac=tuc"
          signer.digest_key           = 'your_secret_key'
          signer.path                 = false
          signer.digest_key_encoding  = :base64
          signer.signature_param_name = 'sign'
        end
      end
      subject { @signer }

      it "sets url" do
        subject.url.to_s.should == "http://google.com/foo/bar?toc=tic&tac=tuc"
      end

      it "sets digest_key" do
        subject.digest_key.should == 'your_secret_key'
      end

      it "sets options" do
        subject.options.should == { :path => false, :digest_key_encoding => :base64, :signature_param_name => 'sign' }
      end
    end

    describe "mixed (arguments + block) syntax" do
      before(:all) do
        @signer = described_class.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false, :digest_key_encoding => :base64) do |signer|
          signer.digest_key           = 'your_secret_key'
          signer.signature_param_name = 'sign'
        end
      end
      subject { @signer }

      it "sets url" do
        subject.url.to_s.should == "http://google.com/foo/bar?toc=tic&tac=tuc"
      end

      it "sets digest_key" do
        subject.digest_key.should == 'your_secret_key'
      end

      it "sets options" do
        subject.options.should == { :path => false, :digest_key_encoding => :base64, :signature_param_name => 'sign' }
      end
    end

    describe "with no url" do
      subject { described_class.new }

      it "sets url" do
        expect { subject }.to raise_error(ArgumentError, 'URL to sign needed (pass it as the first argument, or via the block-definition)!')
      end
    end

    describe "with no private key" do
      subject { described_class.new("http://google.com/foo/bar?toc=tic&tac=tuc") }

      it "sets url" do
        expect { subject }.to raise_error(ArgumentError, 'Private key needed (pass it as the second argument, or via the block-definition)!')
      end
    end
  end

  describe "#signed_url" do
    it "returns an URL with the same original scheme" do
      URI.parse(described_class.new(url, key).signed_url).scheme.should == URI.parse(url).scheme
    end

    it "returns an URL with the same original host" do
      URI.parse(described_class.new(url, key).signed_url).host.should == URI.parse(url).host
    end

    it "returns an URL with the same original port" do
      URI.parse(described_class.new("http://localhost:3000", key).signed_url).port.should == 3000
    end

    it "returns an URL with the same query params ordered" do
      URI.parse(described_class.new(url, key).signed_url).query.should =~ /^abc=def&test=true.+/
    end

    it "returns an URL with a new signature param appended" do
      URI.parse(described_class.new(url, key).signed_url).query.should =~ /^abc=def&test=true&signature=.+/
    end

    it "returns an URL that is stripped" do
      described_class.new(url, key).signed_url.should_not =~ /.+\s$/
    end

    it "always append '?' before generate signature" do
      described_class.new("http://google.com/foo/bar", key).signed_url.should == described_class.new("http://google.com/foo/bar?", key).signed_url
    end

    describe ":path option" do
      before(:all) do
        @signer = described_class.new(url, key, :path => false)
      end
      subject { @signer }

      it "sets url" do
        subject.signed_url.should_not == described_class.new(url, key, :path => true).signed_url
      end
    end

    describe ":digest_key_encoding option" do
      before(:all) do
        @signer = described_class.new(url, key, :digest_key_encoding => :base64)
      end
      subject { @signer }

      it "sets url" do
        subject.signed_url.should_not == described_class.new(url, key, :digest_key_encoding => :plain).signed_url
      end
    end

    describe ":signature_param_name option" do
      before(:all) do
        @signer = described_class.new(url, key, :signature_param_name => 'sign')
      end
      subject { @signer }

      it "sets url" do
        subject.signed_url.should =~ /&sign=.+$/
      end
    end
  end

  describe "#signature" do
    it "returns the signature appended at the end of the URL" do
      signer = described_class.new(url, key)
      matches = signer.signed_url.match(/&signature=(.+)/)

      signer.signature.should == matches[1]
    end
  end

end
