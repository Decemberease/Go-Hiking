# GoHiking

## App Icon

<img src="https://lh7-us.googleusercontent.com/jRiZJ8q6rztuROC4fAEg7gU8aBGbEPpBT85qkj2dd289astUolcaw3IcHNB7JIGy8a4BBqy9etkoTcF06qi4J9KeRHkkqf3YroSY20F_mgIMqqTSZHKp_QGP8fI_ptvZ6rHHlWVq2H2GIWu-wiOiDV-s0g=s2048" alt="img" style="zoom: 25%;" />

## About

Go Hiking is a hiking tracker app built exclusively for iOS with SwiftUI. It is intended to be extremely easy to use for climbers of all levels.

A key part of Go Hiking is it's privacy stance, there is no requirement for a sign in of any kind and all data is solely stored on the user's device. It also does not contain any advertisements.

Go Hiking makes use of many of Apple's frameworks and API's including:
* Core Location for location data
* MapKit for embedded maps throughout the app
* Core Data for persistent data storage of hiking routes and user preferences
* CloudKit for iCloud storage and synchronization of routes, records and preferences
* Combine for location update event processing

## System Requirements

This app is designed to support all iPhones and iPads with iOS14/iPadOS14 and above due to the use of the latest SwiftUI features.

For iPads, this includes support for both landscape and portait modes along with Slide Over and multitasking screen sizes.

## Usage

Note: For Go Hiking to track your current location, you must allow location access in Settings (the app will also ask for permission on the first launch). The location permissions must be set to "Always Allow" for location updates to occur while the app is not on the screen.

To use this app, first, start a new hiking route from the Cycle tab. The timer should start incrementing, you can choose to leave your device locked or unlocked.

While the route is ongoing you will see metrics on the Cycle tab of your current progress as well as your path on the map.

Once you are finished with your hiking route, you can compelete the route by using the stop button. The route will be saved to your device and is viewable in the History tab along with metrics about the route.

More routes can be created in this same way and they can all be viewed, sorted and deleted from the History tab.

## App Features

Go Hiking has many features packed into four tabs; Cycle, History, Statistics and Settings. It also fully supports both light and dark mode, automatically setting the mode based on device settings.

Note: All screenshots shown were taken on an iPhone 12 Pro Max simulator.

### Features of the Cycle Tab
* Start, stop, pause and resume routes with the on-screen stopwatch
* View current hiking metrics, including distance cycled, speed and altitude
* Large map showing current location and path taken
* Timer showing hiking time of the ongoing route
* Assign your route to a new/existing category upon completion

