# README


Just a couple quick notes...

* first, i slapped it up here -- while it'll run just fine locally, if you
  don't want to deal with that but do want to test it, well, here's the url:
  https://appl-weather-station.herokuapp.com/

* I didn't write any tests. I would normally, I do often. But I did sorta run
  out of time (I tried to timebox this as much as possible). I hope I don't
  lose too many points for this. :)

* Most of the work happens in `app/services`, where i was holding back the
  temptation to create a ruby gem for the weatherkit api... ui is standard erb
  and a couple rails/rails-style helpers... normally I'd use slim or haml, etc
  etc, but i really was trying to keep it vanilla rails as much as possible.

* speaking of those text helper methods... this might be the biggest
  case/switch statement i've ever built -- and honestly, that's a smell in
  itself -- i'm sure i could do it quite differently, or even enlarged the
  angles so that there were fewer cardinal options. But in the end, it works,
  and is simple to understand. something algorithmic might have to determine
  the primary cardinal (N/S/E/W) and then figure out the secondary -- to
  compile into a composite string... yeah, it'd work but it'd be hard to
  reason about for something that's just a display string. :shrug:

* I included the p8 key as for some reason it wasn't reading OK when i pulled
  the content from an ENV var... I've done this before, but I didn't want to
  get too distracted with it, and given the key exists solely for this
  experiment and will be invalidated once we're done, it didn't seem a great
  spend of time to focus on.

* I wanted to do something cool with turning weather condition strings into
  UI driven with an icon, however I could not find a definitive list of
  conditions.... so therefore it wasn't really viable to turn an unpredictable
  string into an icon and always look good.

* On the API -- the WeatherKit api is pretty amazing, however there are still
  a good number of 502 gateway errors, as well as vague auth errors -- so
  because of that, i added some naive error management via an ArgumentError.
  Yeah, it's a hack but it'll do to ensure that API errors don't end up as
  object navigation errors.

* Also, the API - I ended up pulling in MapKit to geocode the address into
  lat/lng. I didn't go further to normalize the address, and so the cache
  leverages whatever address string is presented.... however, if i was making
  this into an actual go-to-market prod app, i'd build up an algo heuristic to
  turn a lat/lng into a radius to get a reasonable zone...

* On the UI front, I grabbed a bootstrap-esque framer via cdnjs... just for
  simplicity really. With Rails 7 the shifts into importmap and novel ways to
  build up a js pack are myriad now.... but way too complex for this proto, so
  i abandoned trying to do it 'right' and instead focused on functionality.

* In a production future, i'd like to explore using WebComponents and
  stimulus/turbo to push to the UI ... with the 'passing' of DarkSky, I think
  there's still room in the ios market for a weather ui that resonates, and
  it's clear that the data for it is readily available this way.....

* oh, and, the reason the faraday connection handler is being passed a proc -
  i got focused on the likely repetitivity of the faraday build up. I
  originally thought that it might be different enough per api, but as it was
  clear that they were fairly simple jwt contracts, it was obvious that a
  mixin was in order. However, I didn't want to just re-define some kind of
  auth method and expect it there; instead, I thought it was best to push the
  relevant auth via the method args. It's like i've been deep in a functional
  programming language lately (i have not!)

  thanks for taking a look.
