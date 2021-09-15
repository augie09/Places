# Project
Place Demo iOS App

## User Features
* Search Google Places API for nearby venues
* Favorites places
* View search results in list or map form

## App Information
* MVVM with Combine and UIKit
* Remote and local places datasources are encapsulated in a  Repository
* Repository provides Models to the ViewModel
* Constructor based Dependency Injection used throughout
* XIB based views

## App Object Dependency
* Views
  * ViewController
    * ViewModel
      * Model - [Place]
        * Places Repository
          * LocalDatasource - FavoritePlaces
          * RemoteDataSource - GooglePlaces

## External Dependencies - Pods
* Dependency Injection
  * Swinject
  * Swinject Auto-Registration
* Local Database
  * RealmSwift
* Star Rating View
  * Cosmos
* Image Caching
  * SDWebImage
* Mocking
  * Cuckoo

## Tooling
* iOS 13+
* Swift 5
* Xcode 12.5.1+
* CocoaPod 1.10
