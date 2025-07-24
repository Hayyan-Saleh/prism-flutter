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
// 14- create the 'show blocked users' btn in the home page settings bottom sheet
// 15- make the 'getBlockedAccounts' usecase inside the 'accounts bloc' instead of the 'oAccountBloc' and fix their pages in blocked accounts page...
// 16- create 'getArchivedStories' btn in the homepage settings bottom sheet (status bloc)
// 17- add a the liking functionality to a status and alter the status entity
// 18- add a the 'show likers' functionality to a status and use the accounts bloc
// 19- make a pauser in the status timer when the likers page is pushed or popped
// 20- paus the timer on long tap whatever the status type is ('txt only', 'img & text', 'vid & text') in [show_status_page, show_status_widget, single_status_page, show_detailed_highlight] @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_status_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\widgets\show_status_widget.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\single_status_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_detailed_highlight.dart
// 21- Fix the 'txt only' flaw (not being showed properly when exceeds its current size) in the pages  [show_status_page, show_status_widget, single_status_page, show_detailed_highlight] @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_status_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\widgets\show_status_widget.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\single_status_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_detailed_highlight.dart
// 22- Fix the 'video' flaw (if it's the last status then we're making two pops in navigation which is incorrect) in the pages  [show_status_page, show_status_widget, single_status_page, show_detailed_highlight] @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_status_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\widgets\show_status_widget.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\single_status_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_detailed_highlight.dart
 
//! highlights
// 1- add highlight to account : Route::post('/highlights', [HighlightController::class, 'store']);
// 2- get account's highlights : Route::get('/highlights', [HighlightController::class, 'index']);
// 3- get detailed highlight : Route::get('highlights/{id}', [HighlightController::class, 'show']);
// 4- delete a highlight : Route::delete('/highlights/{id}', [HighlightController::class, 'destroy']);
// 5- set a cover to a highlight: Route::post('/highlights/set-cover', [HighlightController::class, 'setCover']);
// 6- add new status to an existing highlight: Route::post('/statuses/add-to-highlight', [StatusController::class, 'addToHighlight']); 
// 7- remove the 'add higlight ' btn from the higlight section and add it in the app bar 'actions' section in the personal account page
// 8- fix the archived_statuses_page to show statuses as small list tiles which interact to show the full status onTap and select the status to add it to a specific higlight on long tap
// 9- fix the highlight_entity to have new 'status_as_cover' attribute to show it when no cover exists in higlight_widget
// 10- fix the 'create highlight' action btn so that when it navigates back the the personal account page we fetch the data respectively (account + highlights)
// 11- fix the show_detailed_highlight.dart to remove the pop up menu controlls when it's being navigated to from the other account page (by firstly refining the show_highlights_page.dart to accept that boolean value and passed respectivley to that other page), needed files are :@D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_highlights_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\show_detailed_highlight.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\personal_account_page.dart @D:\WORK\Flutter\Univesity\prism\prism-flutter\lib\features\account\presentation\pages\account\other_account_page.dart




//! groups:
// 1- create a group : Route::post('/', [GroupController::class, 'store']);
//* 2- show a group : Route::get('/{group}', [GroupController::class, 'show']);
//* 3- update a group : Route::post('/{group}', [GroupController::class, 'update']);
//* 4- delete a group : Route::delete('/{group}', [GroupController::class, 'destroy']);
//* 5- join a group : Route::post('/{group_id}/join', [GroupController::class, 'join']);
//* 6- leave a group : Route::post('/{group_id}/leave', [GroupController::class, 'leave']);
//* 7- list group members : Route::get('/{group}/members', [GroupController::class, 'members']);
//* 8- list join requests : Route::get('/{group}/requests', [GroupController::class, 'pendingRequests']);
//* 9- respond to request : Route::post('/{group}/requests/respond', [GroupController::class, 'respondToRequest']);

//! notifications section 
// 1- create the notification section in home page for (requests)
// 2- handle (accept/reject) the follow request


// ! ai work checks:


//! errors:
/*
* on upload video status to make a single highlight
{"error":"Failed to create highlight.","details":"Unable to probe C:\\xampp\\htdocs\\3d year project\\prism\\socialMediaProject\\storage\\app\/public\/statuses\/4pWFqvi047299KZfgKfLr5E5hfXi3z6nSEj2aNwO.mp4"}
*/

// ?Feature TODO: in account feature in account section: 
// 1- block a user
// 2- delete an account
// 3- get User Highlightes
// 4- add a status to highlights
// 5- delete a status
// 6- handle private status logic
// 7- handle private other account logic
// ! 8- create/ delete/ update a group

// ?Feature TODO: in account feature in notification section:
// 1- handle account follow requests notifications  
// ! 2- handle group follow requests notifications  

// ? TODOS: ON END the account feature:
// ! 1- fix all text fields which could make an overflow
// ! 2- fix api endpoints file in auth strings so that they don't rely on the hard coded string from the rather the one from the api client
// ! 3- see if you can fix the error in which the 'cached_video_player' is finding troubles when changing the url of a video from 10.0.2.2 to 192.168.1.xx or in the opposite way (video won't play or load) or it is because of bad connection with backend server
// ! 4- refine ui in showArchivedStatuses
// ! 4- refine ui in Show Highlights Section 
// TODOs (End Hayyan Section): ======================================================

//? Adiveces for friends:

// ! 0- you need to change the baseUrl if you're using a physical debug device (can be found at api_endpoints.dart) 
// ! 1- for token usage I've created a token service class with (get - add new and delete old) methods
// ! 2- for accessing the vids or imgs inside the app there are two ways :
// * 1. using the image picker package methods located in functions.dart
// * 2. using the widget which shows a gallery named gallery_widget.dart
// ! 3- for media showing we're using cached network img for the images and cached_video_player for videos => the widgets can be found in the core section 
// ! 4- for the post/comment like we can use the 'like bloc' and provide it in the required scope respectively after adding the required usecases
