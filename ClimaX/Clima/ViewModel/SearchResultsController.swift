//
//  SearchResultsController.swift
//  PlacesLookup
//
//  Created by Bruno Lopes de Mello on 10/01/2018.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.

import UIKit
import Foundation
import MapKit


protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}


class SearchResultsController: UITableViewController {
    
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        self.dismiss(animated: true, completion: nil)
        
        CLGeocoder().geocodeAddressString(self.searchResults[indexPath.row]) { (location, erro) in
            
            if erro == nil {
                if let dadosLocal = location?.first {
                    
                    if let latitude = dadosLocal.location?.coordinate.latitude {
                        if let longitude = dadosLocal.location?.coordinate.longitude {
                            self.delegate.locateWithLongitude(longitude, andLatitude: latitude, andTitle: self.searchResults[indexPath.row])
                        }
                    }
                }
            }
        }
        
    }
    
    
    open func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
}
