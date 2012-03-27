# server.coffee
# -------------
#
# This is a trivial example of a gumroad webhook server, written in CoffeeScript, intended to run on Node.js.

express = require 'express'
app = express.createServer()

# This URL should be hard to guess, so that your users won't generate their own unique URLs without paying!
webhook_url = '/749fefc5b24bfafef5db020cff1954f08daeaf99'

# Webhook handler.
app.post webhook_url, (req,res) ->
  email = req.param 'email'
  price_paid = req.param 'price_paid'

  res.contentType 'text/plain' # This *must* be text/plain.

  # Here the unique URL is just the same information that was passed to us. In a real-world case, you might 
  # generate a token to be accessed later. This is the URL that the user will be redirected to.
  optional_price_paid = if price_paid? then "/#{price_paid}" else ""
  res.send "http://#{req.header 'host'}/webhook-success/#{email}#{optional_price_paid}"

# Unique URL handler.
app.get '/webhook-success/:email/:price_paid?', (req,res) ->
  # This is what the user sees after the redirect.
  price_paid_text = if price_paid? then " You paid #{price_paid} for this link!" else ""
  res.send "Hi #{email}!#{price_paid_text}"

app.listen process.env.port or 3030
