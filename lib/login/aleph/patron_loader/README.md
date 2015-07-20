# Patron Loader Strategies

Strategies for creating an Aleph patron from an identifier. Creating an Aleph patron has various applications within Login.

We want to first check if the user is in the Aleph flat file, and if so use that version of the user. If they are not we want to use the APIs to get the user from the Aleph database. So the logic that drives an Aleph patron always favors the flat file, as such:

```ruby
@patron = flat_file_strategy.patron || bor_info_strategy.patron
```

## Flat File Strategy

Load a patron based on an entry in a flat file containing information about all Aleph patrons. This flat file is loaded nightly onto the relevant servers and is the quickest method for getting this information out of Aleph. It also allows us to add more information not available via the Aleph APIs, such as library barcode.

An entry from the tab-delimited flat file might look as follows:

```
N12345678	12345678910112	encrypted_value	20140101	65	0	ELOPER,DÉV	developer@nyu.edu	Y	PLIF LOADED	LI	NYU Division of Libraries	01	DIVISION OF LIBRARIES	31300	INFO TECH SVCS/DIRCTR-DIG PROJ
```

## Bor Info Strategy

In the case where the user is not in the flat file (i.e. they were added to Aleph during the day before the flat file cron job got to run overnight) we need to use the Aleph X-Service APIs to look up the patron. Since this is an http call out it is more expensive and so we only want to use as a failsafe. Using this lookup also won't give us the barcode and hence the user won't be able to use some services that require it (i.e. EZBorrow).

The specific API function is called `bor-info`, hence the name of this strategy.
