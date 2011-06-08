## UrlSigner [![Build Status](http://travis-ci.org/rymai/url_signer.png)](http://travis-ci.org/rymai/url_signer)

UrlSigner is an easy way to get signed URLs using HMAC functionality.

### Features

* Sign URLs using [HMAC](http://www.ietf.org/rfc/rfc2104.txt)
* Tested on Ruby 1.8.7, 1.9.2, REE, Rubinius & JRuby.

### Usage

Using `UrlSigner.sign_url` with the no-block, full-block, or mixed (arguments + block) syntax:

```ruby
# No block: arguments
UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', {})
# => "http://google.com/foo/bar?tac=tuc&toc=tic&signature=<generated_signature>"

# Block only
UrlSigner.sign_url do |signer|
  signer.url                  = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.digest_key           = 'your_secret_key'
  signer.path                 = false
  signer.signature_param_name = 'sign'
end

# Mixed: arguments + block
UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.digest_key           = 'your_secret_key'
  signer.signature_param_name = 'sign'
end
```

Actually, `UrlSigner.sign_url` creates a new instance of `UrlSigner::Signer`, passes the arguments through and calls `#signed_url` on it.
That means that you can also create an instance of `UrlSigner::Signer` and call `#signature` or `#signed_url` when you need it.

Instance of `UrlSigner::Signer` can be created with the no-block (arguments only), full-block, or mixed (arguments + block) syntax as well:

```ruby
# No block: arguments
@signer = UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false, :signature_param_name => 'sign')

# Block only
@signer = UrlSigner::Signer.new do |signer|
  signer.url                  = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.digest_key           = 'your_secret_key'
  signer.path                 = false
  signer.signature_param_name = 'sign'
end

# Mixed: arguments + block
UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.digest_key           = 'your_secret_key'
  signer.signature_param_name = 'sign'
end

# And when you're ready, get the signature:
@signer.signature  # => "<generated_signature>"

# Or the signed url:
@signer.signed_url # => "http://google.com/foo/bar?toc=tic&tac=tuc&sign=<generated_signature>"
```

### Options

List of available options:

- `:path => false`             # Include the path in the string used for the signature (default: true).
- `:base64_digest_key => true` # Whether the given `digest_key` is encoded in "modified Base64 for URLs" (default: false).
                               # If true, the digest_key will be decoded before being used for digest.
- `:signature_param_name => 'sign'`   # Change the name of the appended "signature" query parameter (default: "signature").

Options can be given to `UrlSigner.sign_url` and `UrlSigner::Signer.new`, through parameters, with the block syntax, or both:

```ruby
UrlSigner.sign_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false)

UrlSigner::Signer.new do |signer|
  signer.url        = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.digest_key = 'your_secret_key'
  signer.path       = false
end

UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.digest_key        = 'your_secret_key'
  signer.base64_digest_key = true
end
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
