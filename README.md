# Stories
# Usage

* Carthage: add < link > to your Cartfile and run ```carthage bootstrap --platform ios```
* ```import Stories``` when needed

# StoriesCollectionView
A custom collection view.

# StoriesViewController
This is the VC for the stories themselves.

# StoriesCollectionViewDelegate
This delegate handles cell selection in the ```StoriesCollectionView```. This is where you will present ```StoriesViewController```, injecting its content data.

# Data Types

* StoriesCollectionData:

```imageUrl: String``` contains the url of the user image (typically) that will appear in the collectionView.

```label: String``` username that will appear at the bottom of the user image.

* StoriesData:

```stories: [String]``` an array of images urls

```usernameLabel: [String]``` username that will appear on the side of the user image

```userImageUrl: [String]``` user image url (typically, the same as in ```StoriesCollectionData```)

* CircularScaleTransition: 

A custom transition animation for cell selection in ```StoriesCollectionView```.
Look at the example project for more information about its configuration.
