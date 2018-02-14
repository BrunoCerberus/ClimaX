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
    
    var temperatura: Double!
    var sensTermica: Double!
    var umidade: Double!
    var velocVento: Double!
    var tempoLocal: TempoLocal!
    var data: String!
    
    init(json: JSON) {
        
        let _temperatura = json["date_br"].stringValue
        let _umidade = "\(json["humidity"]["min"].intValue) ~ \(json["humidity"]["max"].intValue)"
        
    }
    
}
