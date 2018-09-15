//
//  Clima.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 02/02/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import SwiftyJSON

class Tempo {
    
    var temperatura: String!
    var sensTermica: String!
    var umidade: String!
    var velocVento: Double!
    var tempoLocal: TempoLocal!
    var data: String!
    
    init(json: JSON) {
        
        data = json["date_br"].stringValue
        umidade = "\(json["humidity"]["min"].intValue)% ~ \(json["humidity"]["max"].intValue)%"
        velocVento = json["wind"]["velocity_avg"].doubleValue
        temperatura = "\(json["temperature"]["min"].intValue)C ~ \(json["temperature"]["max"])C"
        sensTermica = "\(json["thermal_sensation"]["min"].intValue)C ~ \(json["thermal_sensation"]["max"].intValue)C"
        let rainProb = json["rain"]["probability"].intValue
        if rainProb >= 30 {
            tempoLocal = TempoLocal.chuvoso
        } else {
            let texto = json["text_icon"]["text"]["pt"].stringValue
            if (texto.range(of: "Sol") != nil) || (texto.range(of: "sol") != nil) {
                //we have sun
                tempoLocal = TempoLocal.ensolarado
            } else if (texto.range(of: "Nublado") != nil) || (texto.range(of: "nublado") != nil) || (texto.range(of: "nuvens") != nil) || (texto.range(of: "Nuvens") != nil) {
                //we have a cloudy weather
                tempoLocal = TempoLocal.fechado
            }
            else {
                tempoLocal = TempoLocal.vendaval
            }
        }
        
    }
    
}
