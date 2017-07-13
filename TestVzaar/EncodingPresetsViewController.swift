//
//  EncodingPresetsViewController.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit
import Vzaar

class EncodingPresetsViewController: UIViewController , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var loadingView: LoadingView!
    var encodingPresets: [VzaarEncodingPreset] = [VzaarEncodingPreset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Encoding Presets"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EncodingPresetTableViewCell", bundle: nil), forCellReuseIdentifier: "encodingPresetCell")
        
        getEncodingPresets()
    }
    
    func getEncodingPresets(){
        
        self.loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let window: UIWindow = (UIApplication.shared.delegate?.window!)!
        window.addSubview(self.loadingView)
        
        let encodingPresetsParameters = VzaarGetEncodingPresetsParameters()
        
        Vzaar.sharedInstance().getEncodingPresets(vzaarGetEncodingPresetsParameters: encodingPresetsParameters, success: { (vzaarEncodingPresets) in
            
            DispatchQueue.main.async {
                if self.loadingView != nil {
                    self.loadingView.removeFromSuperview()
                    self.encodingPresets = vzaarEncodingPresets
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
    
    // MARK - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return encodingPresets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "encodingPresetCell", for: indexPath) as! EncodingPresetTableViewCell
        
        cell.encodingPresetlabel.text = encodingPresets[indexPath.row].name
        if let id = encodingPresets[indexPath.row].id{
            cell.encodingPresetIdLabel.text = "\(id)"
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
