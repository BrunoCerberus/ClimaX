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
        umidade = "\(json["humidity"]["min"].intValue) ~ \(json["humidity"]["max"].intValue)"
        velocVento = json["wind"]["velocity_avg"].doubleValue
        temperatura = "\(json["temperature"]["min"].intValue) ~ \(json["temperature"]["max"])"
        sensTermica = "\(json["thermal_sensation"]["min"].intValue) ~ \(json["thermal_sensation"]["max"].intValue)"
        let _rainProb = json["rain"]["probability"].intValue
        if _rainProb >= 30 {
            tempoLocal = TempoLocal.chuvoso
        } else {
            let _text = json["text_icon"]["text"]["pt"].stringValue
            if (_text.range(of: "Sol") != nil) || (_text.range(of: "sol") != nil) {
                //we have sun
                tempoLocal = TempoLocal.ensolarado
            } else if (_text.range(of: "Nublado") != nil) || (_text.range(of: "nublado") != nil) || (_text.range(of: "nuvens") != nil) || (_text.range(of: "Nuvens") != nil) {
                //we have a cloudy weather
                tempoLocal = TempoLocal.fechado
            }
            else {
                tempoLocal = TempoLocal.vendaval
            }
        }
        
    }
    
}
