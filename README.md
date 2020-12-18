# ReviewsApp

ReviewsApp is an iOS project written in Swift that displays reviews of excursions.



## Features

- Display reviews of excursions.
- Option to sort reviews on the basis of rating and date.
- Ratings are marked with respective colors(green/yellow/red) depending on the sentiment.
- It provides offline support for displaying reviews so that your last fetched reviews are not lost in absence of network!!



## Source Organisation

The project files are organised as follows:

     ReviewsApp
        -ReviewListing
            -Model
            -DataManager
            -ReviewListingTVCell
        -Utility

The ReviewListing folder contains all the Sub-Folders and files required for Review Listing page .Model, DataManager and ReviewListingTVCell are the subfolders which contain relevant source code files.

The Utility Folder contain the useful helper code such as Constants, HelperExtension and APIServices.




## Architechture

I have used a custom MVVM architechture for this project. ReviewListingVC is the main controller file and ReviewListingVM is the view model file for handling the business logic of review List VC. 

To further help my viewmodel, i have created a ReviewsDataManager that takes care of fetching the data from server and saving it to CoreData. Once done with fetching and saving of Data, it notifies the viewmodel using delegate. ViewModel then uses NSFetchResultController to fetch the records in batches of 20 and notifies the VC about the success/failure of the operation. VC then loads the tableview. 
Basically ViewModel delegates the responsibility of data management to ReviewsDataManager. which prevents it from turning massive and bulky.

ReviewListingWireframe class set the dependencies for ReviewListing module before returning the ReviewListingVC instance which is then rendered on screen.

Records are fetched from server in batches of 20 using paginated server call and offset is increased on each successful render. 

APIServices manage the interaction with remote server or making API calls. An UIImageView extension created in HelperExtension takes care of fetching remote images from url and caching them for further use.




## Requirements

- Xcode 12.0 or later
- macOS 10.15.5 or later
- iOS 13.0 or later



## Dependencies

No external dependencies required to run the project.



## Getting Started

- Read this README.md doc
- Download the project and open it in Xcode. Click the run button.


## Unit Tests

ReviewsApp include a suite of unit tests within the test subdirectory. These tests can be simply run by executing the test action.
