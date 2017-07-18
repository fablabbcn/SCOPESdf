# Location Specs
The following is location specs for the map and location services for SCOPES


The following pages attached in this zip cover the UI for location services.
The use cases are the following:

Entity Map: map area for user creation to designate location, also connects with browser location. This map just needs to save lon/lat, and address fields in a JSON object that can be packaged and sent to server later.
* This html partial needs a form and a button ( see designs )
    * a button to ask for browser location populate an address in the form fields
    * a form ( auto complete support) asking for address which updates the map
* This html partial needs a small map
    * a map which is updated with browser OR input fields get location, and saves it into JSON.




List Map - map area for presenting objects in a paginated table and interaction between each group ( think airbnb interactivity )
* A List of objects that have lon / lat
    * This list is obtained from an testing endpoint `https://scopes-staging.herokuapp.com/lessons/list_json`, which provides JSON
    * When an object in this list is hovered over, the map should center the object's respective anchor in the center
    * You can use the name field in the returned json objects to display in the cell in the list.
    * Clicking on an item on the list loads to a new page, you can trigger an alert with unique JSON data if you'd like
* A Large map
    * showing markers in correlation to the lon/lat of the objects given in the respective endpoint
    * clicking an anchor, centers it in the map, and highlights the object in the list on the side.
* This page DOES NOT NEED A FORM - no input fields required.
    

For the above I prefer you build in Google Maps / Places.
Javascript API key: `AIzaSyDs0CNdw4bnFEBjSMd560F0E2XVEWby9vU`

Some help:
* https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete-addressform
* https://developers.google.com/maps/documentation/javascript/get-api-key

All deliverables should be partials, if you check the designs you see a header footer and other layouts you can ignore all of that.

For the Entity map please submit: form, button and a map ( as in designs with full css for components for desktop through  mobile )
For the List map please submit: map and side list ( as in designs with full css for components for desktop through mobile )

Please note when regarding designs:
As you can see there are a lot of pages that use these two modules, Places and User create use entity map, and everything else uses List map.

I am available anytime to talk via email, lucaslpena@gmail.com or whatsApp +34 651 311 954 