## SCOPES

#### How to run?

* `rails db:create`
* `rails db:migrate`
* `rails db:seed`
* `foreman start`

#### Endpoints
The following is the structure for the endpoints documentation

* *Use Case* = Why a user needs this? What is the functionality?
* *End Point* = route to the request
* *Request Structure* = information about constructing request including authentication and headers
* *Sample Structure* = sample request
* *Backend Flow* = Private methods calls walking through flow

The following is the table for documentation marking:
* '--' needs to be built
* '-' is built, needs to be documented
* '+' is built, is documented
* '++' is built, is documented, is available in paw ( see below for more information about paw)
* '+++' is built, is documented, is available in paw, is testable with spec




#### [Paw](https://paw.cloud/)
Key things to keep note:
* Cookie window OPT + CMD + 2 to see session cookies
* At least one session cookie needed to sign-in (protect forgery)
* Enjoy this amazing tool 🙂