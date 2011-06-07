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

    it "returns an URL with the same query params" do
      URI.parse(described_class.new(url, key).sign_url).query.should =~ /^test=true&abc=def.+/
    end

    it "returns an URL with a new signature param appended" do
      URI.parse(described_class.new(url, key).sign_url).query.should =~ /^test=true&abc=def&signature=.+/
    end

    it "returns an URL that is stripped" do
      described_class.new(url, key).sign_url.should_not =~ /.+\s$/
    end

    it "always append '?' before generate signature" do
      described_class.new("http://google.com/foo/bar", key).sign_url.should == described_class.new("http://google.com/foo/bar?", key).sign_url
    end

    describe ":path option" do
      before(:all) do
        @signer = described_class.new(url, key, :path => false)
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.sign_url.should_not == described_class.new(url, key, :path => true).sign_url
      end
    end

    describe ":order_query option" do
      before(:all) do
        @signer = described_class.new(url, key, :order_query => false)
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.sign_url.should_not == described_class.new(url, key, :order_query => true).sign_url
      end
    end

    describe ":base64_private_key option" do
      before(:all) do
        @signer = described_class.new(url, key, :base64_private_key => true)
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.sign_url.should_not == described_class.new(url, key, :base64_private_key => false).sign_url
      end
    end

    describe ":signature_key option" do
      before(:all) do
        @signer = described_class.new(url, key, :signature_key => 'sign')
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.sign_url.should =~ /&sign=.+$/
      end
    end
  end

  describe ".initialize" do
    describe "without block" do
      before(:all) do
        @signer = described_class.new("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false, :order_query => false, :base64_private_key => true, :signature_key => 'sign')
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.url_to_sign.to_s.should == "http://google.com/foo/bar?toc=tic&tac=tuc"
      end

      it "sets private_key" do
        subject.private_key.should == 'your_secret_key'
      end

      it "sets options" do
        subject.options.should == { :path => false, :order_query => false, :base64_private_key => true, :signature_key => 'sign' }
      end
    end

    describe "passing a full block" do
      before(:all) do
        @signer = described_class.new do |signer|
          signer.url_to_sign        = "http://google.com/foo/bar?toc=tic&tac=tuc"
          signer.private_key        = 'your_secret_key'
          signer.path               = false
          signer.order_query        = false
          signer.base64_private_key = true
          signer.signature_key      = 'sign'
        end
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.url_to_sign.to_s.should == "http://google.com/foo/bar?toc=tic&tac=tuc"
      end

      it "sets private_key" do
        subject.private_key.should == 'your_secret_key'
      end

      it "sets options" do
        subject.options.should == { :path => false, :order_query => false, :base64_private_key => true, :signature_key => 'sign' }
      end
    end

    describe "with normal arguments and passing a block" do
      before(:all) do
        @signer = described_class.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false, :base64_private_key => true) do |signer|
          signer.private_key        = 'your_secret_key'
          signer.order_query        = false
          signer.signature_key      = 'sign'
        end
      end
      subject { @signer }

      it "sets url_to_sign" do
        subject.url_to_sign.to_s.should == "http://google.com/foo/bar?toc=tic&tac=tuc"
      end

      it "sets private_key" do
        subject.private_key.should == 'your_secret_key'
      end

      it "sets options" do
        subject.options.should == { :path => false, :order_query => false, :base64_private_key => true, :signature_key => 'sign' }
      end
    end

    describe "with no url" do
      subject { described_class.new }

      it "sets url_to_sign" do
        expect { subject }.to raise_error(ArgumentError, 'URL to sign needed (pass it as the first argument, or via the block-definition)!')
      end
    end

    describe "with no private key" do
      subject { described_class.new("http://google.com/foo/bar?toc=tic&tac=tuc") }

      it "sets url_to_sign" do
        expect { subject }.to raise_error(ArgumentError, 'Private key needed (pass it as the second argument, or via the block-definition)!')
      end
    end
  end

end
