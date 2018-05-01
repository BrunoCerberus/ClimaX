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
import SVProgressHUD
import Alamofire

class Clima: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pesquisa: UIBarButtonItem!
    
    var auth:Auth!
    var gerenciadorDeLocalizacao = CLLocationManager()
    var firstUpdate: Bool = true
    let myToken = "0925e8c6873f32e349f881fa1da4564e"
    var previsaoTempo: [Datum] = []
    var previsaoSelecionada: Datum!
    var cidade: String? = nil
    var idCidade: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hides the shadow line of the nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        self.auth = Auth.auth()
        configLocationManager()
        configCell()
    }
    
    //Register the Xib Cell
    func configCell() {
        let nibName = UINib(nibName: "Previsao", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "reuseCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Loads the latitude and longitude based on the name of location
    //this method uses the GooglePlaces API
    func carregaDadosLocal(PorNome local: String) {
        
    }
    
    @IBAction func sair(_ sender: Any) {
        
        let alerta = GlobalAlert(with: self, msg: "Deseja sair?", confirmButton: false, confirmAndCancelButton: true, isModal: true)
        alerta.logout()
      
    }
    
    
    /// Pesquisa o ID baseado no nome da cidade
    ///
    /// - Parameters:
    ///   - cidade: Nome da cidade
    ///   - estado: UF do estado
    func pesquisaIDCidade(_ cidade: String, _ estado: String) {
        
        //Request with response handling
        request("http://apiadvisor.climatempo.com.br/api/v1/locale/city", method: .get, parameters: ["name":cidade, "state":estado, "token":myToken]).responseJSON { (response) in
            
            let json = JSON(response.result.value!)
            for object in json.arrayValue {
                let cityID = object["id"].intValue
                print("City ID: \(cityID)")
                DispatchQueue.main.async(execute: {
                    self.pesquisaClimaJSON(cityID)
                })
            }
            
        }
        
    }
    
    func pesquisaClimaJSON(_ cityID: Int) {
        
        request("http://apiadvisor.climatempo.com.br/api/v1/forecast/locale/\(cityID)/days/15", method: .get, parameters: ["token":myToken]).responseJSON { (response) in
            
            let welcome = try? JSONDecoder().decode(Welcome.self, from: response.data!)
            if let climas = welcome?.data {
                self.cidade = welcome?.name ?? ""
                self.idCidade = "\(welcome?.id ?? 0)"
                self.previsaoTempo = climas
            }
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let controller = segue.destination as? DetalheClimaViewController {
                
                if (!(self.cidade?.isEmpty)! || self.cidade != nil || !(self.idCidade?.isEmpty)! || self.idCidade != "0"){
                    controller.cidade = self.cidade
                    controller.idCidade = self.idCidade
                    controller.previsao = self.previsaoSelecionada
                }
            }
        }
    }
    
}


// MARK: - <#UITableViewDelegate, UITableViewDataSource#>
extension Clima: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previsaoTempo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! Previsao
        let previsao = previsaoTempo[indexPath.row]
        cell.commonInit(previsaoTempo: previsao)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.previsaoSelecionada = previsaoTempo[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
}


// MARK: - <#CLLocationManagerDelegate#>
extension Clima: CLLocationManagerDelegate {
    
    func configLocationManager() {
        self.gerenciadorDeLocalizacao.delegate = self
        self.gerenciadorDeLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        self.gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
        self.gerenciadorDeLocalizacao.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if firstUpdate {
            if let _latitude = locations.first?.coordinate.latitude {
                if let _longitude = locations.first?.coordinate.longitude {
                    SVProgressHUD.show()
                    firstUpdate = false
                    self.gerenciadorDeLocalizacao.stopUpdatingLocation()
                    self.carregaDadosLocal(latitude: _latitude, longitude: _longitude)
                }
            }
        }
    }
    
    //Loads the data based on current latitude and longitude location
    func carregaDadosLocal(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let localAtual = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(localAtual) { (local, erro) in
            
            if erro == nil {
                //Sucesso ao carregar as coordenadas do local
                
                if let dadosLocal = local?.first {
                    
                    //loads the city name
                    if let city = dadosLocal.locality {
                        if let state = dadosLocal.administrativeArea {
                            self.pesquisaIDCidade(city, state)
                        }
                    }
                    
                }
                
            }
        }
    }
}
