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
    var searchBar: UISearchBar!
    var listaVazia: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hides the shadow line of the nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        self.auth = Auth.auth()
        configLocationManager()
        configCell()
        loadFetcher()
        loadSearchResultController()
        configSearchBar()
        
        self.listaVazia = self.viewVazia()
    }
    
    func viewVazia() -> UIView {
        let tabelaVazia = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)![0] as! UIView
        tabelaVazia.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.tableView.frame.size.height)
        
        return tabelaVazia
    }
    
    func configSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Digite a cidade"
    }
    
    func loadFetcher() {
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    
    func loadSearchResultController() {
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
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
                    self.carregaDadosLocal(latitude: _latitude, longitude: _longitude)
                }
            }
        }
    }
    
    //Loads the data based on current latitude and longitude location
    func carregaDadosLocal(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        showProgress()
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
                    
                } else {//nao foi possivel de obter o local
                    self.dismissProgress()
                }
                
            } else {//algo deu errado
                self.dismissProgress()
            }
        }
    }
}


// MARK: - <#LocateOnTheMap#>
extension Clima: LocateOnTheMap {
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        self.carregaDadosLocal(latitude: lat, longitude: lon)
    }
    
    
}


// MARK: - <#GMSAutocompleteFetcherDelegate#>
extension Clima: GMSAutocompleteFetcherDelegate {
    
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