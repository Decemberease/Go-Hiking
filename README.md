# GoCycling

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

Once you are finished with your cycling route, you can compelete the route by using the stop button. The route will be saved to your device and is viewable in the History tab along with metrics about the route.

More routes can be created in this same way and they can all be viewed, sorted and deleted from the History tab.

## App Features

Go Hiking has many features packed into four tabs; Cycle, History, Statistics and Settings. It also fully supports both light and dark mode, automatically setting the mode based on device settings.

Note: All screenshots shown were taken on an iPhone 12 Pro Max simulator.

### Features of the Cycle Tab
* Start, stop, pause and resume routes with the on-screen stopwatch
* View current cycling metrics, including distance cycled, speed and altitude
* Large map showing current location and path taken
* Timer showing cycling time of the ongoing route
* Assign your route to a new/existing category upon completion

### Device Screenshots of the Cycle Tab
 Cycle Tab Without Ongoing Route                              | Cycle Tab Without Ongoing Route Dark                         | Cycle Tab With Ongoing Route                  | Cycle Tab With Ongoing Route Dark             
 ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------------- | --------------------------------------------- 
 <img src="/Users/xj/Library/Application Support/typora-user-images/image-20240424001717358.png" alt="image-20240424001717358" /> | ![7264a7c2f3a80ce7785bbb68f6889a7d](/Users/xj/Downloads/7264a7c2f3a80ce7785bbb68f6889a7d.PNG) | ![WechatIMG87](D:\1178051832\WechatIMG87.png) | ![WechatIMG89](D:\1178051832\WechatIMG89.png) 

### Features of the History Tab
* View all past cycling routes in an easily readable list
* Sort all of your routes by time, distance and date (all offering ascending or descending order)
* Filter your routes by their category, rename your categories or recategorize individual routes
* Click on a single route to view a full screen view including a map of the route as well as metrics
* Each list entry is deletable by swiping to the left

### Device Screenshots of the History Tab
Cycling History List View | Single Cycling Route Detailed View | Single Cycling Route Detailed View Dark | Filter Cycling History
------------------------------- | ------------------------------------ | ---------------------------- | ---------------------------------
 |  |  |  

### Features of the Statistics Tab
* View detailed charts of cycling activity of past week, 5 weeks and 30 weeks
* Compare activity between present and past time frames
* View records for single routes and cumulative cycling
* Progress toward 6 alternate app icons unlocked at certain activity milestones

### Device Screenshots of the Statistics Tab
Cycling Statistics Comparison View | Cycling Statistics Past Week Chart | Cycling Statistics Past Week Chart With Selection | Cycling Records View Dark
------------------------------- | ------------------------------------ | ---------------------------- | ---------------------------------
<img src="D:\1178051832\4.png" alt="4"  /> | ![5](D:\1178051832\5.png) | ![3](D:\1178051832\3.png) | <img src="D:\1178051832\7.jpg" alt="7" style="zoom: 200%;" /> 

### Settings Feautures Throughout the App
* Customize the app theme and app icon to fit your preferences
* Set your preferred units and customize the metrics view on the Cycle tab
* iCloud synchronization can be turned on or off
* Option to reset all settings back to the defaults and delete all stored cycling routes
* Selected sort order in the History tab will persist through future usage

### Device Screenshots of Settings Features
General Settings View | General Settings View Dark | Changing App Icon to Default | Setting Cycling History Sort Order
------------------------------- | ------------------------------------ | ---------------------------- | ---------------------------------
 |  |  |  

## Future Development

This app has been an immense amount of fun to develop and I have greatly enjoyed using SwiftUI! I am planning on continuing to add features as time permits and some ideas that are on my roadmap are listed below:
* Calorie tracking within the app as an optional metric
* Route generator feature where a user could enter the distance they want to ride and the app could suggest a route for them

Thank you very much for viewing this project!
