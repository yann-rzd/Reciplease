<h1 align="center">
  <br>
  <img src="https://i.imgur.com/HBWCNPq.png" alt="Reciplease" width="200"></a>
  <br>
</h1>

# Reciplease
🍽 Find and save a recipe with reciplease app

<img src="https://i.imgur.com/sSPDGEt.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/8o6FDAX.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/PtLPyvO.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/7r1ZoJd.png" width="200" height="450"> 

## 🍕 About
Reciplease is the app thats will help you cook nice plats in your everyday life. It will let you enter your ingredients left in your fridge and search for recipes. Recipes that you can save in your app favorite page and have access offline.

## 💻 Requirements
Reciplease is written in Swift 5 and supports iOS 13.0+. Built with Xcode 13.

## 🍀 Architecture
This application is developed according to the [MVC](https://medium.com/@joespinelli_6190/mvc-model-view-controller-ef878e2fd6f5) architecture.

## 🛠 Dependencies
To save recipe for offline use [CoreData](https://developer.apple.com/documentation/coredata) and [Alamofire](https://github.com/Alamofire/Alamofire) for an elegant HTTP Networking in Swift.
I use [CocoaPods](https://cocoapods.org) as dependency manager.

## 🕵️ How to test 
### Clone the project

Run `git@github.com:github.com/yann-rzd/Reciplease.git`

### Install dependencies

Run `pod install`

### Workspace

Open `Reciplease.xcworkspace`

### Add your [Edamam](https://www.edamam.com/) API key

Create a file `APIKeys.swift`

Add this code `struct APIKeys {
    static let recipeKey = "yourAPIKey"
}` and replace yourAPIKey with your key. 

Build & Run 🔥
