# MetBrowser
Welcome to a basic browser for the Metropolitan Museum of Art

## Component Folders

### Networking

Contains the `EndpointRequestType` which is an enum with associated values that are used to make queries to the public API.

The `EndpointRequest` class is a single use class that takes an `EndpointRequestType` as well as the type of data to decode the JSON into. It then retrieves the JSON from the server, if possible, and returns the already decoded data.

Currently there is no error handling. There isn't much that can be recovered. And I wasn't sure what the appropriate action would be in this case. Likely it would be passed up to the ViewModel which sould then use the `Status` enum with a new `.error(error)` case and provide some reflection of that in the UI.  Failing of an individual artifact loading isn't very interesting, and would be confusing to the user as there is nothing that can be done to correct.

### Models

There are only two models, both are using the standard synthesized codable. I've deleted some of the fields from the `MetArtifact` for simplicity sake.

** Of note here is that the `primaryImageSmall` field is a URL. And while I'm always passing the `hasImages` option as `true`, there are times it does not return a URL. This is a case where a failure happens silently. But we can't display it, so my option was to skip those items (which is what the failure does) or change it to a String, and in the `MetArtifactView` have it convert it to a URL. If it was unable to, then I could put in an "image missing" image instead. **

### Views

The Views folder contains the two SwiftUI Views that are used to display the content. 

The `MainView` is just that, it shows the main body view, which is dependent on the state of the fetching. 
- no fetching has begin, you're told to enter some text
- fetching in progress a progress circle is shown
- if no data matches (which I'm not sure is possible), it'll show that state

The `MainView` also does the setup for the menu bar. There is a sort menu for acending/decending order, a stop button to kill an in progress search, and a search field. If a search is in progress the Stop is enabled and the search field is disabled.

The `MetArtifactView` shows the data for each of the artifacts.

### Utilities

Two enums, `Status` which maintains loaded, loading, noSearch, and empty search. And `Sorting`. I could have (and perhaps should have) used SortOrder instead of defining my own. But I made a decision and stuck with it.  Perhaps if I'd had someone to chat with I'd have done otherwise.

### Necessary Files

This is a catch all group that I typically create that does not have a folder. It lets me put all the bitss and pieces that I don't typically interact with out of sight and out of mind.

## Known issues

There are a couple of issues that I'm aware of.

First, when you make a query, sometimes you get results from a `search` that don't have images, inspite of specifying you want them. This seems to be some API weirdness.
Even more confusing is that sometimes you'll get object IDs back from a `query` with objectIDs that just don't exist. I've tested them outside of the app and they just aren't there. This accounts, in part, for a number of silent failures. 

Both of these, when combined mean that, inspite of asking for 80 items, I'm rarely getting 80. Either they are missing a classification (not all have classifications, which is strange) and I don't want to make more than the 80 restricted calls per minute.

Finally, my knowledge of TaskGroup is early. I believe I'm using it correctly, but I'm not 100%. I feel it's important to point out when you don't know something and then use the available resources (often coworkers and online material) to extend that knowledge. The online material was thin, at best. 

I hope this is useful. There is DocC for msot of the major components.

Oh, I am using SwiftLint as a package plugin, so you'll need to tell it to Trust it from time to time. Or you can just remove it entirely.

I apprecate your time, and I hope things go foward!

Sincerely
Scott Anguish
sanguish@me.com (probably easier than LinkedIn)


