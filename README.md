# Events (Belt Reviewer)

### A Java app where users create/edit/delete/join events and leave messages  
##### From the Java (Spring Boot) stack at Coding Dojo


Objectives:
* Set up Spring Boot project
* Add login/registration with validations
* Display all events organized by state:
  * First table shows all events occurring in logged-in user's state
  * Second table shows all other events
* Each event should have an action/status column:
  * If logged-in user is the creator of the event, user can edit/delete event
  * User can either join or un-join an event
* Event detail page:
  * Display list of all attendees
  * Message wall where users can post messages
