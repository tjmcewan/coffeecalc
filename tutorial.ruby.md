# Web fundamentals tutorial

## Goal

The goal of this tutorial is to create a coffee listing application without the magic of Rails.  You will hopefully gain a greater understanding of the underlying principles involved in programming web applications, and gain a greater appreciation for some of the things Rails does for you.

This tutorial uses [Sinatra](http://www.sinatrarb.com) as a tool to demonstrate some basic web principles.  Sinatra is a small framework for creating web applications in Ruby with minimal effort.

## Install Sinatra » "Hello World"

Let's start off by getting Sinatra running.

Install the gem:

```
gem install sinatra
```

Create a file called "app.rb" and paste the following in:

```ruby
require "sinatra"

get "/" do
  "Hello world!"
end
```

And run with:

```
ruby app.rb
```

View at: [http://localhost:4567](http://localhost:4567)

Hit `ctrl-c` at your command prompt to stop your app.

Sinatra doesn't reload your code changes for you like Rails does, so let's add an extension to Sinatra to get this functionality:

```
gem install sinatra-contrib
```

And in `app.rb`, after the `require "sinatra"` line, add:

```ruby
require "sinatra/reloader"
```

Now start up your app again and change the "Hello world!" text and refresh your browser.

If you get stuck, make sure your `app.rb` looks like [this one](../snippets/install_sinatra.rb).

## Web Inspector » Request Headers

In your browser, open up your web console.  (For most browsers, this can be accessed by right clicking something on the page and choosing "Inspect Element".)  I recommend you use Chrome for this; if you are using Chrome, you're looking for the `Network` tab.

Refresh your browser, then click on the 'localhost' line in the web inspector, then in the Headers tab, click 'view source'.  You should see something similar to this:

```
GET / HTTP/1.1
Host: localhost:4567
Connection: keep-alive
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.70 Safari/537.36
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8
```

> Mentor dicussion point: what are these and what do they mean?

The important part to note is the first line `GET / HTTP/1.1` - this is what a "GET" request for a server's "root URL" looks like.  You can also see this in Sinatra's log output.

> If Sinatra says it has "backup from WEBrick", Ruby's built-in webserver, then you may see multiple GET requests each time you refresh.  Only one request is actually being issued, you can safely ignore the other.

## HTML Form » GET parameters

To get our coffees into our app, we'll need an HTML form to send through which coffee we want and how much it costs.  Replace your `get "/"` from above with this:

```ruby
get "/" do
  """
  <html>
  <body>
    <form action='/' method='get'>
      What: <input name='what'>
      Cost: <input name='cost'>
      <button type='submit'>add coffee</button>
    </form>
    <!-- coffees go here -->
  </body>
  </html>
  """
end
```

For simplicty, this form sends the information to the same URL ("/").  Refresh your browser and you should see the form you just created.

Now let's see what the browser sends to the server when you submit the form.  Put some text into the form and click the 'add coffee' button.  Check out the request headers in the Network tab and you should see something like this:

    GET /?what=flat+white&cost=3.50 HTTP/1.1

> Mentor dicussion point: where do the parameter names come from?  what is the question mark doing?

If it's not quite working, check out [this](../snippets/html_form.rb).

## Store coffees » global variable

So our form is sending the coffee info to our app, but we're not doing anything with it yet.  We should save the coffee information before we send the HTML form to the browser.  For simplicity, let's just store the coffee details in a variable.  So that they'll be available between requests, we'll need to use a _global_ variable.  This is a drastically simplified version of what Rails calls the Model layer.

Add this to your `app.rb` somewhere (convention says it should be near the top, under the `require` lines):

```ruby
$coffees = []
```

This creates an empty array when your app first starts up.

> Hint: this global variable won't be around for very long - it will be reset to the empty array each time the server restarts.  Because we're using Sinatra's reloader, this will be every time you save your `app.rb` file.  Don't worry though, it will suit our purposes nicely. ;)

Now you'll need to get the information into that `$coffees` array when the request is received.  When you fill in your form and click the submit button, Sinatra grabs the information out of the URL and makes it available as a Hash called `params`.

Have a go at adding the coffee params to the `$coffees` variable yourself, but first replace `<!-- coffees go here -->` in your form with:

#{ $coffees.inspect }

This will display the `$coffees` variable in the HTML in your browser so we can tell if the information is being stored.

> Hint: if you get stuck, try [Ruby's Array documentation](http://www.ruby-doc.org/core-2.1.0/Array.html#method-i-3C-3C) first.  If you're still stuck, [check here](../snippets/store_coffees.rb).

If you're storing your params correctly, you should be able to refresh the browser and see that a new hash gets added to the `$coffees` array each time.

## Template method

That big string in our `get` route is making it a bit hard to see what our app does, so let's move it to its own method.  Copy the HTML form out of your `get` route and paste it into a method called `template`.

> The part you copy should _include_ the triple quotes.

Then replace the form from your `get` route with a simple call to the `template` method, like so:

```ruby
get "/" do
  $coffees << params
  template
end
```

This will also make it easier to re-use the form, should we ever need to.

> Hint: see [here](../snippets/template_method.rb) if something went awry.

## Get VS Post

As you saw in the [store coffees section](#store-coffees-global-variable), if you refresh your browser, your app adds the information into the `$coffees` global repeatedly.  This is because we're storing the params from the URL each time our `get` route is requested.

This is a good point to mention that `GET` requests should not do things that change the state of the system - it's too easy for unintended side-effects to occur.  Things that are meant to be stored in the system or manipulate something should be sent via a `POST` request.

So armed with that knowledge, let's change our form's method to `post`.  Locate the section in the form that specifies the method as `get` and change it to `post`.  Now refresh your browser and submit a new coffee.

**Uh oh!** Welcome to Sinatra's lovely error page, if you haven't encountered it yet today.  The message at the bottom should say this:

>    Try this:
>
>    post '/' do
>      "Hello World"
>    end

This is Sinatra's way of telling you that the route you requested doesn't exist.  You may also know this as HTTP error number 404: _page not found_. ;)

Let's add our `post` route into Sinatra:

- Grab the "Hello world" `post` route from Sinatra's 404 page, or from above and put it under our `get` route.
- Replace the "Hello world" with a call to our `template` method.
- Now **move** the line that stores the coffee params over from the `get` route (ensure this goes _above_ the call to `template`).

As usual, you can check your progress [over here](../snippets/get_vs_post.rb).

Now if you refresh the page after submitting a coffee, you should see a warning from your browser that it needs to resubmit the form in order to load the page:

> ![Chrome's confirm resubmission dialog](../images/confirm_resubmission.png)

This is a much better situation than before - this will prompt us to think about the consequences and we will probably avoid inadvertantly adding the same coffee multiple times.

Do you think it would stop non-technical users from refreshing the page?  Instead of worrying about the answer to that, let's just make it so we don't have to.  We can do better!

## Post/Redirect/Get

The fundamental issue is that our application sends back a proper HTML response when a `POST` request is issued and this represents the page's location.  When you refresh the page, you're asking the browser to re-request this location and the only way it knows how to get to that location is to send that `POST` request (which often changes the system, so isn't what we want).

The way to fix this is to not send a proper HTML response back.  Instead of the call to our `template` method, we redirect the browser to another location.

In Sinatra, it looks like this:

```ruby
redirect "/"
```

Try first, then [check it here](../snippets/post_redirect.rb).

This sends back a special redirect response (HTTP 303) with a `Location` header that specifies where the browser should go:

> HTTP/1.1 303 See Other
> <...>
> Location: http://localhost:4567/

To see this in action, have a look in Chrome's Web Inspector (Network tab) and send your app a coffee:

> ![Chrome's network tab showing a post/redirect/get](../images/post_redirect.png)

The first line shows the browser submitting the form via the `POST` request method.  The response it receives is an HTTP 303, containing the `Location` header.  It then issues a `GET` request for that location (which corresponds to our root URL, "/") and renders the response it gets from there - which is our HTML template.

Now you can refresh all you want and all you're doing is requesting using `GET`, not `POST`.  Your browser doesn't have to submit the form any more to display that page.

This is the end of the tutorial - you've done an excellent job!

Thanks for playing!
