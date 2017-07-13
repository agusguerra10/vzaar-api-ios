//
//  AddPlaylistViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 30/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class AddPlaylistViewController: UIViewController , UITextFieldDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var loadingView: LoadingView!
    var categories: [VzaarCategory] = [VzaarCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Playlist"
        
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        
        let createPlaylistButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(createPlaylistAction))
        self.navigationItem.rightBarButtonItem = createPlaylistButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCategories()
    }
    
    func createPlaylistAction(){
        
        if let category_id = getSelectedCategoryId(){
            
            if getPlaylistTitle() != ""{
                
                textField.resignFirstResponder()
                
                self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                let window: UIWindow = (UIApplication.shared.delegate?.window!)!
                window.addSubview(self.loadingView)
                
                let createPlaylistParameters = VzaarCreatePlaylistParameters(title: getPlaylistTitle(), category_id: Int32(category_id))
                createPlaylistParameters.max_vids = 0
                
                Vzaar.sharedInstance().createPlaylist(vzaarCreatePlaylistParameters: createPlaylistParameters, success: { (vzaarPlaylist) in
                    
                    DispatchQueue.main.async {
                        if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }, failure: { (vzaarError) in
                    DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                    if let vzaarError = vzaarError{
                        if let errors = vzaarError.errors{
                            print(errors)
                            VZError.alert(viewController: self, errors: errors)
                        }
                    }
                }, noResponse: { (error) in
                    DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
                    if let error = error{
                        print(error)
                    }
                })
                
            }else{
                VZError.alert(viewController: self, title: "Playlist Incomplete", message: "Please select a title for the playlist.")
            }
            
        }else{
            VZError.alert(viewController: self, title: "Playlist Incomplete", message: "Please select a category to the playlist to.")
        }
        
    }
    
    func getPlaylistTitle() -> String{
        guard let title = textField.text else { return "" }
        return title
    }
    
    func getSelectedCategoryId() -> Int?{
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return categories[indexPath.row].id
    }
    
    func getCategories(){
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let categoriesParameters = VzaarGetCategoriesParameters()
        
        Vzaar.sharedInstance().getCategories(vzaarGetCategoriesParameters: categoriesParameters, success: { (vzaarCategories) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil {
                    self.loadingView.removeFromSuperview()
                    self.categories = vzaarCategories
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
    
    // MARK - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryLabel.text = categories[indexPath.row].name
        if let id = categories[indexPath.row].id{
            cell.categoryIdLabel.text = "\(id)"
        }
        
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
