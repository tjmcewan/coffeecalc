# Web fundamentals tutorial

## Intro

The goal of this tutorial is to create a coffee listing application without the magic of Rails.  You will hopefully gain a greater understanding of the underlying principles involved in programming web applications, and gain a greater appreciation for some of the things Rails does for you.

This tutorial uses [Sinatra](http://www.sinatrarb.com) as a tool to demonstrate some basic web principles.  Sinatra is a small framework for creating web applications in Ruby with minimal effort.

## Install Sinatra > "Hello World"

Let's start off by getting Sinatra running.

Install the gem:

``` shell
gem install sinatra
```

Create a file called "app.rb" and paste the following in:

``` ruby
require "sinatra"

get "/" do
  "Hello world!"
end
```

And run with:

``` shell
ruby app.rb
```

View at: [http://localhost:4567](http://localhost:4567)

Sinatra doesn't reload your code for you like Rails does, so let's add an extension to Sinatra to get this functionality:

``` shell
gem install sinatra-contrib
```

And in `app.rb`, after the `require "sinatra"` line, add:

``` ruby
require "sinatra/reloader"
```

Now start up your app again and change the "Hello world!" text and refresh your browser.

## Web Inspector > Request Headers

In your browser, open up your web console.  (For most browsers, this can be accessed by right clicking something on the page and choosing "Inspect Element".)  I recommend you use Chrome for this; if you are using Chrome, you're looking for the `Network` tab.

Refresh your browser, then click on the 'localhost' line in the web inspector, then in the Headers tab, click 'view source'.  You should see something similar to this:

``` shell
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

The important part to note is the first line `GET / HTTP/1.1` - this is what a "GET" request for a server's "root URL" looks like.  You can also see this in Sinatra's log output. (NB: If Sinatra says it has "backup from WEBrick", Ruby's built-in webserver, then you may see multiple GET requests each time you refresh.  Only one request is actually being issued, you can safely ignore the other.)

## HTML Form > GET parameters

To get our coffees into our app, we'll need an HTML form.  Replace your `get "/"` from above with this:

``` ruby
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

## Store coffees > global variable

So our form is sending the coffee info to our app, but we're not doing anything with it yet.  We should save the coffee information before we send the HTML form to the browser.  For simplicity, let's just store the coffee details in a variable.  So that they'll be available between requests, we'll need to use a global variable.  This is a drastically simplified version of what Rails calls the Model.

Add this to your `app.rb` somewhere (convention says it should be near the top, under the `require` lines):

``` ruby
$coffees = []
```

This creates an empty array when your app first starts up.

> Hint: this global variable won't be around for very long - it will be reset to the empty array each time the server restarts.  Because we're using Sinatra's reloader, this will be every time you save your `app.rb` file, but it will be plenty. ;)

Now you'll need to get the information into that `$coffees` array when the request is received.  When you fill in your form and click the submit button, Sinatra grabs the information out of the URL and makes it available as a Hash called `params`.

Have a go at adding the coffee params to the `$coffees` variable yourself, but first replace `<!-- coffees go here -->` in your form with:

#{ $coffees.inspect }

This will display the `$coffees` variable in the HTML in your browser so we can tell if the information is being stored.

> Hint: if you get stuck, try [Ruby's Array documentation](http://www.ruby-doc.org/core-2.1.0/Array.html#method-i-3C-3C)

> Mentor dicussion point: what is "#{}"?

## Display coffees in the browser

If you're storing your params correctly, you should be able to refresh the browser and see a new hash added to the `$coffees` variable each time.  It doesn't look very nice though, so let's build the HTML properly.  This is similar to Rails' Views.

Now replace our `#{ $coffees.inspect }` line with a call to a method:

#{ coffees_html }

We'll name the method "coffees_html", so that what it does is reasonably obvious.  Define it like so:

``` ruby
def coffees_html
  # build HTML here
end
```

You'll want to iterate over the `$coffees` array and turn each hash into an HTML string, surrounded by `<div>`s, which should then be all joined together with `<br>`s.

### moar to come ...
