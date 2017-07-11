## SCOPES

#### How to run?

* set `.env` file
* `rails db:create`
* `rails db:schema:dump` -- if missing
* `rails db:migrate`
* `rails db:seed`
* `foreman start`

#### Passable Models - Used for documentation below
Each model file has the required parameters. For bare minimums see CreateSeedService > //desired model//



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



#### _User_
##### Creation doc: '+'
UseCase: Devise user creation, JSON is available but needs CSRF! else use Devise Form..
Endpoint: `` POST users``
Request Structure: See ``controllers/registrations_controller.rb`` (CSRF, needed)
Sample Structure: See ``controllers/registrations_controller.rb`` (CSRF, needed)
Backend Flow: Devise, Validations on User. Activerecord.
Interface Flow: User created, avatar added, one affiliations made (TODO - see if optional?), About You form fields (TODO - are these right?)


##### User Affiliate with Organization: '+'
UseCase: Affiliate a user with an organization, if already affiliated response will state
Endpoint: `` users/affiliate' => 'users#affiliate_organization_id``
Request Structure: base params[:id] ( for user ), params[:organization_id]
Sample Structure:
Backend Flow: @user.addOrgId?().
Respones: "true" ( new association made), "already added" ( assocaition already made ), "failed", organiation.id incorrect











#### _Lessons_

##### Creation doc: '++'
UseCase: Create Lesson from form 
Endpoint: `` POST lesson``
Controller: ``lessons#create``
Request Structure: `` "lesson": { "attribute_name": value }  ``
Sample Structure: See `` "lesson": { "name": "Name here" } `` -- minimum  see paw for more & ``lesson_params``
Backend Flow: Lesson(validated_params).save, and associating user with user.

##### Update doc: '++'
UseCase: Checks to see if user associated with given lesson id, then updates
Endpoint: `` PUT lesson/:id``
Controller: ``lessons#update``
Request Structure: `` "lesson": { "attribute_name": value }  `` 
Sample Structure: See `` "lesson": { "name": "Name here" } `` -- minimum  see paw for more & ``lesson_params``
Backend Flow: Pundit - lesson policy to ensure author, set attributes

##### Add Step doc: '++'
UseCase: Checks to see if user associated with given lesson id, adds steps
Endpoint: `` PUT lesson/:id/steps``
Controller: ``lessons#add_step``
Request Structure: `` "steps": [ {"attribute_name": value }, ... ] `` 
Sample Structure: See paw - and note structure of JSON attributes accepting arrays in their place
Backend Flow: Pundit - lesson policy to ensure author, set attributes. steps are appended in the order they are given ( todo - can they be re-ordered? ) to the lesson UUID given



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