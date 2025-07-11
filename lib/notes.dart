// TODOs (Hayyan Section): ======================================================

// 0- fix the 'personal profile page' 
// 1- create the 'edit profile' btn
// 2- create the status functions in account remote data source after defining them in app endpoints
// 3- create the presentation for those status new endpoints
// 4- create the 'users page' with its bloc for pagination
// 5- create the 'other user page' with his follow bloc and btn
// 6- fix the 'update profile page' in both main line 118 and the full page in update_account_page.dart and btn => check the pAccount in PAccountBloc if its actually chaning the add_status_widget picture aftering updating the profile
// 7- check for functionality of that 'following statuses '
// 8- create the 'follow btn' for each simple account widget after fixing the 'follow bloc'
// 9- make an enum for the following status {following, not following, pending} and update the method corresponding to that at @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\data\data-sources\account_remote_data_source.dart and change the implementation for the repository in @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\data\repository\account_repository_impl.dart and in @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\domain\repository\account_repository.dart for the updateFollowingStatus => need to change the output based on that (when private+ request to follow => show 'pending' based on the follow status ) in @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\other_account_page.dart and in @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\widgets\simplified_account_widget.dart (Note: you must relay on the backend response to determine the next status, the backend methods are : )
// 10- fix this private account issue with the follow request
// 11- create the 'delete status' btn in the show status page (after creating the boolean attr 'personalStatuses' ) in it and default it to false then pass it from personal account page as true   
// 12- create the 'delete account' btn in the settings bottom sheet
// 13- create the 'block other account' btn in the other account page (add the pop up menu in the app bar actions)
//* 14- create the 'block users' btn in the home page settings bottom sheet
//* 15- check the 'delete account' after hamza push git changes

//! next step : creating the local notifications section 
//* 1- create the notification section in home page for (requests)
//* 2- handle (accept) the follow request

// ?Feature TODO: in account feature in account section: 
// ! 1- block a user
// 2- delete an account
// ! 3- get User Highlightes
// ! 3- add a status to highlights
// 4- delete a status
// 5- handle private status logic
// 6- handle private other account logic

// TODOs (End Hayyan Section): ======================================================

//? Adiveces for friends:

// ! 0- you need to change the baseUrl if you're using a physical debug device (can be found at api_endpoints.dart) 
// ! 1- for token usage I've created a token service class with (get - add new and delete old) methods
// ! 2- for accessing the vids or imgs inside the app there are two ways :
// * 1. using the image picker package methods located in functions.dart
// * 2. using the widget which shows a gallery named gallery_widget.dart
// ! 3- for media showing we're using cached network img for the images and cached_video_player for videos => the widgets can be found in the core section 
