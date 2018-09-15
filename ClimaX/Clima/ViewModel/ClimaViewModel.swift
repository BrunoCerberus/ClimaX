//
//  ClimaViewModel.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 05/05/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

protocol ClimaViewModelProtocol {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func getPrevisao(in indexPath: IndexPath) -> Datum
    func carregaDadosLocal(whith latitude: CLLocationDegrees,
                           and longitude: CLLocationDegrees,
                           onComplete: @escaping (String, String) -> Void,
                           onError: @escaping (_ mensagem: String) -> Void )
    
    func getIdCidade(cidade: String, estado: String,
                     onComplete: @escaping (Int) -> Void,
                     onError: @escaping (_ mensagem: String) -> Void)
    
    func getClima(cidadeId: Int,
                  onComplete: @escaping (String) -> Void,
                  onError: @escaping (_ mensagem: String) -> Void)
    
    func getViewVazia(to viewController: UIViewController,
                      with width: CGFloat,
                      and height: CGFloat ) -> UIView
    
    func setCustomCell(with nibName: String, and bundle: Bundle?) -> UINib
}

class ClimaViewModel: ClimaViewModelProtocol {
    
    var previsaoTempo: [Datum] = []
    let myToken: String = "0925e8c6873f32e349f881fa1da4564e"
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return previsaoTempo.count
    }
    
    func getPrevisao(in indexPath: IndexPath) -> Datum {
        return previsaoTempo[indexPath.row]
    }
    
    func setCustomCell(with nibName: String, and bundle: Bundle?) -> UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    func carregaDadosLocal(whith latitude: CLLocationDegrees,
                           and longitude: CLLocationDegrees,
                           onComplete: @escaping (String, String) -> Void,
                           onError: @escaping (String) -> Void) {

        let localAtual = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(localAtual) { (local, erro) in
            
            if erro == nil {
                //Sucesso ao carregar as coordenadas do local
                
                if let dadosLocal = local?.first {
                    
                    //loads the city name
                    if let city = dadosLocal.locality {
                        if let state = dadosLocal.administrativeArea {
                            onComplete(city, state)
                        }
                    }
                    
                } else {//nao foi possivel de obter o local
                    onError(erro?.localizedDescription ?? "Algo deu errado")
                }
                
            } else {//algo deu errado
                onError(erro?.localizedDescription ?? "Algo deu errado")
            }
        }
    }
    
    func getIdCidade(cidade: String, estado: String,
                     onComplete: @escaping (Int) -> Void,
                     onError: @escaping (String) -> Void) {
        //Request with response handling
        request("http://apiadvisor.climatempo.com.br/api/v1/locale/city",
                method: .get,
                parameters: ["name": cidade,
                             "state": estado,
                             "token": myToken]).responseJSON { (response) in
            
            let json = JSON(response.result.value!)
            if !json.isEmpty {
                for object in json.arrayValue {
                    let cityID = object["id"].intValue
                    print("City ID: \(cityID)")
                    onComplete(cityID)
                }
            } else {//consulta veio vazia []
                onError(response.error?.localizedDescription ?? "Algo deu errado")
            }
            
        }
    }
    
    func getClima(cidadeId: Int, onComplete: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        
        request("http://apiadvisor.climatempo.com.br/api/v1/forecast/locale/\(cidadeId)/days/15",
            method: .get,
            parameters: ["token": myToken]).responseJSON { (response) in
            
            let welcome = try? JSONDecoder().decode(Welcome.self, from: response.data!)
            if let climas = welcome?.data {
                let cidade = welcome?.name ?? ""
                self.previsaoTempo = climas
                onComplete(cidade)
               
            } else {
                onError(response.error?.localizedDescription ?? "Algo deu errado")
            }
        }
    }
    
    func getViewVazia(to viewController: UIViewController, with width: CGFloat, and height: CGFloat) -> UIView {
        if let tabelaVazia = Bundle.main.loadNibNamed("EmptyView", owner: viewController, options: nil)![0] as? UIView {
            tabelaVazia.frame = CGRect(x: 0, y: 0, width: width, height: height)
            return tabelaVazia
        }
        return UIView()
    }
}
