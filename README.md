BareSinatraApp
==============

You know what's frustrating? Repeating yourself. I do that a lot. I mean, all the time.

Specifically, when I'm starting a new project in my current DSL du jour, Sinatra, I seem to have a basic set of needs that repeats itself over and over again.

I like to write in the Modular style. I like to have some basic authentication. I don't want to remember to write my config.ru or init.rb files.

And thus, on a snowy Christmas morning in Indiana, this project was born.

Jewish people do funny things on Christmas. Don't worry - I will see a movie and eat Chinese, but for now, it's creating a Sinatra app.

Why?
----

A good question. The world doesn't need another barebones starter app. But, find any developer out there and ask them if they've ever inherited code that they didn't want to refactor.

They will all say "Of course - the last guy sucked."

That's how I feel. But mostly because I only know my coding style. I know what I need and want out of a development experience, not what others tell me I want. Sure, I can learn from them, and have, but it's time for me to contribute what I think is a good basic app to the world.

Plus, it pads the resume. Hello, public repo.

A better answer would have just been, "why not?"

Truthfully, I also feel there is a lack of information about spinning up modular Sinatra apps. Every tutorial I've come across goes from "Hello, Sinatra!" to "Largest Web App Ever" without explaining the middle. I hope this will new developers get over that, because it's a fantastic framework, and it's rare to come across something that is good for both really rapid prototyping **and** production.

Lastly, the best way to demonstrate knowledge of something is to teach someone else. That's my goal here.

Things to do
------------

+ Change the cookie secret in config.ru. This should be random and unique.
+ Consider refactoring the master module (BareApp). That would be a lot of little changes, or one big one in something like RubyMine.
+ Scan through app/_base.rb and make sure things are to your liking. I chose to have all apps inherit this one, so I don't have to repeat myself on things like 404 and 500, and so Warden is globally available
+ I am using DataMapper for a lightweight ORM. You need to pick the right adapter and configure it. I am using PostGRES because Heroku uses it, and they make an app available for Mac that basically emulates their production environment. Plus, I've had issues with SQLite on Heroku. Of course, you don't need any of it if you don't want.


