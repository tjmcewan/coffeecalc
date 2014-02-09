# Web fundamentals tutorial

The goal of this tutorial is to create a coffee listing application without the magic of Rails.  You should gain a greater understanding of the underlying principles involved in programming web applications, and gain a greater appreciation for some of the things Rails does for you.

This tutorial uses [Sinatra](http://www.sinatrarb.com) as a tool to demonstrate some basic web principles.  Sinatra is a minimalistic framework for creating web applications in Ruby with minimal effort.

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

We want to keep a list of coffees and how much each will cost.  To get this information into our app, we'll need an HTML form.

Replace your `get "/"` from above with this:

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

For simplicty, this form sends the information to the same route ("/").

Let's stop developing for a second and see what gets sent to the server.  Stop your app (ctrl-c), then run this:

``` shell
nc -l 4567
```

Now go back to the browser, put some text into the form and click submit.  You should see something similar to this:

``` shell
GET /?what=flat+white&cost=3.50 HTTP/1.1
Host: localhost:4567
Connection: keep-alive
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.70 Safari/537.36
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8
```

> Mentor dicussion point: what are these and what do they mean?


So before we send the HTML back to the browser, we'll want to store our coffee details somewhere, then grab all the coffees and add them to the HTML we send back.

First off, we need a way to store coffees.  At this stage, we don't need to be concerned with how to store them, so we're going to use a global variable.

Add this to your `app.rb` somewhere:

``` ruby
$coffees = []
```

When you fill in your form and click the submit button, Sinatra grabs the information out
