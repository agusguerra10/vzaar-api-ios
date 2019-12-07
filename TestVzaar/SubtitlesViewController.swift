//
//  SubtitlesViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 03/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class SubtitlesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var loadingView: LoadingView!
    var videoId: Int32!
    
    var subtitles:[VzaarSubtitle] = [VzaarSubtitle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        getSubtitles()
    }
    
    func configureUI(){
        
        self.navigationItem.title = "Subtitles"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let createSubtitleButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createSubtitleAction))
        let refreshVideosButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(refreshVideosAction))
        self.navigationItem.rightBarButtonItems = [createSubtitleButton, refreshVideosButton]
    }
    
    @objc func refreshVideosAction(){
        getSubtitles()
    }
    
    func getSubtitles(){
        
        
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let params = VzaarGetSubtitlesParameters(id: videoId)
        
        Vzaar.sharedInstance().getSubtitles(vzaarGetSubtitlesParameters: params, success: { (vzaarSubtitles) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                
                self.subtitles = vzaarSubtitles
                self.tableView.reloadData()
                
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
    }
    
    @objc func createSubtitleAction(){
        
        self.performSegue(withIdentifier: "createSubtitleSegue", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? CreateSubtitleViewController{
            destination.videoId = videoId
            if let indexPathRow = sender as? Int{
                destination.subtitle = subtitles[indexPathRow]
            }
        }
    }
 

}

extension SubtitlesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = subtitles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
            
            let params = VzaarDeleteSubtitlesParameters(id: self.videoId, subtitle: Int32(self.subtitles[indexPath.row].id!))
            
            Vzaar.sharedInstance().deleteSubtitle(vzaarDeleteSubtitlesParameters: params, success: {
                DispatchQueue.main.async {
                    self.getSubtitles()
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
        alertController.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: { (_) in
            
            self.performSegue(withIdentifier: "createSubtitleSegue", sender: indexPath.row)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
