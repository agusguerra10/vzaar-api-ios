# README #

Video Hosting For Business. 

* Vzaar is an online video platform
* It allows your customers to upload their own videos via the vzaar API.
* Pull information from vzaar databases and combine them with your app's own data. 
* For instance sync your product catalogue with your videos so that videos always appear on the right product page.
* Version 1.0.1

## Documentation ##

[https://vzaar.readme.io/v2/reference](https://vzaar.readme.io/v2/reference)

### How do I get set up for a Swift project ###

* If your project is in Swift you can create a Podfile as the following:

```

target 'YourProject' do

pod 'VzaarSwift'

end
use_frameworks!


```

Then open a terminal window , change directory to your project and 'pod install'

* Then in your tableViewController.swift


```
#!swift

import VzaarSwift

```

* Don't forget to set your client_id and your auth_token

```
#!swift

Vzaar.sharedInstance().config = VzaarConfig(clientId: "<client-id>", authToken: "<auth-token>") 

```

## VIDEOS ##
### Get Videos ###

```
#!swift

let vzaarGetVideosParameters = VzaarGetVideosParameters()
vzaarGetVideosParameters.page = 1
vzaarGetVideosParameters.per_page = 50

Vzaar.sharedInstance().getVideos(vzaarGetVideosParameters: vzaarGetVideosParameters, success: { (vzaarVideos) in

self.videos = vzaarVideos
self.tableView.reloadData()

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}

```
### Get Video ###
```
#!swift
let getVideoParameters = VzaarGetVideoParameters(id: videoId)

Vzaar.sharedInstance().getVideo(vzaarGetVideoParameters: getVideoParameters, success: { (vzaarVideo) in

//Handle video from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Update Video ###
```
#!swift
let updateVideoParameters = VzaarUpdateVideoParameters(id: Int32(videoId))
updateVideoParameters.title = "Text to update"

Vzaar.sharedInstance().updateVideo(vzaarUpdateVideoParameters: updateVideoParameters, success: { (video) in

//Handle the video from the response            

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Delete Video ###
```
#!swift
let deleteVideoParameters = VzaarDeleteVideoParameters(id: Int32(videoId))

Vzaar.sharedInstance().deleteVideo(vzaarDeleteVideoParameters: deleteVideoParameters, success: { 

//Handle the deleting of the video here

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Create Video ###
```
#!swift
let createVideoParameters = VzaarCreateVideoParameters(guid: signature.guid)

Vzaar.sharedInstance().createVideo(videoCreationParameters: createVideoParameters, success: { (vzaarVideo) in

//Handle the video from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Upload a video ###
Uploading a video consists of one call that does the following:
1. Creates a signature (single or multi part).
2. Uploads the video using the aws services.
3. Gets the video from Vzaar

An example of a request to upload a video as a single part is the following:

```
#!swift
#!swift
let singlePartVideoSignatureParameters = VzaarSinglePartVideoSignatureParameters()
singlePartVideoSignatureParameters.filename = name

let directory = NSTemporaryDirectory()
let lastPathComponent = (fileURLWithPath.absoluteString as NSString).lastPathComponent
let fullPath = directory + lastPathComponent
let fileURLPath = URL(fileURLWithPath: fullPath)

Vzaar.sharedInstance().uploadVideo(uploadProgressDelegate: self,
singlePartVideoSignatureParameters: singlePartVideoSignatureParameters,
fileURLPath: fileURLPath,
success: { (video) in

//Handle the video from the response.    

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```

An example of a request to upload a video as multi parts is the following:
```
#!swift
let multiPartVideoSignatureParameters = VzaarMultiPartVideoSignatureParameters(filename: "Filename.mp4", filesize: 52428800)

let directory = NSTemporaryDirectory()
let lastPathComponent = (fileURLWithPath.absoluteString as NSString).lastPathComponent
let fullPath = directory + lastPathComponent
let fileURLPath = URL(fileURLWithPath: fullPath)

Vzaar.sharedInstance().uploadVideo(uploadProgressDelegate: self, multiPartVideoSignatureParameters: multiPartVideoSignatureParameters, fileURLPath: fileURLPath, success: { (vzaarVideo) in

//Handle video from the response

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
## CATEGORIES ##
### Get Categories ###
```
#!swift
let categoriesParameters = VzaarGetCategoriesParameters()

Vzaar.sharedInstance().getCategories(vzaarGetCategoriesParameters: categoriesParameters, success: { (vzaarCategories) in

//Handle categories from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Get Category ###
```
#!swift
let categoryParameters = VzaarGetCategoryParameters(id: Int32(categoryId))

Vzaar.sharedInstance().getCategory(vzaarGetCategoryParameters: categoryParameters, success: { (vzaarCategory) in

//Handle category from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Create Category ###
```
#!swift
let categoryParameters = VzaarCreateCategoryParameters(name: name)

Vzaar.sharedInstance().createCategory(vzaarCreateCategoryParameters: categoryParameters, success: { (category) in

//Handle category from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Update Category ###
```
#!swift
let updateCategoryParameters = VzaarUpdateCategoryParameters(id: Int32(categoryId))
updateCategoryParameters.name = "Text to update the name"

Vzaar.sharedInstance().updateCategory(vzaarUpdateCategoryParameters: updateCategoryParameters, success: { (category) in

//Handle category from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Delete Category ###
```
#!swift
let deleteCategoryParameters = VzaarDeleteCategoryParameters(id: Int32(categoryId))

Vzaar.sharedInstance().deleteCategory(vzaarDeleteCategoryParameters: deleteCategoryParameters, success: { 

//Handle the deleting of the category.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
## SIGNATURES ##
### Create Single part signature ###
```
#!swift
let singlePartVideoSignatureParameters = VzaarSinglePartVideoSignatureParameters()
singlePartVideoSignatureParameters.filename = name

Vzaar.sharedInstance().createSignature(singlePartVideoSignatureParameters: singlePartVideoSignatureParameters, success: { (vzaarSignature) in

//Handle signature from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Create Multi part signature ###
```
#!swift
let multiPartVideoSignatureParameters = VzaarMultiPartVideoSignatureParameters(filename: "filename.mp4", filesize: Int64(52428800))
multiPartVideoSignatureParameters.filename = name

Vzaar.sharedInstance().createSignature(multiPartVideoSignatureParameters: multiPartVideoSignatureParameters, success: { (vzaarSignature) in

//Handle signature from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
## LINK UPLOAD ##
### Create Link Upload ###
```
#!swift
let createLinkUploadParameters = VzaarCreateLinkUploadParameters(url: "the url")

Vzaar.sharedInstance().getLinkUpload(vzaarCreateLinkUploadParameters: createLinkUploadParameters, success: { (vzaarVideo) in

//Handle video from the response

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
## INGEST RECIPES ##
### Get Ingest Recipes ###
```
#!swift
let ingestRecipesParameters = VzaarGetIngestRecipesParameters()

Vzaar.sharedInstance().getIngestRecipes(vzaarGetIngestRecipesParameters: ingestRecipesParameters, success: { (vzaarIngestRecipes) in

//Handle recipes from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Create Ingest Recipe ###
```
#!swift
//ids is an array of int32
let createIngestRecipeParameters = VzaarCreateIngestRecipeParameters(name: name, encoding_preset_ids: ids)

Vzaar.sharedInstance().createIngestRecipe(vzaarCreateIngestRecipeParameters: createIngestRecipeParameters, success: { (ingestRecipe) in

//Handle recipe from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Get Ingest Recipe ###
```
#!swift
let ingestRecipeParameters = VzaarGetIngestRecipeParameters(id: Int32(recipeId))

Vzaar.sharedInstance().getIngestRecipe(vzaarGetIngestRecipeParameters: ingestRecipeParameters, success: { (vzaarIngestRecipe) in

//Handle recipes from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Update Ingest Recipes ###
```
#!swift
let updateIngestRecipeParameters = VzaarUpdateIngestRecipeParameters(id: Int32(ingestRecipeId))
updateIngestRecipeParameters.name = "text to update for the ingest recipe"

Vzaar.sharedInstance().updateIngestRecipe(vzaarUpdateIngestRecipeParameters: updateIngestRecipeParameters, success: { (ingestRecipe) in

//Handle recipe from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Delete Ingest Recipe ###
```
#!swift
let deleteIngestRecipeParameters = VzaarDeleteIngestRecipeParameters(id: Int32(ingestRecipeId))

Vzaar.sharedInstance().deleteIngestRecipe(vzaarDeleteIngestRecipeParameters: deleteIngestRecipeParameters, success: { 

//Handle recipe deleting here.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
## ENCODING PRESETS ##
### Get Encoding Presets ###
```
#!swift
let encodingPresetsParameters = VzaarGetEncodingPresetsParameters()

Vzaar.sharedInstance().getEncodingPresets(vzaarGetEncodingPresetsParameters: encodingPresetsParameters, success: { (vzaarEncodingPresets) in

//Handle encoding Presets from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Get Encoding Preset ###
```
#!swift
let encodingPresetParameters = VzaarGetEncodingPresetParameters(id: Int32(encodingPresetId))

Vzaar.sharedInstance().getEncodingPresets(vzaarGetEncodingPresetsParameters: encodingPresetParameters, success: { (vzaarEncodingPreset) in

//Handle encoding Preset from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
## PLAYLISTS ##
### Get Playlists  ###
```
#!swift
let playlistParameters = VzaarGetPlaylistsParameters()

Vzaar.sharedInstance().getPlaylists(vzaarGetPlaylistsParameters: playlistParameters, success: { (vzaarPlaylists) in

//Handle playlists from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Create Playlist  ###
```
#!swift
let createPlaylistParameters = VzaarCreatePlaylistParameters(title: "title of the playst", category_id: Int32(category_id))
createPlaylistParameters.max_vids = 0

Vzaar.sharedInstance().createPlaylist(vzaarCreatePlaylistParameters: createPlaylistParameters, success: { (vzaarPlaylist) in

//Handle playlist from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Get Playlist  ###
```
#!swift
let playlistParameters = VzaarGetPlaylistParameters(id: Int32(playlistId))

Vzaar.sharedInstance().getPlaylist(vzaarGetPlaylistParameters: playlistParameters, success: { (vzaarPlaylist) in

//Handle playlist from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Update Playlist ###
```
#!swift
let updatePlaylistParameters = VzaarUpdatePlaylistParameters(id: Int32(playlistId))
updatePlaylistParameters.title = "text to update playlist"

Vzaar.sharedInstance().updatePlaylist(vzaarUpdatePlaylistParameters: updatePlaylistParameters, success: { (vzaarPlaylist) in

//Handle playlist from the response.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### Delete Playlist  ###
```
#!swift
let vzaarDeleteParameters = VzaarDeletePlaylistParameters(id: Int32(playlistId))

Vzaar.sharedInstance().deletePlaylist(vzaarDeletePlaylistParameters: vzaarDeleteParameters, success: { 

//Handle deleting the playlist here.

}, failure: { (vzaarError) in
print(vzaarError)
}) { (error) in
print(error)
}
```
### How do I get set up for an Objective-c project ###

* If your project is in objective-c you have to use the specific version of the pod '1.0.1-objc' to access the classes and properties through the bridge headers.

```
#!objective-c
target 'YourProject' do

pod 'VzaarSwift', '~> 1.0.1-objc'

end
use_frameworks!
```

* Then in your TableViewController.m

```
#!objective-c
@import VzaarSwift;
```

* Don't forget to set your client_id and your auth_token

```
#!objective-c
[Vzaar sharedInstance].config = [[VzaarConfig alloc]initWithClientId:@"client-id" authToken:@"auth-token"];
```
* An example of a request in objective-c to get videos would be:

```
#!objective-c
VzaarGetVideosParameters *getVideosParameters = [[VzaarGetVideosParameters alloc] init];

[[Vzaar sharedInstance] getVideosWithVzaarGetVideosParameters:getVideosParameters success:^(NSArray<VzaarVideo *> * vzaarVideos) {

self.videos = vzaarVideos;
[self.tableView reloadData];

} failure:^(VzaarError * vzaarError) {
NSLog(@"%@",vzaarError);
} noResponse:^(NSError * error) {
NSLog(@"%@",error);
}];
```
