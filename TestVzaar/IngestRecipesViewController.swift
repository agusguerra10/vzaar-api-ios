//
//  IngestRecipesViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class IngestRecipesViewController: UIViewController , UITableViewDataSource, UITextFieldDelegate, IngestRecipeTableViewCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var ingestRecipes: [VzaarIngestRecipe] = [VzaarIngestRecipe]()
    var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Ingest Recipes"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IngestRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "ingestRecipeCell")
        
        let addCategorybutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addIngestRecipeAction))
        let refreshCategoriesButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refreshIngestRecipesAction))
        self.navigationItem.rightBarButtonItems = [addCategorybutton, refreshCategoriesButton]
        
        getIngestRecipes()
    }
    
    func refreshIngestRecipesAction(){
        getIngestRecipes()
    }
    
    func addIngestRecipeAction(){
        
        let alert = UIAlertController(title: "Set a name and encoding preset id array for the Ingest Recipe", message: "Available Encoding Presets are:         Do not encode-2                             ULD-3                              LD-4                         SDLower-5             SDHigher-6             HD720p-7              HD1080p-8", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.delegate = self
            textField.textAlignment = NSTextAlignment.center
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.placeholder = "Name"
        })
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.delegate = self
            textField.textAlignment = NSTextAlignment.center
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.placeholder = "e.g.(3,4,7)"
        })
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (_) in
            if let text = alert.textFields?.first?.text, let arrayOfIds = alert.textFields?[1].text{
                
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                let window: UIWindow = (UIApplication.shared.delegate?.window!)!
                window.addSubview(self.loadingView)
                
                let idsStringArray = arrayOfIds.components(separatedBy: ",")
                let idsIntArray: [NSNumber] = idsStringArray.map({ (id) -> NSNumber in
                    if let id = Int(id){
                        return NSNumber(value: id)
                    }
                    return -1
                })
                
                self.addIngestRecipe(name: text, ids: idsIntArray)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addIngestRecipe(name: String, ids: [NSNumber]){
        
        let ingestRecipeParameters = VzaarCreateIngestRecipeParameters(name: name, encoding_preset_ids: ids)
        
        Vzaar.sharedInstance().createIngestRecipe(vzaarCreateIngestRecipeParameters: ingestRecipeParameters, success: { (ingestRecipe) in
            
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

    func getIngestRecipes(){
    
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let ingestRecipeParameters = VzaarGetIngestRecipesParameters()
        
        Vzaar.sharedInstance().getIngestRecipes(vzaarGetIngestRecipesParameters: ingestRecipeParameters, success: { (vzaarIngestRecipes) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil {
                    self.loadingView.removeFromSuperview()
                    self.ingestRecipes = vzaarIngestRecipes
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
    
    internal func deleteIngestRecipe(ingestRecipeId: Int) {
        
        let deleteIngestRecipeParameters = VzaarDeleteIngestRecipeParameters(id: NSNumber(value: ingestRecipeId))
        
        Vzaar.sharedInstance().deleteIngestRecipe(vzaarDeleteIngestRecipeParameters: deleteIngestRecipeParameters, success: { 
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                for i in 0..<self.ingestRecipes.count{
                    if self.ingestRecipes[i].id == ingestRecipeId{
                        self.ingestRecipes.remove(at: i)
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
    
    internal func updateIngestRecipe(ingestRecipeId: Int, currentIngestRecipeText: String) {
        
        let alertController = UIAlertController(title: "Update Ingest Recipe", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.textAlignment = NSTextAlignment.center
            textField.text = currentIngestRecipeText
            textField.placeholder = "Name"
        }
        alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (_) in
            
            let updateIngestRecipeParameters = VzaarUpdateIngestRecipeParameters(id: NSNumber(value: ingestRecipeId))
            if let text = alertController.textFields?.first?.text{
                updateIngestRecipeParameters.name = text
            }
            
            Vzaar.sharedInstance().updateIngestRecipe(vzaarUpdateIngestRecipeParameters: updateIngestRecipeParameters, success: { (ingestRecipe) in
                
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                    for i in 0..<self.ingestRecipes.count{
                        if self.ingestRecipes[i].id == ingestRecipeId{
                            self.ingestRecipes[i] = ingestRecipe
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
        return ingestRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingestRecipeCell", for: indexPath) as! IngestRecipeTableViewCell
        
        cell.ingestRecipeLabel.text = ingestRecipes[indexPath.row].name
        cell.delegate = self
        cell.ingestRecipeId = ingestRecipes[indexPath.row].id
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
