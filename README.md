# README #

Video Hosting For Business.

* Vzaar is an online video platform
* It allows your customers to upload their own videos via the vzaar API.
* Pull information from vzaar databases and combine them with your app's own data. 
* For instance sync your product catalogue with your videos so that videos always appear on the right product page.
* Version 1.0

### Documentation ###

[https://vzaar.readme.io/v2/reference](https://vzaar.readme.io/v2/reference)

### How do I get set up for a Swift project ###

* If your project is in Swift you can create a Podfile as the following:

```
#!swift

source 'https://bitbucket.org/biasdev/ios-sdk.git'
target 'YourProject' do
    
    pod 'VzaarSwift'

end
use_frameworks!


```

Then open a terminal window , change directory to your project and 'pod install'

* Then in your tableViewController.swift


```
#!swift

import Vzaar

```

* Don't forget to set your client_id and your auth_token

```
#!swift

Vzaar.sharedInstance().config = VzaarConfig(clientId: "<client-id>", authToken: "<auth-token>") 

```
* An example of a request to get videos is the following:

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

* An example of a request to upload a video as a single part is the following:

```
#!swift
let singlePartVideoSignatureParameters = VzaarSinglePartVideoSignatureParameters(uploader: "Swift 3.1")
singlePartVideoSignatureParameters.filename = name
        
let directory = NSTemporaryDirectory()
let lastPathComponent = (fileURLWithPath.absoluteString as NSString).lastPathComponent
let fullPath = directory + lastPathComponent
let fileURLPath = URL(fileURLWithPath: fullPath)
        
Vzaar.sharedInstance().uploadVideo(uploadProgressDelegate: self,
                                  singlePartVideoSignatureParameters: singlePartVideoSignatureParameters,
                                  fileURLPath: fileURLPath,
                                  success: { (video) in
                                            
                                  self.tableView.reloadData()
                                            
                                            
}, failure: { (vzaarError) in
     print(errors)
}) { (error) in
     print(error)
}

```

### How do I get set up for an Objective-c project ###

* If your project is in objective-c you have to use the specific version of the pod '1.0.2' to access the classes and properties through the bridge headers.

```
#!objective-c
source 'https://bitbucket.org/biasdev/ios-sdk.git'
target 'YourProject' do

    pod 'VzaarSwift', '~> 1.0.2'

end
use_frameworks!
```

* Then in your TableViewController.m

```
#!objective-c
@import Vzaar;
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
