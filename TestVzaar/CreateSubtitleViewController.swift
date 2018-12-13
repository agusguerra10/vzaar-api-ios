//
//  CreateSubtitleViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 04/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class CreateSubtitleViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var videoId: NSNumber!
    var loadingView: LoadingView!
    var subtitle: VzaarSubtitle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI(){
        
        if subtitle == nil{
            self.navigationItem.title = "Create Subtitle"
        }else{
            self.navigationItem.title = "Update Subtitle"
        }
        
        
        contentTextView.layer.borderWidth = 1
        
        codeTextField.delegate = self
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        if let subtitle = subtitle{
            codeTextField.text = subtitle.code ?? ""
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.plain, target: self, action: #selector(updateSubtitleAction))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(createSubtitleAction))
        }
        
        
    }
    
    @objc func updateSubtitleAction(){
        
        let bundlePath = Bundle.main.path(forResource: "file", ofType: ".srt")!
        
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fullPath = URL(fileURLWithPath: destPath).appendingPathComponent("file.srt")
        let fullPathString = fullPath.path
        
        do{
            try FileManager.default.copyItem(atPath: bundlePath, toPath: fullPathString)
        }catch{
            print(error)
        }
        
        guard let subtitle = subtitle else{ return }
        
        codeTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let params = VzaarUpdateSubtitleParameters(id: videoId, subtitle: NSNumber(value: subtitle.id!))
        params.code = codeTextField.text!
        if let text = titleTextField.text, text != ""{
            params.title = text
        }
        if let text = contentTextView.text, text != ""{
            params.content = text
        }else{
            params.file = fullPathString
        }
        
        Vzaar.sharedInstance().updateSubtitle(vzaarUpdateSubtitleParameters: params, success: { (vzaarSubtitle) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                
                self.navigationController?.popViewController(animated: true)
                
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
    
    @objc func createSubtitleAction(){
        
        let bundlePath = Bundle.main.path(forResource: "file", ofType: ".srt")!
        
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fullPath = URL(fileURLWithPath: destPath).appendingPathComponent("file.srt")
        let fullPathString = fullPath.path
        
        do{
            try FileManager.default.copyItem(atPath: bundlePath, toPath: fullPathString)
        }catch{
            print(error)
        }
        
        
        
        
        
        codeTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let params = VzaarPostSubtitlesParameters(id: videoId)
        params.code = codeTextField.text!
        if let text = titleTextField.text, text != ""{
            params.title = text
        }
        if let text = contentTextView.text, text != ""{
            params.content = text
        }else{
            params.file = fullPathString
        }
        
        
        Vzaar.sharedInstance().createSubtitle(vzaarPostSubtitlesParameters: params, success: { (vzaarSubtitle) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                
                self.navigationController?.popViewController(animated: true)
                
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

extension CreateSubtitleViewController: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
