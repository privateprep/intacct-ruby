[ ![Codeship Status for jzornow/intacct-ruby](https://app.codeship.com/projects/161bbcb0-037f-0135-febb-660dbc75d940/status?branch=master)](https://app.codeship.com/projects/213338)

# IntacctRuby

A wrapper for [Intacct's API](https://developer.intacct.com/wiki/functions-object), which tries to stay as close as it can to the syntax and philosophy of the API itself.

## The Power of Multi-Function Api Calls
Unlike the other Gems out in the Rubyverse, this library supports one of the Intacct API's most powerful features: multi-function API calls.

### Why Does This Matter?
In an ERP system like Intacct, you'll probably want to perform multiple actions at once, like debiting one account and crediting another, or creating several associated records simulatenously. The more calls you make, the longer it will take to see a response. That's just a fact. But if you can bundle all of those actions together into a single call, you lower the load on both your system and Intacct's servers and guarantee yourself a quicker response. Intacct's entire API is built around this idea, and `IntacctRuby` tries to translate that philosophy into Ruby code as best as it can.

### How Do It Do?
Let's say you want to create a project and a customer associated with that project simultaneously. The Intacct API would tell you to create a call with a `<create_customer>` function followed by a `<create_project>` function. So let's do it!

```ruby
create_customer = IntacctRuby::Functions::CreateCustomer.new(
  customerid: '1',
  first_name: 'Han',
  last_name: 'Solo',
  type: 'Person',
  email1: 'han@solo.com',
  status: 'active'
)

create_project = IntacctRuby::Functions::CreateProject.new(
  projectid: '1',
  name: 'Get Chewie a Haircut',
  projectcategory: 'Improve Wookie Hygene',
  customerid: '1',
  customfields: {
    shampoo: 'true',
    blowdry: 'false'
  }
)

request = IntacctRuby::Request.new(create_customer, create_project, authentication_params)
request.send
```

This will fire off a request that looks something like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<request>
   <control>
      ** omitted **
   </control>
   <operation transaction="true">
      <authentication>
         ** omitted **
      </authentication>
      <content>
         <function controlid="create_customer_1">
            <create_customer>
               <customerid>1</customerid>
               <name>Han Solo</name>
               <status>active</status>
               <contactinfo>
                  <contact>
                     <contactname>Han Solo (Customer #1)</contactname>
                     <printas>Han Solo</printas>
                     <firstname>Han</firstname>
                     <lastname>Solo</lastname>
                     <email1>han@solo.com</email1>
                  </contact>
               </contactinfo>
            </create_customer>
         </function>
         <function controlid="create_project_1">
            <create_project>
               <projectid>1</projectid>
               <name>Get Chewie a Haircut</name>
               <projectcategory>Improve Wookie Hygene</projectcategory>
               <customerid>1</customerid>
               <customfields>
                  <customfield>
                     <customfieldname>shampoo</customfieldname>
                     <customfieldvalue>true</customfieldvalue>
                  </customfield>
                  <customfield>
                     <customfieldname>blowdry</customfieldname>
                     <customfieldvalue>false</customfieldvalue>
                  </customfield>
               </customfields>
            </create_project>
         </function>
      </content>
   </operation>
</request>
```
If there are function errors (e.g. you omitted a required field) you'll see an error on response. Same if you see an internal server error, or any error outside of the 2xx range.

## Authentication
Before we go any further, make sure you've read the [Intacct API Quickstart Guide](https://developer.intacct.com/wiki/constructing-web-services-request#The%20Intacct%20DTDs).

In IntacctRuby - as with the Intacct API that the gem wraps - your system credentials are pass along with each separate `Request` instance. The functions that define a request are followed by a hash that spells out each piece of information required by Intacct for authentication. These fields are:

- `senderid`
- `sender_password`\*
- `userid`
- `companyid`
- `user_password`\*

\* _In [Intacct's documentation](https://developer.intacct.com/wiki/constructing-web-services-request), these are referred to only as `password`. This won't work in Rubyland, though, because we're unable to have multiple hash entries with the same key._

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
}

IntacctRuby::Request.new(some_function, another_function, REQUEST_OPTS)
```

### Important Notes on Authentication
#### These Are Required!
Obviously, Intacct won't do anything if you don't tell it who you are. To save you the bandwidth, this gem will throw errors if any of these auth params are not provided.

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

IntacctRuby::Request.new(some_function, another_function, REQUEST_OPTS)
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

## Adding New Functions
This gem was designed, as so many are, for a specific use case. The Intacct API has hundreds of API calls, though I only built out a dozen or so. Within that dozen, I only built out the fields that I needed in each call.

I know what you're thinking:
**You dweeb! Why didn't make the stuff that I need, too?**

I didn't, because I have full confidence in your ability to do it yourself. These calls are easy to construct, and they almost perfectly mirror the structure of the XML shown in Intacct's API documentation. You can figure it out! You're a developer, for shirt's sake.

If you're interested, feel free to reach out to me for information on how to build or improve the functions that are already present in this gem.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jzornow/intacct-ruby/.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

