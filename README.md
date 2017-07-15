# SCOPES

### How to run?

* get [postgis](http://postgis.net/install/)
* set `.env` file
* `rails db:create`
* `rails db:schema:dump` -- if missing
* `rails db:migrate`
* `rails db:seed`
* `foreman start`



#### Passable Models - Used for documentation below
Each model file has the required parameters as JSON For examples  see SeedService > //desired model//





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












## _Lessons_


### NEW
The page at ` /lessons/new ` shows the inputs used for creating a lesson. 
Currently their are 5 partials comprised of the inputs. 

** DO NOTE **: Steps ( Lesson.steps ) do have a separate endpoint

Upon user updating any of the fields the ( entering data in one and then focusing on another ), the inputs POSTS an AJAX JSON request to the following endpoint: ` /lessons `

This request does the following
* makes the entity if no `id` is given in params
* updates the lesson object with according JSON ( see structure below )
* returns the lesson.id for the front-end to save and submit on subsequent requests
* returns file data such as thumbnails or image links, attributes of lessons, that were user submitted
* Returns the publishable status (boolean) if it is ready to publish. As well as publish details a hash showing which essential data it is missing for a publish

JSON structure that need to be work in accordance with design are as follows

```json
    lesson :
            {
                # TAB 1 - Overviewr
                # Basic Information
                name: "Name here",
                topline: "Here is topline",
                summary: "Here is summary",

                # Authors
                other_users_emails:
                    ["user2@example.com" ], # will already call current user with authentication of session
                associated_places_ids:
                    [ Organization.first.id ],

                # Objectives
                learning_objectives:
                    [ "Learn how to build something", "Learn how to build this other thing"],

                # Lesson Ambitions
                description: "Here is description",
                assessment_criteria: "Here is criteria",
                # assessment_criteria_files get set on another form!!

                further_readings:
                    ["https://www.youtube.com/watch?v=P2r9U4wkjcc", "http://mit.org"],


                # TAB 2 - Standards

                standards:
                    [{
                        name: "standard name is here",
                        descriptions: [ "some description here", "and another here" ]
                    },
                    {
                        name: "other standard",
                        descriptions: [ "other standard desc", "yet another for other standard" ]
                    }],

                # Tab 3 - Details
                grade_range: {start: 0, end: 12},
                subjects:
                    ["technology", "science"],
                difficulty_level:
                    { student: "1", educator: "2" },
                skills: [
                    { name: "CNC", level: "4" },
                    { name: "Welding", level: "3" }
                ],
                context:
                    ["In Classroom", "Outdoors"],
                collection_tag: "Gold Standard Lesson",
                tags:
                    ["Pinball"]
            }
            
    assessment_criteria_files : [ //USER FILE//, .... ]
    outcome_files : [ //USER FILE//, .... ]
    id = // ID OF LESSON TO UPDATE //
```

At least a `lesson` object is required, even if it is empty on post. 

returning:
```json
    {lesson_id: //LESSON_ID//,
    lesson_obj: //LESSON//,
    publishable: // BOOLEAN //,
    publishable_details: //{ SEE Lesson::publishable_values}///}
```

The pages themselves requires some dynamic data / content:

* Tab1 - Overview:
    * Current User ( See User Search )
    * Searchable field of Users... if user not found, upon data POST to ` /lessons `, invitation is sent via email
        * Submit user emails* to endpoint 
    * Searchable Organizations ( See Organization Search )
        * Submit organization.id to endpoint
    * Asessment Criteria Files - upon user upload backend returns a url to the item. If you want to remove the item, submit to the endpoint without any files data
    * Further Readings - upon user submitting links, the backend returns, urls to thumbnails for this attribute `further_readings`, inside the lesson object.
    
* Tab3 - Details:
    * Subjects - array of strings given upon page load
    * Context - array of strings given upon page load
    * Collection - array of strings given upon page load ( Subject to change....)
    * Searchable Tags ( See Tags Search )
        * Submit Tag string to the endpoint
    
* Tab 5 - Outcomes:
    * Outcome Files - upon user upload backend returns a url to the item. If you want to remove the item, submit to the endpoint without any files data
      

To publish a lesson post to `/lessons/:id/publish` where `:id` is the id of a lesson
it returns `{success: true // false}` depending if it worked or not


## Steps

### NEW / UPDATE
POST to `lessons/:id/step` where `:id` is the id of a lesson
given the following information
```json
      step: {
          id: // ID OF STEP//,  // for updating.. optional field
          summary: "Step Subject Here",
          duration: "1508",
          description: "description of my step here",
          materials: [
              {number: "4",   name: "Computers" },
              {number: "35",  name: "Beakers" }
          ],
          tools:
              ["3D Printer"],
      }
      supporting_files: [ //USER FILE//, .... ]
      supporting_materials : [ //USER FILE//, .... ]
```
appends the step to the current lesson with the given id if no ID is given

### DELETE
DELETE to `lessons/:id/step/:step_id` where `:id` is the id of a lesson and `:step_id` is the id of the step you want to delete
Deletion will sort and re count step_numbers according to  creation time







## Search: '++'
UserCase: To Search Objects
Endpoint: `` POST search/:entity `` where ``:entity`` is the name of the model you are querying
Controller: ``search#main``
Request Structure:
```json
 "search": {
     "filter": {
       "name": "VALUE"          // See controller for acceptable keys in filter
     },
     "format_response": "VALUE" // See controller for acceptable value in format_response
   }
 
```

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