//
//  PosterViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 03/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class PosterViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var updateImageFrameButton: UIButton!
    @IBOutlet weak var addTimeImageFrameButton: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    var loadingView: LoadingView!
    var video: VzaarVideo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI(){
        
        self.navigationItem.title = "Image Frame"
        
        updateImageFrameButton.addTarget(self, action: #selector(updateImageAction), for: UIControl.Event.touchUpInside)
        addTimeImageFrameButton.addTarget(self, action: #selector(addTimeImageAction), for: UIControl.Event.touchUpInside)
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageGesture)
        
        imagePickerController.delegate = self
        
    }
    
    @objc func imageTapped(){
        print("image Tapped")
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func updateImageAction(sender: UIButton){
        
        if let image = imageView.image{
            
            let params = VzaarUploadImageFrameParameters(id: Int32(self.video.id!), image: image)
            
            self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            let window: UIWindow = (UIApplication.shared.delegate?.window!)!
            window.addSubview(self.loadingView)
            
            Vzaar.sharedInstance().uploadImageFrame(vzaarUploadImageFrameParameters: params, success: { (vzaarVideo) in
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
//                    print(vzaarVideo.asset_url)
//                    print(vzaarVideo.poster_url)
                    self.navigationController?.popViewController(animated: true)
                }
            }, failure: { (vzaarError) in
                DispatchQueue.main.async {
                    if self.loadingView != nil {
                        self.loadingView.removeFromSuperview()
                    }
                    
                    if let vzaarError = vzaarError {
                        if let errors = vzaarError.errors {
                            print(errors)
                            VZError.alert(viewController: self, errors: errors)
                        }
                    }
                }
            }) { (error) in
                DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                if let error = error{
                    print(error)
                }
            }
            
        }else{
            let alert = UIAlertController(title: "No Image", message: "You need to set image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func addTimeImageAction(sender: UIButton){
        
        let alertController = UIAlertController(title: "Set Poster Frame", message: "Input time in seconds", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.textAlignment = NSTextAlignment.center
            textField.keyboardType = .decimalPad
            textField.placeholder = "Time"
        }
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
            
            guard let textField = alertController.textFields?.first else { return }
            guard let time = Float(textField.text!) else { return }
            
            let params = VzaarUpdateImageFrameParameters(id: Int32(self.video.id!))
            params.time = time
            
            self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            let window: UIWindow = (UIApplication.shared.delegate?.window!)!
            window.addSubview(self.loadingView)
            
            Vzaar.sharedInstance().updateImageFrame(vzaarUpdateImageFrameParameters: params, success: { (vzaarVideo) in
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
//                    print(vzaarVideo.poster_url)
                    self.navigationController?.popViewController(animated: true)
                }
            }, failure: { (vzaarError) in
                DispatchQueue.main.async {
                    if self.loadingView != nil {
                        self.loadingView.removeFromSuperview()
                    }
                        
                    if let vzaarError = vzaarError {
                        if let errors = vzaarError.errors {
                            print(errors)
                            VZError.alert(viewController: self, errors: errors)
                        }
                    }
                }
            }) { (error) in
                DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                if let error = error{
                    print(error)
                }
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            self.imageView.image = image
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
