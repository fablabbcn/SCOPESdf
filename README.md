# SCOPES

### How to run?

* get [postgis](http://postgis.net/install/)
* set `.env` file
* `rails db:create`
* `rails db:schema:dump` -- if missing
* `rails db:migrate`
* `rails db:seed`
* `foreman start`


#### [Paw](https://paw.cloud/)
Key things to keep note:
* Cookie window OPT + CMD + 2 to see session cookies
* To protect_from_forgery (CSRF) alter controllers by adding the following in ``ApplicationController``                               
        
        skip_before_filter :verify_authenticity_token, if: :json_request?
        def json_request?
            request.format.json?
        end
        
* Enjoy this amazing tool 🙂


#### The styleguide

You will need to bundle install for this. The styleguide is built on top of [Hologram](https://github.com/trulia/hologram). Just run `foreman start` as you would do and point the browser to your server address **/styleguide**.

It takes the real site styleguide and adds some (still) cheesy formatting.