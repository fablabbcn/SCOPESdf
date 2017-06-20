## SCOPES

#### How to run?

* `rails db:create`
* `rails db:schema:dump` -- if missing
* `rails db:migrate`
* `rails db:seed`
* `foreman start`




#### Endpoints
The following is the structure for the endpoints documentation

* *Title* = Short Name description of the project with `key` (see below)
* *Use Case* = Why a user needs this? What is the functionality?
* *End Point* = route to the request
* *Request Structure* = information about constructing request including authentication and headers
* *Sample Structure* = sample request
* *Backend Flow* = Private methods calls walking through flow
* *Interface Flow*(optional) = expected interface flow


The following is the table for documentation marking for `key`:
* '--' needs to be built
* '-' is built, needs to be documented
* '+' is built, is documented
* '++' is built, is documented, is available in paw ( see below for more information about paw)
* '+++' is built, is documented, is available in paw, is testable with spec

.......
.......
.......

##### _User Creation_ doc: '+'
UseCase: Devise user creation, JSON is available but needs CSRF! else use Devise Form..
Endpoint: `` POST \users``
Request Structure: See ``controllers\registrations_controller.rb`` (CSRF, needed)
Sample Structure: See ``controllers\registrations_controller.rb`` (CSRF, needed)
Backend Flow: Devise, Validations on User. Activerecord.
Interface Flow: User created, avatar added, one affiliations made (TODO - see if optional?), About You form fields (TODO - are these right?)






#### [Paw](https://paw.cloud/)
Key things to keep note:
* Cookie window OPT + CMD + 2 to see session cookies
* To protect_from_forgery (CSRF) alter controllers by adding the following in ``ApplicationController``                               
        
        skip_before_filter :verify_authenticity_token, if: :json_request?
        def json_request?
            request.format.json?
        end
        
* Enjoy this amazing tool 🙂