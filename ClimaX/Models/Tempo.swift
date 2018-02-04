//
//  Clima.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 02/02/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

class Tempo {
    
    var temperatura: Double!
    var sensTermica: Double!
    var umidade: Double!
    var velocVento: Double!
    var tempoLocal: TempoLocal!
    
    init(temp: Double, sensTermica: Double, umidade: Double, velocVento: Double, tempoLocal: TempoLocal) {
        self.temperatura = temp
        self.sensTermica = sensTermica
        self.umidade = umidade
        self.velocVento = velocVento
        self.tempoLocal = tempoLocal
    }
    
}
