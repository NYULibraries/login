# Aleph X-Service APIs

The Aleph X-Services are APIs that allow us to query the Aleph database for various information, ranging from patron information to more complex information about the status of individual catalog items.

[For documentation on the full suite of X-Services visit the Exlibris Developer site.](https://developers.exlibrisgroup.com/aleph/apis/Aleph-X-Services)

## Bor Info

For the purposes of the Login application we are mainly interested in getting user properties for an Aleph patron. This includes patron status, patron type, ill permission, etc.

If you find yourself needing to further query Aleph within a Ruby context you can use the gem that wraps all the Aleph X-Services: [https://github.com/scotdalton/exlibris-aleph](https://github.com/scotdalton/exlibris-aleph).
