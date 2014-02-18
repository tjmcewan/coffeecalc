# Coffee List Display

`Inspect` works for debugging, but we don't want to use it in production.  For one thing, it's really hard to style the output.  Let's wrap our coffee list in proper HTML.

### Setup

First let's make a method that will return our coffees wrapped in HTML tags.  We'll name the method "coffees_html", so that what it does is reasonably obvious.  Define it like so:

```ruby
def coffees_html
  # build HTML here
end
```

And in your `template` method change your `#{ $coffees.inspect }` line to call our new method:

#{ coffees_html }

### Now for the fun part

Write something to turn the `$coffees` global variable into HTML that looks like this:

```html
<div>Flat White $3.50</div>
<br>
<div>Cappuccino $2.50</div>
```

> Remember, the `$coffees` variable is an array of hashes.

We'll want to loop over the `$coffees` array and turn each hash into an HTML string, surrounded by `<div>`s, which should then be all joined together with `<br>`s.  We'll also need to ensure we're returning a string.

For some solution ideas, [check out this](../snippets/coffees_html.rb.txt).
