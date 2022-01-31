# ModernFertilityCodingChallenge
Creating an amazing application that folks love to use.

## Machine Setup 💻 
* Ensure the latest and greatest Xcode has been installed.
* Ensure Cocoapods has been installed and setup.
  * Cocoapods can be installed and setup on your machine using the [following instructions](https://guides.cocoapods.org/using/getting-started.html).

## Project Setup 🔧 
After cloning the project (or subsequently downloading the ZIP file) some minor setup will be needed for dependency management.
  
Navigate to the project's main directory (which contains the `Podfile`) within Terminal and run the following command:
* `pod install`

Once all of the pods have been installed successfully be sure to quit Xcode and open the `ModernFertility.xcworkspace` Workspace file.

Now that everything has been setup you can clean and build the project along with running the project on a Simulator and/or physical iOS device.

**NOTE**: you might need to go to the `ModernFertility` target and then to `Signing & Capabilities` and update the `Team` to something such as `(Personal Team)` so that the project and build.

## Unit Tests
Unit Tests can be run several ways, however, to quickly get tests building and running open the Test Navigator within Xcode and click the small run button next to the `ModernFetilityTests` title to run all Unit Tests.

**NOTE**: due to time constraints there is only one Unit Test 😅
