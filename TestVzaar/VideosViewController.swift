//
//  ViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 27/02/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar
import MobileCoreServices

class VideosViewController: UIViewController , VzaarUploadProgressDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, VideoTableViewCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    var videosReady: [VzaarVideo] = [VzaarVideo]()
    var videosProcessing: [VzaarVideo] = [VzaarVideo]()
    
    var videosStatesFinishedLoading = 0
    var loadingView: LoadingView!
    
    func vzaarUploadProgress(progress: Double) {
        let percentageString = String(Int(progress*100))
        loadingView.percentageLabel.text = "\(percentageString)%"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Videos"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        
        let selectVideobutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(selectVideoToUploadAction))
        let refreshVideosButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refreshVideosAction))
        self.navigationItem.rightBarButtonItems = [selectVideobutton, refreshVideosButton]
        
        Vzaar.sharedInstance().config = VzaarConfig(clientId: "YOUR_CLIENT_ID", authToken: "YOUR_AUTH_TOKEN")
        getVideos()
        
    }
    
    func getVideos(){
        
        
        let categorySubtreeParameter = VzaarGetCategoriesSubtreeParameters(id: Int32(categoryId))
        
        Vzaar.sharedInstance().getCategoriesSubtree(vzaarGetCategoriesSubtreeParameters: categorySubtreeParameter, success: { (vzaarCategories) in
            
            //Handle categories from the response
            
        }, failure: { (vzaarError) in
            print(vzaarError)
        }) { (error) in
            print(error)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        getVideos(state: VzaarGetVideosParametersState.processing)
        getVideos(state: VzaarGetVideosParametersState.ready)
    }
    
    func actionCancelUploadTask(){
        Vzaar.sharedInstance().cancelUploadTask()
        if loadingView != nil{ loadingView.removeFromSuperview() }
    }
    
    func getVideos(state: VzaarGetVideosParametersState){
        
        let vzaarGetVideosParameters = VzaarGetVideosParameters()
        vzaarGetVideosParameters.state = state
        vzaarGetVideosParameters.page = 1
        vzaarGetVideosParameters.per_page = 50
        
        Vzaar.sharedInstance().getVideos(vzaarGetVideosParameters: vzaarGetVideosParameters, success: { (vzaarVideos) in
            
            if state == VzaarGetVideosParametersState.ready{
                self.videosReady = vzaarVideos
            }else{
                self.videosProcessing = vzaarVideos
            }
            
            self.videosStatesFinishedLoading += 1
            if self.videosStatesFinishedLoading == 2{
                self.videosStatesFinishedLoading = 0
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                    self.tableView.reloadData()
                }
            }
            
            
        }, failure: { (vzaarError) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let vzaarError = vzaarError{
                if let errors = vzaarError.errors{
                    print(errors)
                    VZError.alert(viewController: self, errors: errors)
                }
            }
        }) { (error) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let error = error{
                print(error)
            }
        }
        
    }
    
    func refreshVideosAction(sender: UIButton){
        getVideos()
    }
    
    func selectVideoToUploadAction(sender: UIButton){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoMediaURL = info[UIImagePickerControllerMediaURL] as? URL{
            print(videoMediaURL)
            picker.dismiss(animated: true, completion: { 
                self.prepareToUploadVideo(fileURLWithPath: videoMediaURL)
            })
        }
        
    }
    
    func prepareToUploadVideo(fileURLWithPath: URL){
        
        let alert = UIAlertController(title: "Set a name for the video", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.delegate = self
            textField.textAlignment = NSTextAlignment.center
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.placeholder = "Name"
        })
        alert.addAction(UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { (_) in
            if let text = alert.textFields?.first?.text{
                
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                self.loadingView.percentageLabel.isHidden = false
                self.loadingView.cancelButton.isHidden = false
                self.loadingView.cancelButton.addTarget(self, action: #selector(self.actionCancelUploadTask), for: UIControlEvents.touchUpInside)
                self.loadingView.percentageLabel.text = "0%"
                let window: UIWindow = (UIApplication.shared.delegate?.window!)!
                window.addSubview(self.loadingView)
                
                self.uploadVideo(name:  text,fileURLWithPath: fileURLWithPath)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func uploadVideo(name: String, fileURLWithPath: URL){
        
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
                                            
                                            DispatchQueue.main.async {
                                                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                                            }
                                            
                                            
        }, failure: { (vzaarError) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let vzaarError = vzaarError{
                if let errors = vzaarError.errors{
                    print(errors)
                    VZError.alert(viewController: self, errors: errors)
                }
            }
        }) { (error) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let error = error{
                print(error)
            }
        }
    }
    
    internal func deleteVideo(videoId: Int) {
        
        let deleteVideoParameters = VzaarDeleteVideoParameters(id: Int32(videoId))
        
        Vzaar.sharedInstance().deleteVideo(vzaarDeleteVideoParameters: deleteVideoParameters, success: { 
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                for i in 0..<self.videosReady.count{
                    if self.videosReady[i].id == videoId{
                        self.videosReady.remove(at: i)
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [IndexPath(row: i, section: 1)], with: UITableViewRowAnimation.middle)
                        self.tableView.endUpdates()
                        return
                    }
                }
            }
            
        }, failure: { (vzaarError) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let vzaarError = vzaarError{
                if let errors = vzaarError.errors{
                    print(errors)
                    VZError.alert(viewController: self, errors: errors)
                }
            }
        }) { (error) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let error = error{
                print(error)
            }
        }
    }
    
    internal func updateVideo(videoId: Int, currentTitleText: String) {
        
        let alertController = UIAlertController(title: "Update Video", message: "Title", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.textAlignment = NSTextAlignment.center
            textField.text = currentTitleText
            textField.placeholder = "Name"
        }
        alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (_) in
            
            let updateVideoParameters = VzaarUpdateVideoParameters(id: Int32(videoId))
            if let text = alertController.textFields?.first?.text{
                updateVideoParameters.title = text
            }
            
            Vzaar.sharedInstance().updateVideo(vzaarUpdateVideoParameters: updateVideoParameters, success: { (video) in
                
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                    for i in 0..<self.videosReady.count{
                        if self.videosReady[i].id == videoId{
                            self.videosReady[i] = video
                            self.tableView.reloadData()
                            return
                        }
                    }
                }
                
            }, failure: { (vzaarError) in
                DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                if let vzaarError = vzaarError{
                    if let errors = vzaarError.errors{
                        print(errors)
                        VZError.alert(viewController: self, errors: errors)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                if let error = error{
                    print(error)
                }
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
 
    // MARK - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return videosProcessing.count
        }else{
            return videosReady.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Processing"
        }else{
            return "Ready"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
        if indexPath.section == 0{
            cell.titleLabel.text = videosProcessing[indexPath.row].title
            cell.setImage(withUrl: videosProcessing[indexPath.row].thumbnail_url)
            cell.setVideoStateLabel(state: videosProcessing[indexPath.row].state)
            cell.videoId = videosProcessing[indexPath.row].id
            
        }else{
            cell.titleLabel.text = videosReady[indexPath.row].title
            cell.setImage(withUrl: videosReady[indexPath.row].thumbnail_url)
            cell.setVideoStateLabel(state: videosReady[indexPath.row].state)
            cell.videoId = videosReady[indexPath.row].id
        }
        cell.delegate = self
        cell.setDeleteButton()
        cell.setUpdateButton()
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

