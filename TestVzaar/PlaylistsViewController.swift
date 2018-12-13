//
//  PlaylistsViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class PlaylistsViewController: UIViewController , UITableViewDataSource, PlaylistTableViewCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var loadingView: LoadingView!
    var playlists: [VzaarPlaylist] = [VzaarPlaylist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Playlists"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: "playlistCell")
        
        let addPlaylistbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addPlaylistAction))
        let refreshPlaylissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refreshPlaylistsAction))
        self.navigationItem.rightBarButtonItems = [addPlaylistbutton, refreshPlaylissButton]
        
        getPlaylists()
    }
    
    func addPlaylistAction(){
        self.performSegue(withIdentifier: "addPlaylistSegue", sender: nil)
    }
    
    func refreshPlaylistsAction(){
        getPlaylists()
    }
    
    func getPlaylists(){
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let playlistParameters = VzaarGetPlaylistsParameters()

        Vzaar.sharedInstance().getPlaylists(vzaarGetPlaylistsParameters: playlistParameters, success: { (vzaarPlaylists) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil {
                    self.loadingView.removeFromSuperview()
                    self.playlists = vzaarPlaylists
                    self.tableView.reloadData()
                }
            }
            
        }, failure: { (vzaarError) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let vzaarError = vzaarError{
                if let errors = vzaarError.errors{
                    print(errors)
                }
            }
        }) { (error) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let error = error{
                print(error)
            }
        }
    }
    
    internal func deletePlaylist(playlistId: Int) {
        
        let vzaarDeleteParameters = VzaarDeletePlaylistParameters(id: NSNumber(value: playlistId))
        
        Vzaar.sharedInstance().deletePlaylist(vzaarDeletePlaylistParameters: vzaarDeleteParameters, success: { 
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                for i in 0..<self.playlists.count{
                    if self.playlists[i].id == playlistId{
                        self.playlists.remove(at: i)
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: UITableViewRowAnimation.middle)
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
    
    internal func updatePlaylist(playlistId: Int, currentTitleText: String) {
        
        let alertController = UIAlertController(title: "Update Playlist", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.textAlignment = NSTextAlignment.center
            textField.text = currentTitleText
            textField.placeholder = "Name"
        }
        alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (_) in
            
            let updatePlaylistParameters = VzaarUpdatePlaylistParameters(id: NSNumber(value: playlistId))
            if let text = alertController.textFields?.first?.text{
                updatePlaylistParameters.title = text
            }
            
            Vzaar.sharedInstance().updatePlaylist(vzaarUpdatePlaylistParameters: updatePlaylistParameters, success: { (vzaarPlaylist) in
                
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                    for i in 0..<self.playlists.count{
                        if self.playlists[i].id == playlistId{
                            self.playlists[i] = vzaarPlaylist
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
                    }
                }
            }, noResponse: { (error) in
                DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                if let error = error{
                    print(error)
                }
            })
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        
        cell.delegate = self
        cell.playlistId = playlists[indexPath.row].id
        cell.playlistLabel.text = playlists[indexPath.row].title
        cell.setDeleteButton()
        cell.setUpdateButton()
        
        return cell
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
