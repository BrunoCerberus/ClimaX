//
//  Mapa.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 28/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit

class Mapa: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var auth: Auth!
    var searchController: UISearchController!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        
        locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sair(_ sender: Any) {
        
        let alerta = GlobalAlert(with: self, msg: "Deseja sair?", confirmButton: false, confirmAndCancelButton: true, isModal: true)
        alerta.logout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


// MARK: - <#UISearchBarDelegate#>
extension Mapa: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: \(searchText)")
    }
}


// MARK: - <#MKMapViewDelegate, CLLocationManagerDelegate#>
extension Mapa: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
