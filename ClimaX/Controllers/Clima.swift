//
//  Clima.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 28/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit
import SwiftyJSON

class Clima: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var auth:Auth!
    var gerenciadorDeLocalizacao = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        
        self.gerenciadorDeLocalizacao.delegate = self
        self.gerenciadorDeLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        self.gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
        self.gerenciadorDeLocalizacao.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let _latitude = manager.location?.coordinate.latitude {
            if let _longitude = manager.location?.coordinate.longitude {
                self.carregaDadosLocal(latitude: _latitude, longitude: _longitude)
                self.gerenciadorDeLocalizacao.stopUpdatingLocation()
            }
        }
    }
    
    func carregaDadosLocal(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let localAtual = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(localAtual) { (local, erro) in
            
            if erro == nil {
                //Sucesso ao carregar as coordenadas do local
                
            }
        }
    }
    
    func carregaDadosLocal(PorNome local: String) {
        
    }
    
    @IBAction func sair(_ sender: Any) {
        
        do {
            try self.auth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let erro {
            print("Erro: " + erro.localizedDescription)
        }
    }
    
    func pesquisaIDCidade() {
        
    }
    
    func pesquisaClimaJSON() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell")
        cell?.textLabel?.text = "teste"
        return cell!
    }
    
}
