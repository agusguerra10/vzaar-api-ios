//
//  CategoriesViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class CategoriesViewController: UIViewController , UITableViewDataSource, UITextFieldDelegate, CategoryTableViewCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var loadingView: LoadingView!
    var categories: [VzaarCategory] = [VzaarCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Categories"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        
        let addCategorybutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addCategoryAction))
        let refreshCategoriesButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refreshCategoriesAction))
        self.navigationItem.rightBarButtonItems = [addCategorybutton, refreshCategoriesButton]
        
        getCategories()
    }
    
    func addCategoryAction(){
        
        let alert = UIAlertController(title: "Set a name for the Category", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.delegate = self
            textField.textAlignment = NSTextAlignment.center
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.placeholder = "Name"
        })
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (_) in
            if let text = alert.textFields?.first?.text{
                
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                let window: UIWindow = (UIApplication.shared.delegate?.window!)!
                window.addSubview(self.loadingView)
                
                self.addCategory(name: text)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addCategory(name: String){
    
        let categoryParameters = VzaarCreateCategoryParameters(name: name)
        
        Vzaar.sharedInstance().createCategory(vzaarCreateCategoryParameters: categoryParameters, success: { (category) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil {
                    self.loadingView.removeFromSuperview()
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
    
    func refreshCategoriesAction(){
        getCategories()
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
    
    internal func updateCategory(categoryId: Int, currentTitleText: String) {
        
        let alertController = UIAlertController(title: "Update Category", message: "Title", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.textAlignment = NSTextAlignment.center
            textField.text = currentTitleText
            textField.placeholder = "Name"
        }
        alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (_) in
            
            let updateCategoryParameters = VzaarUpdateCategoryParameters(id: Int32(categoryId))
            if let text = alertController.textFields?.first?.text{
                updateCategoryParameters.name = text
            }
            
            Vzaar.sharedInstance().updateCategory(vzaarUpdateCategoryParameters: updateCategoryParameters, success: { (category) in
                
                DispatchQueue.main.async {
                    if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                    for i in 0..<self.categories.count{
                        if self.categories[i].id == categoryId{
                            self.categories[i] = category
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
    
    internal func deleteCategory(categoryId: Int) {
        
        let deleteCategoryParameters = VzaarDeleteCategoryParameters(id: Int32(categoryId))
        
        Vzaar.sharedInstance().deleteCategory(vzaarDeleteCategoryParameters: deleteCategoryParameters, success: { 
            
            DispatchQueue.main.async {
                if self.loadingView != nil { self.loadingView.removeFromSuperview() }
                for i in 0..<self.categories.count{
                    if self.categories[i].id == categoryId{
                        self.categories.remove(at: i)
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
        }, noResponse: { (error) in
            DispatchQueue.main.async { if self.loadingView != nil { self.loadingView.removeFromSuperview() } }
            if let error = error{
                print(error)
            }
        })
    }
    
    // MARK - TableView Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.delegate = self
        cell.categoryId = categories[indexPath.row].id
        cell.categoryLabel.text = categories[indexPath.row].name
        if let id = categories[indexPath.row].id{
            cell.categoryIdLabel.text = "\(id)"
        }
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
