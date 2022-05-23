# Seat Marvel Characters

## Configuration
Cocoapods have been used to install simple libraries that facilitate the development of the app. One to show a loading window and another to simplify the download and temporary persistence of images from the network.
To be able to generate and compile it, please install this dependency manager by running:

`sudo gem install cocoapods`

After that, execute:

`pod install`

to generate the `.xcworkspace` and open it.

## Architecture
The project is very simple and I could have employed a more simple clean architecture like MVP. However, I've decided to use VIPER because I have experience following it, besides with MVVM and I wanted to demonstrate that I can manage more complex architectures.

### Infrastructure
It contains classes in charge of app's basic functionality like API requests, dependency injection, endpoint configuration, ...

#### Container
- `Container.swift`:
Used to initialize the `UIWindow` for different situations. Like the case that the user is logged or not in the app.
- `Container+Builders.swift`:
Dependency injection that provides the constructors that will generate the different views.
- `RepositoriesContainer.swift`:
Dependency injection that provides the repositories. In this case just one due to the simplicity of the project.

#### LocalStorage
- `LocalStorageManager.swift`:
This class implements `LocalStorageManagerContract` to be used by repositories to access to the local storage. By defining this contract, this manager can be easily changed from a `User Defaults` manager to a `Core Data` manager for example without affecting the repositories that use it.

#### Network
This folder contains a series of classes in charge of making the network requests and configuring the endpoints for different environments based on the `Configuration.plist` file.

- `HTTPRequestManager.swift`:
This class implements `HTTPRequestManagerContract` to be used by repositories to make requests to the Marvel API. By defining this contract, this manager can be easily changed to different libraries like `AFNetworking` without affecting the repositories.

#### Utils
A collection of extensions and a `Utils.swift` file to bring together different useful generic functions.

### Repositories
This is where the functionality in charge of data processing is gathered. It has a `CharacterRepository` class that handles network requesting and parsing Marvel characters data using the `JSONDecoder` system library.

In the _Models_ folder are the classes for data management at the domain level. Information from the server is parsed into `Entity` objects of type `Codable` and declared in the _Entity_ folder. Subsequently, this data is converted to models that are used for the distribution of information throughout the app.

Using structures instead of classes to store the data prevents a data mutability problem.

Annotation: due to the image urls are returned without security during the conversion of the parsed data to structures to be distributed by the app, they have been changed to include the security request and avoid adding an exception in the `Info.plist` file.

### Presentation
In this folder the classes in charge of the different use cases of the views are gathered.

#### Modules
Since there are 2 views in the app there are 2 folders:

- `CharactersList`:
To show the list of characters.
- `CharacterDetail:`
To show the detail of a character and mark it as favorite.

The modules generate views using the VIPER architecture as it was previously indicated.

[https://medium.com/build-and-run/clean-architecture-en-ios-viper-893c8c3a75a4](https://medium.com/build-and-run/clean-architecture-en-ios-viper-893c8c3a75a4)

Defining protocols in `Contract` classes makes it easy to write tests for any layer further. The data that is provided to the view layer does not have to follow the structure used to transport it throughout the app. Instead, there are `ViewModelBuilder` classes that are in charge of generating a suitable data structure for its presentation by the view.

The view layer should be as _simple_ as possible. So that it has no knowledge of the business logic and is limited to communicating to the presenter layer the actions performed by the user. Therefore, it should not indicate to the latter the actions to be carried out, since it is not part of its competencies.

The interactor layer is responsible for supplying the data to the presenter layer. Finally, the router layer is responsible for browsing the app following the commands of the presenter layer.

#### Common
Reusable visual components are gathered in this folder, such as a cell to load more data in the list. In addition, base classes are included to inherit functionalities from them.

#### Resources
Folder with basic files such as the image repository or the localized chain file.

## Tests
Tests have been added for `CharactersListPresenter.swift` and `CharactersRepository.swift` files. All this tests are gathered in the `MarvelCharactersTests` folder.

_Mocked_ versions of the view, router, interactor, LocalStoreManager, etc. are created by adopting the protocols defined in the contracts to test the correct behavior of the presenter layer.