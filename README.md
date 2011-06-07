## UrlSigner [![Build Status](http://travis-ci.org/rymai/url_signer.png)](http://travis-ci.org/rymai/url_signer)

UrlSigner is an easy way to get signed URLs using HMAC functionality.

### Features

* Sign URLs using [HMAC](http://www.ietf.org/rfc/rfc2104.txt)
* Tested on Ruby 1.8.7, 1.9.2, REE, Rubinius & JRuby.

### Usage & options

Using `UrlSigner.sign_url`:

```ruby
UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key')
# => The signature will be generated from 'foo/bar?tac=tuc&toc=tic'
# => The signed URL will look like 'http://google.com/foo/bar?tac=tuc&toc=tic&signature=<generated_signature>'

UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false)
# => The signature will be generated from 'tac=tuc&toc=tic' (without the path)
# => The signed URL will look like 'http://google.com/foo/bar?tac=tuc&toc=tic&signature=<generated_signature>'

UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :order_query => false)
# => The signature will be generated from 'foo/bar?toc=tic&tac=tuc' (without reordering the query parameters by key)
# => The signed URL will look like 'http://google.com/foo/bar?tac=tuc&toc=tic&signature=<generated_signature>'

UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :base64_private_key => true)
# => The given private key will be decoded from modified Base64 for URLs before being used for digestion

UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :signature_key => 'sign')
# => The signed URL will look like 'http://google.com/foo/bar?tac=tuc&toc=tic&sign=<generated_signature>'
```

Actually, `UrlSigner.sign_url` creates a new `UrlSigner::Signer`, passes the arguments through and calling `UrlSigner::Signer#sign_url` on it.
That means that you can also create an instance of `UrlSigner::Signer` and call `UrlSigner::Signer#sign_url` when you need it.

Instance of `UrlSigner::Signer` can be created with the no-block, full-block, or mixed syntax:

```ruby
@signer = UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false, :signature_key => 'sign')

@signer = UrlSigner::Signer.new do |signer|
  signer.url_to_sign        = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.private_key        = 'your_secret_key'
  signer.path               = false
  signer.signature_key      = 'sign'
end

UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.private_key        = 'your_secret_key'
  signer.signature_key      = 'sign'
end

# And when you're ready, just call #sign_url on your fresh instance:
@signer.sign_url # => "http://google.com/foo/bar?toc=tic&tac=tuc&sign=<generated_signature>"
```

### Inspiration

- http://code.google.com/apis/maps/documentation/webservices/#URLSigning
- http://gmaps-samples.googlecode.com/svn/trunk/urlsigning/urlsigner.rb


### Development

* Source hosted at [GitHub](https://github.com/rymai/url_signer).
* Report Issues/Feature requests on [GitHub Issues](https://github.com/rymai/url_signer/issues).

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make. Please do not change the version in your pull-request.

### Author

[Rémy Coutable](https://github.com/rymai)

### Contributors

https://github.com/rymai/url_signer/contributors
