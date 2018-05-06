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
import GooglePlaces

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
    var searchResultController: SearchResultsController!
    var searchController: UISearchController!
    var gmsFetcher: GMSAutocompleteFetcher!
    var resultArray: [String] = []
    var listaVazia: UIView!
    var viewModel: ClimaViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ClimaViewModel()
        
        //hides the shadow line of the nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.listaVazia = self.viewModel.getViewVazia(to: self, with: self.view.frame.size.width, and: self.tableView.frame.size.height)
        self.tableView.register(self.viewModel.setCustomCell(with: "Previsao", and: nil), forCellReuseIdentifier: "reuseCell")

        self.auth = Auth.auth()
        configLocationManager()
        loadFetcher()
        loadSearchResultController()
        
        
    }
    
    func loadSearchResultController() {
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
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
            if !json.isEmpty {
                for object in json.arrayValue {
                    let cityID = object["id"].intValue
                    print("City ID: \(cityID)")
                    DispatchQueue.main.async(execute: {
                        self.pesquisaClimaJSON(cityID)
                    })
                }
            } else {//consulta veio vazia []
                self.dismissProgress()
                let alert = GlobalAlert(with: self, msg: "Não foi possível obter a previsão deste local", confirmButton: true, confirmAndCancelButton: false, isModal: true)
                alert.showAlert()
            }
            
        }
        
    }
    
    func pesquisaClimaJSON(_ cityID: Int) {
        
        request("http://apiadvisor.climatempo.com.br/api/v1/forecast/locale/\(cityID)/days/15", method: .get, parameters: ["token":myToken]).responseJSON { (response) in
            
            let welcome = try? JSONDecoder().decode(Welcome.self, from: response.data!)
            if let climas = welcome?.data {
                self.cidade = welcome?.name ?? ""
                self.navigationItem.title = self.cidade ?? "Clima"
                self.idCidade = "\(welcome?.id ?? 0)"
                self.previsaoTempo = climas
                self.dismissProgress()
                self.tableView.reloadData()
            } else {
                self.dismissProgress()
                self.tableView.addSubview(self.listaVazia)
                self.tableView.isScrollEnabled = false
                let alert = GlobalAlert(with: self, msg: "Algo deu errado, tente novamente mais tarde")
                alert.showAlert()
            }
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
    
    @IBAction func searchPlace(_ sender: Any) {
        
        self.searchController = UISearchController(searchResultsController: searchResultController)
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Digite uma cidade"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.present(self.searchController, animated:true, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showProgress() {
        self.listaVazia.removeFromSuperview()
        self.tableView.isScrollEnabled = true
        SVProgressHUD.show()
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func dismissProgress() {
        SVProgressHUD.dismiss()
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
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
                    showProgress()
                    firstUpdate = false
                    self.gerenciadorDeLocalizacao.stopUpdatingLocation()
                    self.viewModel.carregaDadosLocal(whith: _latitude, and: _longitude, onComplete: { (city, state) in
                        self.dismissProgress()
                        self.pesquisaIDCidade(city, state)
                        
                    }) { (errorMsg) in
                        self.dismissProgress()
                        let alert = GlobalAlert(with: self, msg: errorMsg)
                        alert.showAlert()
                    }
                }
            }
        }
    }
}


// MARK: - <#LocateOnTheMap#>
extension Clima: LocateOnTheMap {
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        showProgress()
        self.viewModel.carregaDadosLocal(whith: lat, and: lon, onComplete: { (city, state) in
            self.dismissProgress()
            self.pesquisaIDCidade(city, state)
            
        }) { (errorMsg) in
            self.dismissProgress()
            let alert = GlobalAlert(with: self, msg: errorMsg)
            alert.showAlert()
        }
    }
    
    
}


// MARK: - <#GMSAutocompleteFetcherDelegate#>
extension Clima: GMSAutocompleteFetcherDelegate {
    
    func loadFetcher() {
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction?{
                self.resultArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        //now, do nothing
    }
    
}


// MARK: - <#UISearchBarDelegate#>
extension Clima: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resultArray.removeAll()
        self.dismissKeyboard()
        self.searchController.dismiss(animated: true, completion: nil)
        
        //aqui vai vim a pesquisa com base no nome com o CLGeocoder
        carregaDadosLocal(PorNome: self.searchController.searchBar.text ?? "")
    }
}
