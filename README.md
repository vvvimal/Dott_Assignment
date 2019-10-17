# Dott_Assigment
Restaurant Near Me(Foursquare API)

## Application is built using MVVM architecture.

1. RestaurantResponseModel(Model) - consists the properties related to restaurant from Foursquare API.
2. RestaurantMapViewController(View) - consists the actions and loading of Restaurant annotation on the map view.
4. RestaurantDetailViewController(View) - consists loading of Restaurant Detail text.
5. RestaurantMapViewModel(ViewModel) - consists of the business logic where the network call is made for fetching and showing the pins on the map .
6. RestaurantDetailViewModel(ViewModel) - consists of the processing of restuarant detail to be shown.
7. RestaurantMapAnnotation & RestaurantMapAnnotationView - consists of the annotation point and view represented on the map view.


## Network Layer is seperate with generic methods for reading the files using URLSession. It consists of 

1. NetworkManager - Consisting of the genric protocol based methods for fetching and decoding JSONs.
2. Reachability - To check the connectivity to internet.
3. RestaurantListGetRequest/RestaurantListGetManager - Creation and triggering of the URL request for fetching the restaurants near the user loacation.
    Parameters used intent=browse, query=restaurant, se and nw parameters of the map visible area 
4. ImageDownloadRequest/ImageDownloadManager - Setting and triggering of the URL request for downloading the image from the url.
5. CacheManager - Singleton class with methods to set limits to the cache, set object, get object to the URL


## Utils classes are also present which give generic functionality which can be used throughout the applications

1. Extensions - Extensions written for classes(i.e UIViewController) for adding alerts, activity indicator.
2. AppConstants - Application constants used throughout the app. Strings, Enums, Errors etc


## Unit and UI XCTestCases with coverage of 86.7%(screenshot added).

1. CacheManagerTests - Testing the CacheManager methods.
2. NetworkTest - Testing the NetworkManager methods
3. ResturantTests - Testing the Restuarant on map with and without data.
4. RestaurantDetailTests - Testing the restaurant detail with and without data.
5. RestaurantUITests - Testing the Pull to refresh and UIApplication background and foreground.

Note: The code is compiled in Xcode 10.3 with support for iOS SDK 11.0 and above. 
