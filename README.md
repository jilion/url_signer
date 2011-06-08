UrlSigner [![Build Status](http://travis-ci.org/jilion/url_signer.png)](http://travis-ci.org/jilion/url_signer)
=========

UrlSigner is an easy way to get signed URLs using HMAC functionality.

Features
--------

* Sign URLs using [HMAC](http://www.ietf.org/rfc/rfc2104.txt).
* Tested on Ruby 1.8.7, 1.9.2, REE, Rubinius & JRuby.

Usage
-----

There is 2 ways to use this gem:

- Using `UrlSigner`, a module with 2 methods:
  - `.signed_url(url, digest_key, options, &block)`
  - `.signature(url, digest_key, options, &block)`
  
- Using `UrlSigner::Signer`, a class with the 3 methods:
  - `#new(url, digest_key, options, &block)`
  - `#signed_url`
  - `#signature`

`UrlSigner.signed_url`, `UrlSigner.signature` and `UrlSigner::Signer#new` can be called in the exact same ways, with the 
only-arguments, only-block, or mixed (arguments + block):

  - The 2 first optional arguments, if present are the URL to sign and the digest key.
  - The last optional argument is a Hash of options.
  - All these arguments can be set with the block syntax instead.

Options
-------

List of available options:

- `:path => false`                  # Include the path in the string used for the signature (default: true)
- `:digest_key_encoding` => :base64 # Whether the given `digest_key` is encoded in "modified Base64 for URLs" (default: 
:plain)
                                    # If true, the digest_key will be decoded before being used for digest.
- `:signature_param_name => 'sign'` # Change the name of the appended "signature" query parameter (default: 
"signature")

Note: The `:signature_param_name` option is useless when you call `UrlSigner.signature`.

Options can be given to `UrlSigner.signed_url` and `UrlSigner::Signer.new`, through parameters, with the block syntax, or 
both:

```ruby
UrlSigner.signed_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', :path => false)

UrlSigner::Signer.new do |signer|
  signer.url        = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.digest_key = 'your_secret_key'
  signer.path       = false
end

UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.digest_key          = 'your_secret_key'
  signer.digest_key_encoding = :base64
end
```

Using `UrlSigner`
-----------------

`UrlSigner.signed_url` and `UrlSigner.signature` can be called on this module.

```ruby
# No block: arguments
UrlSigner.signed_url("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', {})
# => "http://google.com/foo/bar?tac=tuc&toc=tic&signature=<generated_signature>"
# Signature is digested from "/foo/bar?tac=tuc&toc=tic"

# Block only
UrlSigner.signed_url do |signer|
  signer.url                  = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.digest_key           = 'your_secret_key'
  signer.signature_param_name = 'sign'
end
# => "http://google.com/foo/bar?tac=tuc&toc=tic&sign=<generated_signature>"
# Signature is digested from "/foo/bar?tac=tuc&toc=tic"

# Mixed: arguments + block
UrlSigner.signature("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.digest_key           = 'your_secret_key'
  signer.signature_param_name = 'sign'
end
# => "<generated_signature>"
# Signature is digested from "tac=tuc&toc=tic"
```

Using `UrlSigner::Signer`
-----------------

`UrlSigner.signed_url` can be called with the no-block, full-block, or mixed (arguments + block) syntax.

The 2 first optional arguments, if present are the URL to sign and the digest key.
The last optional argument is a Hash of options (see below for the list of available options).
These arguments can also be set with the block syntax instead.

Actually, `UrlSigner.signed_url` creates a new instance of `UrlSigner::Signer`, passes the arguments through its 
`#initialize` method and calls `#signed_url` on it. Same process for `UrlSigner.signature`.
That means that you can also create an instance of `UrlSigner::Signer` and call `#signature` or `#signed_url` when you 
need it.

Instance of `UrlSigner::Signer` can be created with the no-block (arguments only), full-block, or mixed (arguments + 
block) syntax as well:

```ruby
# No block: arguments
@signer1 = UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", 'your_secret_key', {})

# Block only
@signer2 = UrlSigner::Signer.new do |signer|
  signer.url        = "http://google.com/foo/bar?toc=tic&tac=tuc"
  signer.digest_key = 'your_secret_key'
  signer.signature_param_name = 'sign'
end

# Mixed: arguments + block
@signer3 = UrlSigner::Signer.new("http://google.com/foo/bar?toc=tic&tac=tuc", :path => false) do |signer|
  signer.digest_key           = 'your_secret_key'
  signer.signature_param_name = 'sign'
end

# And when you're ready, get the signed URL:
@signer1.signed_url # => "http://google.com/foo/bar?toc=tic&tac=tuc&signature=<generated_signature>"

@signer2.signed_url # => "http://google.com/foo/bar?toc=tic&tac=tuc&sign=<generated_signature>"

# Or only the signature:
@signer1.signature  # => "<generated_signature>"
# Signature is digested from "/foo/bar?tac=tuc&toc=tic"

@signer3.signature  # => "<generated_signature>"
# Signature is digested from "tac=tuc&toc=tic" because of the ':path => false' option
```

Note: `UrlSigner.signed_url` and `UrlSigner::Signer#signed_url` sort the query parameters alphabetically.

Inspiration
-----------

- http://code.google.com/apis/maps/documentation/webservices/#URLSigning
- http://gmaps-samples.googlecode.com/svn/trunk/urlsigning/urlsigner.rb

Development
-----------

* Source hosted at [GitHub](https://github.com/jilion/url_signer).
* Report Issues/Feature requests on [GitHub Issues](https://github.com/jilion/url_signer/issues).

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate 
change
you make. Please do not change the version in your pull-request.

Author
------

[Rémy Coutable](https://github.com/rymai)

Contributors
------------

https://github.com/jilion/url_signer/contributors
