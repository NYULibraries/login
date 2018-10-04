# Aleph

The Libraries' users are not only NYU users. Nor are they only New School or other Consortium users (i.e. Cooper Union, NYSID, etc.). In addition to these users, we have alumni, family members, and the general public. And so because Aleph is where we handle circulation, Aleph is also where we have our complete patron database. Hence the importance of creating an Aleph identity if we can.

## X-Services

The Aleph X-Services are APIs that allow us to query the Aleph database for various information, ranging from patron information to more complex information about the status of individual catalog items. [Read more](x_service/README.md)

## Patron Loader

Using various strategies [described here](patron_loader/README.md) the `PatronLoader` creates an `Aleph::Patron` object that a user's Aleph identity.

When we get a user's identity from the provider we try our best to create an Aleph identity for that user. Obviously if the provider is Aleph this is trivial. However, if the provider is NYU Shibboleth or New School LDAP we need to do lookup using APIs to create that identity. When the provider is Twitter we cannot create an Aleph identity because there is no way to link these accounts together.
