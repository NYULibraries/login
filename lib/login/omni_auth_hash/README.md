# OmniAuthHash

This Login application acts as an OAuth2 client (for Shibboleth, Facebook, etc.) and as an OAuth2 provider (for the NYU Libraries applications). When Login is in the callback phase for one of the identity providers we require a way to translate the various identity responses (standardized as OmniAuthHashes) into an object that we can use locally for actions such as creating local identities for the protected API.

## Validator

The validator, quite simply, let's us validate that an identity provider gave us a valid OmniAuthHash.

It permits us to ask the question:

```ruby
@validator = Login::OmniAuthHash::Validator.new(@nyu_shibboleth_authhash, 'nyu_shibboleth')
@validator.valid? # => TRUE
```

## Mapper

This is a delegator class that identifies the provider (from a whitelist!) and passes it to its relevant ProviderMapper, which handles mapping the attributes because the individual mappers know the provider's structure better, that's their sole purpose.

### Provider Mappers

For each identity provider there is a corresponding ProviderMapper that will return a mapped Mapper object from a given OmniAuthHash.
