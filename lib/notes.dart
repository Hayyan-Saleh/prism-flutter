//! firebase

//* in  [ lib\firebase_options.dart ] you must edit the apiKey, appId, messagingSenderId, projectId, storageBucket
//* in [ android\app\google-services.json ] you must edit the current_key, app_id, project_number, project_id, storage_bucket


//! OAuth 

//* need to register all team workers debug SHA1 fingerprint at Google Cloud
//* need to change the Android OAuth client ID after Hayyan changes the Project Name ( because package name will be subsequentially changed)
//* need to change the baseUrl if you're using a physical debug device (can be found at api_endpoints.dart) 

// TODOS:
//* add the send_verification_code event in auth bloc
// developer.log('Your message here.', name: 'MyAppLogger', level: 1000);