BareSinatraApp
==============

You know what's frustrating? Repeating yourself. I do that a lot. I mean, all the time.

Specifically, when I'm starting a new project in my current DSL du jour, Sinatra, I seem to have a basic set of needs that repeats itself over and over again.

I like to write in the Modular style. I like to have some basic authentication. I don't want to remember to write my config.ru or init.rb files.

And thus, on a snowy Christmas morning in Indiana, this project was born.

Jewish people do funny things on Christmas. Don't worry - I will see a movie and eat Chinese, but for now, it's creating a Sinatra app.

What's new?
-----------

h3. Version 1.1

Well, it's becoming dangerously close to a whole toolkit, for one. But some recent changes. 

h4. app.yaml

Settings? I love 'em. This uses Sinatra's settings module, so it's available in the contexts of Sinatra. 

h4. Database Fixes

There were some loading issues. They're resolved. 

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

Decision Rationalization
------------------------

I have made several decisions here that I know will be unpopular simply beacuse they were made. But they were my decisions, and you don't have to agree with them. Here's why I did what I did.

+ **ERb**. I know ERb. I use it. I come from verbose languages like PHP (<?php echo $var;?>) and found ERb a natural extension of it. Likewise, I came from Rails, and it was the default when I learned it. I'm not afraid of writing some HTML, so it's the right language *for me*.
+ **Bootstrap**. I read [here](http://24ways.org/2012/how-to-make-your-site-look-half-decent/) that Bootstrap democratizes design. I couldn't agree more. I am not a designer, so having a default project that isn't ugly is great. Note in that article, Bootstrap is easy to make non-ugly *and* not look like Bootstrap, and I encourage walking through her steps. It is worthwhile.
+ **Vanilla CSS and JS**. I'm not using SCSS, CoffeeScript, LESS or any of those fancy processing languages. To the best of my knowledge, the downside is potential performance. But, I don't know them, and I don't know how to optimize them. Likewise, I wanted the barrier to entry for this project low, so adding more languages to learn is the opposite of that. CSS and Javascript aren't scary. Learn them, then convert to whatever engine you like.
+ **Authentication**. All of it lives in the Authentication app. Better or worse. I prefer it all be in one place. This also means all auth activities are prefixed "/auth", as compared to the more RESTful "/session". It still uses REST, of course.
+ **Registration**. The entire registration flow was built with one very specific use-case in mind. I am building it with private sites in mind, and as such it will require an approval. This behavior can easily be changed to your liking, either by setting approved default to true, or modifying the query in User#authenticate.


Credits, Inspiration and Further Reading
----------------------------------------

For the most part, things are attributed in the source. But for more overreaching things, it's hard to find one place. So, they go here.

+ **The Sinatra Book** - [http://sinatra-book.gittr.com/](http://sinatra-book.gittr.com/)
+ *DataMapper ** - [http://datamapper.org/](http://datamapper.org/)
+ **CSRF Protection ** - [http://stackoverflow.com/questions/11451161/sinatra-csrf-authenticity-tokens](http://stackoverflow.com/questions/11451161/sinatra-csrf-authenticity-tokens)