### Device Screenshots of the Cycle Tab
 Cycle Tab Without Ongoing Route                              | Cycle Tab To End Current Route                               | Cycle Tab For Pause Or Stop Route                            | Cycle Tab With Information                                   
 ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ 
 ![img](https://lh7-us.googleusercontent.com/A-C_tmLOYN5OXtlZBDzSKPT51xa1cuL-LWE4cTLKxFKG6Q0HBYGUwghKopX4g-DCcv13md_Af0oiM5iPMP6SB5IoOlM66aTA6u2VaCu-6vr1zKG_EwxSf5wt2TxcdeVWtMPPrWGDLIUxnEjJCz4l3AgIIw=s2048) | ![img](https://lh7-us.googleusercontent.com/8qnAkjfHIesJGc6Jkg3vqQZ2fDG-_7nC5eW63ZQub7jzOpXooL7M3vGlmMMctWAwE0BDLVJzgo9O2riyDTkMpI2QqCsyLMIJ-5z1QUg6eaM5OdVAf-osCQ4E3UbnGXVIzvP37jKw09yTgiFT7_T_bzgPdQ=s2048) | ![img](https://lh7-us.googleusercontent.com/Nveye-8wRthbr_hMuFlo3RmJdFFtVE2yQLvteQWqytp8KcRQ_mu4upeDi7Ypq8fw0J-r_PCrJ3sb8Xymx6WzhQWJ86nw8mTcsN_3fd_cmkdKfKIub_XCbX-HwVBxe2GMoDjY2jCB5CnQKIWKFXcqwbBb-A=s2048) | ![img](https://lh7-us.googleusercontent.com/iT34RCdaoPUDjssThpD9DUDZ33ZnVv8yzfAh30oUQ9-JA24BKQFf9_Kzu6xzoS4YxhomCQCh_B5oiueW_MEA6MB8JtqDSKCByc53r91cnI1_H9mmKNaaZ4lvCwWMA0kc9LDcoZi1a_gMJrYkaa8CpUqY2Q=s2048) 

### Features of the History Tab
* View all past hiking routes in an easily readable list
* Sort all of your routes by time, distance and date (all offering ascending or descending order)
* Filter your routes by their category, rename your categories or recategorize individual routes
* Click on a single route to view a full screen view including a map of the route as well as metrics
* Each list entry is deletable by swiping to the left

### Device Screenshots of the History Tab
Hiking History List View | Reorder Hiking History | Rename Hiking Route | Single Hiking Route Detailed View 
------------------------------- | ------------------------------------ | ---------------------------- | ---------------------------------
 ![img](https://lh7-us.googleusercontent.com/JB6bnjErqNQPpVWrRSM2rVq5mMPUJUuaZPY3GkMEhoWaJcQ0wK_ym5zlnot0T5FESiePmnpicJBNff8K9GSYsn0HPtEQoV9pR9AZA8euklgpbTwKVktmKI-T5hZ0lGq0beddzdbvTy9-rAkYpyGpI3nMUA=s2048) | ![img](https://lh7-us.googleusercontent.com/AIf7NYbZJPPbYZm4Qjn30_AgHPMsN7_hCwYJLHYAfBZoXXJC4eYR_KX8twJSwn5Ha_5aeLYVB2Qx4Kj_XqXeka5H9oC5PPC88wjfhH09t6PjfNP-4ij-Ad2BCjLJdERFTJrxUqBQi7zE8WKHqUXWYVonOw=s2048) |![img](https://lh7-us.googleusercontent.com/056pRBuzPZ5Hh-hA810v-4QMaJdh4Gjilssauueo7JVnoyPTixlDCzbg15LTudNgsXuMFrCo6p9zXG0PYsw3VZpaBYAp6tGWoxq5XgsewRRqWkfK316omp-_faEX7ezl6HUXzp54MJen17VoaS5x4xdw8g=s2048)|![img](https://lh7-us.googleusercontent.com/RKaW2C4nmWXo0iQSaWTkuEdIZmP_mG98WAJ0hZ4AadU-EhZpqdSMOhxnHHhCwaeSyYScNWCdrnIMhL7lajtRigIYneRFaCG9ACqmW_VRd198m_y0IW9wPsaHzD083fgrKUJm8On60bZI7NXCdbtFCinI2A=s2048)

### Features of the Statistics Tab
* View detailed charts of hiking activity of past week, 5 weeks and 30 weeks
* Compare activity between present and past time frames
* View records for single routes and cumulative hiking
* Progress toward 6 alternate app icons unlocked at certain activity milestones

### Device Screenshots of the Statistics Tab
Hiking Statistics Comparison View | Hiking Statistics Records | Hiking Activity Awards | Hiking Statistics Distance Chart 
------------------------------- | ------------------------------------ | ---------------------------- | ---------------------------------
 ![img](https://lh7-us.googleusercontent.com/OjMx2ogstrnsDV72vtXVHFumzKtobh4dabTj7snTsevue9WOroEk9saE172VcrG72X1KDHwvnmQGIVyKV3WAa5NcsCBlZxAvC9GoBnOrHakx7NjKbbXPVIbeVp7Vnq7WlNfUG1c-TbgJ68Cp3yr0qQnrbA=s2048) | ![img](https://lh7-us.googleusercontent.com/3xFmxDZTsg7eF_YXBmoMsUUMaZDy6HemfgWIlTP0Qj5sLObuyWw8RJ0tathuTs41k93oTAJalobFbsGXsiAh_HoYsOsxE2W3YMxl07N4vJuEGcgoWUsYYX1KyoqqS581mCmOSlXJNsIypiamNlKevfC3cA=s2048) | ![img](https://lh7-us.googleusercontent.com/VRqV8q4XDYO9aonKqwaJBA8i18DC_Yz0y_rHomMP4pbl6lh8o7fNJVdjgTT7wGWUVXYKAWlC7zfHOp2djFsx25_nGDSOi8Pw8dnT_eq5CtzeFTQx1sqj-nfH-B1iP-er-BNNyD_qeM0lAmGSrL6N-VWuAg=s2048) | ![img](https://lh7-us.googleusercontent.com/fNW_uzk7QS0mvVH1YYKky2CrRD4QLu8JX2S7C7-ApwQh8KNjigpesQVnS8IA2CtcFlK-49ddMhoRa4k_RfG7QKZmXj869WQPV4vXj5SzfvoRWA10tkSOdg8vNzOjG5bJXy5-v0F0FtG2ngpC9nobtClt3A=s2048) 

### Settings Feautures Throughout the App
* Customize the app theme and app icon to fit your preferences
* Set your preferred units and customize the metrics view on the Cycle tab
* iCloud synchronization can be turned on or off
* Option to reset all settings back to the defaults and delete all stored hiking routes
* Selected sort order in the History tab will persist through future usage

### Device Screenshots of Settings Features
General Settings View | iCloud Or Support About App 
:------------------------------ | :----------------------------------- 
 <img src="https://lh7-us.googleusercontent.com/G6R5KlCxXLWfxbz0kz7bqDftmpFG2fNL4GlYWCvqvRQ0Gf5UT3uF8GZHbu-qHQ19BKwbc16Wl-LLXsmDfnDhIVh65IBs5CmE28goQnJTzar1QQn_F8D-NdXVKS3iMZsAF--JvwrSTxeNPIKR6Yg30llpoA=s2048" alt="img" style="zoom: 33%;" /> | <img src="https://lh7-us.googleusercontent.com/597y0kXIE0MQvj4abM85XeNoVG2B7Y8JdaUu6O9bGOVb3I42TqxxkyLVAx2UV9mLCeQ9QbxleKqH1-UlmAt4l1sXWWiFaZV7fkbPDX_TVTXbVS2KgQ_8WKBwJ6fvjCNDNf-GlTz2Hez2LHamaa9AZ5M6Mg=s2048" alt="img" style="zoom: 33%;" /> 

## Future Development

This app has been an immense amount of fun to develop and I have greatly enjoyed using SwiftUI! I am planning on continuing to add features as time permits and some ideas that are on my roadmap are listed below:
* Calorie tracking within the app as an optional metric
* Route generator feature where a user could enter the distance they want to ride and the app could suggest a route for them

Thank you very much for viewing this project!
