[ ![Codeship Status for jzornow/intacct-ruby](https://app.codeship.com/projects/161bbcb0-037f-0135-febb-660dbc75d940/status?branch=master)](https://app.codeship.com/projects/213338)

# IntacctRuby

A wrapper for [Intacct's API](https://developer.intacct.com/wiki/functions-object), which tries to stay as close as it can to the syntax and philosophy of the API itself.

## The Power of Multi-Function Api Calls
Unlike the other Gems out in the Rubyverse, this library supports one of the Intacct API's most powerful features: multi-function API calls.

### Why Does This Matter?
In an ERP system like Intacct, you'll probably want to perform multiple actions at once, like debiting one account and crediting another, or creating several associated records simulatenously. The more calls you make, the longer it will take to see a response. That's just a fact. But if you can bundle all of those actions together into a single call, you lower the load on both your system and Intacct's servers and guarantee yourself a quicker response. Intacct's entire API is built around this idea, and `IntacctRuby` translates that philosophy into Ruby.

### How To Do It?
Let's say you want to create a project and a customer associated with that project simultaneously. The Intacct API would tell you to create a call with a `<create><CUSTOMER>` function followed by a `<create><PROJECT>` function. So let's do it!

```ruby
# REQUEST_OPTS contains authentication information. See 'Authentication' section
# for more information.
request = IntacctRuby::Request.new(REQUEST_OPTS)

request.create :CUSTOMER, {
  CUSTOMERID: '1',
  FIRST_NAME: 'Han',
  LAST_NAME: 'Solo',
  TYPE: 'Person',
  EMAIL1: 'han@solo.com',
  STATUS: 'active'
}

request.create :PROJECT, {
  PROJECTID: '1',
  NAME: 'Get Chewie a Haircut',
  PROJECTCATEGORY: 'Improve Wookie Hygene',
  CUSTOMERID: '1',
  SHAMPOO: 'true', # a custom field
  BLOWDRY: 'false' # a custom field
}

request.send
```

**Note:** Here ```:CUSTOMER```  and ```:PROJECT``` are object-types which are tagged just after the function tag `create` and are case-sensitive along with the extra-parameters(CUSTOMERID, FIRST_NAME ..)

This will fire off a request that looks something like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<request>
   <control><!-- Authentication Params --></control>
   <operation transaction="true">
      <authentication><!-- Authentication Params --></authentication>
      <content>
         <function controlid="create-customer-2017-08-03 17:02:40 UTC">
            <create>
               <CUSTOMER>
                  <CUSTOMERID>1</CUSTOMERID>
                  <FIRST_NAME>Han</FIRST_NAME>
                  <LAST_NAME>Solo</LAST_NAME>
                  <TYPE>Person</TYPE>
                  <EMAIL1>han@solo.com</EMAIL1>
                  <STATUS>active</STATUS>
               </CUSTOMER>
            </create>
         </function>
         <function controlid="create-project-2017-08-03 17:02:40 UTC">
            <create>
               <PROJECT>
                  <PROJECTID>1</PROJECTID>
                  <NAME>Get Chewie a Haircut</NAME>
                  <PROJECTCATEGORY>Improve Wookie Hygene</PROJECTCATEGORY>
                  <CUSTOMERID>1</CUSTOMERID>
                  <SHAMPOO>true</SHAMPOO>
                  <BLOWDRY>false</BLOWDRY>
               </PROJECT>
            </create>
         </function>
      </content>
   </operation>
</request>
```

### Read Requests
The read requests follow a slightly different pattern. The object-type is mentioned inside the object tag as seen here [Intacct List Vendors](https://developer.intacct.com/api/accounts-payable/vendors/#list-vendors). The following code will read all vendor objects.

```ruby
request = IntacctRuby::Request.new(REQUEST_OPTS)

# Object-Type VENDOR is sent through extra-parameters and not as the first argument.
request.readByQuery nil, {
  object: 'VENDOR',
  query: '',
  fields: '*',
  pagesize: 100
}

request.send
```

**Note:** Clean up the query argument before using it in readByQuery function as mentioned here [Intacct Illegal characters in XML](https://developer.intacct.com/web-services/queries/#illegal-characters-in-xml).
          So, something like ```query: "BATCH_DATE > '02/14/2018'"```  should be  ```query: "BATCH_DATE &gt; '02/14/2018'"``` 
 



This will fire off a request that looks something like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<request>
   <control><!-- Authentication Params --></control>
   <operation transaction="true">
      <authentication><!-- Authentication Params --></authentication>
      <content>
         <function controlid="readByQuery-2017-08-03 17:02:40 UTC">
            <readByQuery>
                <object>VENDOR</object>
                <fields>*</fields>
                <query></query>
                <pagesize>100</pagesize>
            </readByQuery>
         </function>
      </content>
   </operation>
</request>
```

Similarly, for pagination use the ```readMore``` function as mentioned here [Intacct Paginate Results](https://developer.intacct.com/web-services/queries/#paginate-results)

```ruby
request = IntacctRuby::Request.new(REQUEST_OPTS)

request.readMore nil, {
  resultId: '7765623332WU1hh8CoA4QAAHxI9i8AAAAA5'
}

request.send
```

This will fire off a request that looks something like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<request>
   <control><!-- Authentication Params --></control>
   <operation transaction="true">
      <authentication><!-- Authentication Params --></authentication>
      <content>
         <function controlid="readMore-2017-08-03 17:02:40 UTC">
            <readMore>
              <resultId>7765623332WU1hh8CoA4QAAHxI9i8AAAAA5</resultId>
            </readMore>
         </function>
      </content>
   </operation>
</request>
```

If there are function errors (e.g. you omitted a required field) you'll see an error on response. Same if you see an internal server error, or any error outside of the 2xx range.

## Authentication
Before we go any further, make sure you've read the [Intacct API Quickstart Guide](https://developer.intacct.com/web-services/) and [their article on constructing XML Requests](https://developer.intacct.com/web-services/requests/)

In IntacctRuby - as with the Intacct API that the gem wraps - your system credentials are pass along with each separate `Request` instance. The functions that define a request are followed by a hash that spells out each piece of information required by Intacct for authentication. These fields are:

- `senderid`
- `sender_password`\*
- `userid`
- `companyid`
- `user_password`\*

\* _In [Intacct's documentation](https://developer.intacct.com/wiki/constructing-web-services-request), these are referred to only as `password`. This won't work in Rubyland, though, because we can't have multiple hash entries with the same key._

### Authentication Example:

```ruby
IntacctRuby::Request.new(
  some_function,
  another_function,
  senderid: 'some_senderid_value',
  sender_password: 'some_sender_password_value',
  userid: 'some_userid_value',
  companyid: 'some_companyid_value',
  user_password: 'some_user_password_value'
)
```
Though, it probably makes more sense to keep all of these in some handy constant for easy reuse:
```ruby
REQUEST_OPTS = {
  senderid: 'some_senderid_value',
  sender_password: 'some_sender_password_value',
  userid: 'some_userid_value',
  companyid: 'some_companyid_value',
  user_password: 'some_user_password_value'
}.freeze

IntacctRuby::Request.new(REQUEST_OPTS)
```

### Important Notes on Authentication
#### These Are Required!
Obviously, Intacct won't do anything if you don't tell it who you are. To save you the bandwidth, **this gem will throw errors if any of these auth params are not provided.**

#### BE SAFE!
Though the examples above show hard-coded username/password pairs, this is a really bad idea to do in production code. Instead, we recommend storing these variables in ENVs, using a tool like [Figaro](https://github.com/laserlemon/figaro) to bring it all together.

## Customizing Calls

This gem creates calls using the following defaults:
- **uniqueid:** false,
- **dtdversion:** 3.0,
- **includewhitespace:** false,
- **transaction:** true

If you'd like to override any of these, you can do so when you create a new request by adding additional fields to the options hash passed into `Request#new`:

```ruby
REQUEST_OPTS = {
  senderid: 'some_senderid_value',
  sender_password: 'some_sender_password_value',
  userid: 'some_userid_value',
  companyid: 'some_companyid_value',
  user_password: 'some_user_password_value'
}

REQUEST_OPTS.merge!(
  uniqueid: 'some_uniqueid_override',
  dtdversion: 'some_dtd_override'
)

IntacctRuby::Request.new(REQUEST_OPTS)
```
## Installation

### The Gem Itself
Add this line to your application's Gemfile:

```ruby
gem 'intacct_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install intacct_ruby

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jzornow/intacct-ruby/.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

