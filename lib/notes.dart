//! OAuth 

//* need to register all team workers debug SHA1 fingerprint at Google Cloud
//* need to change the Android OAuth client ID after Hayyan changes the Project Name ( because package name will be subsequentially changed)
//* need to change the baseUrl if you're using a physical debug device (can be found at api_endpoints.dart) 

// TODOS:
// 1- update the auth so that it contains 'id' and send it in account repo impl after fetching the local user id
// 2- find out how to get token in the best way (ask chat gpt)
// 3- ask AI on how to create a validation entity for that validate user name method with attributes (valid, message) 

// TODO:
// 0- fix the 'personal profile page' 
// 1- create the 'edit profile' btn
// ! 2- create the status functions in account remote data source after defining them in app endpoints
// ! 3- create the presentation for those status new endpoints
// ! 4- create the 'users page' with its bloc for pagination
// * need to first update the follow methods then create the get follow(ings/ers)
// ! 5- create the 'other user page' with his follow bloc and btn
// * need to first update the follow methods then create the get follow(ings/ers)

// TODO: in feature: 
// ! 1- block a user
// ! 2- delete an account


//? Adiveces for friends:
// ! 1- for token usage I've created a token service class with (get - add new and delete old) methods
// ! 2- for accessing the vids or imgs inside the app there are two ways :
// 606 hours 3hours 1
// * 1. using the image picker package methods located in functions.dart
// * 2. using the widget which shows a gallery named 
// ! 3- for media showing we're using cached network img for the images and cached_video_player for videos => the widgets can be found in the core section 