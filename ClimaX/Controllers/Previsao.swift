//
//  Previsao.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 02/02/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit

class Previsao: UITableViewCell {
    
    @IBOutlet weak var temperatura: UILabel!
    @IBOutlet weak var sensTermica: UILabel!
    @IBOutlet weak var umidade: UILabel!
    @IBOutlet weak var velocVento: UILabel!
    @IBOutlet weak var climaImage: UIImageView!
    @IBOutlet weak var diaDaSemana: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(previsaoTempo: Datum) {
        
        let temperatura = (previsaoTempo.temperature.max + previsaoTempo.temperature.min)/2
        let sensasaoTermica = (previsaoTempo.thermalSensation.max + previsaoTempo.thermalSensation.min)/2
        let umidade = (previsaoTempo.humidity.max + previsaoTempo.humidity.min)/2
        let velocVento = previsaoTempo.wind.velocityAvg
        let data = previsaoTempo.dateBr
        var tempoLocal: TempoLocal
        
        if previsaoTempo.rain.probability >= 60 {
            tempoLocal = TempoLocal.chuvoso
        } else {
            if (previsaoTempo.textIcon.text.pt.range(of: "Sol") != nil) || (previsaoTempo.textIcon.text.pt.range(of: "sol") != nil) {
                //we have sun
                tempoLocal = TempoLocal.ensolarado
            } else if (previsaoTempo.textIcon.text.pt.range(of: "Nublado") != nil) || (previsaoTempo.textIcon.text.pt.range(of: "nublado") != nil) || (previsaoTempo.textIcon.text.pt.range(of: "nuvens") != nil) || (previsaoTempo.textIcon.text.pt.range(of: "Nuvens") != nil) {
                //we have a cloudy weather
                tempoLocal = TempoLocal.fechado
            }
            else {
                tempoLocal = TempoLocal.vendaval
            }
        }
        
        self.temperatura.text = "Temperaturas: " + "\(temperatura)"
        self.sensTermica.text = "Sensação: " + "\(sensasaoTermica)"
        self.umidade.text = "Umidade: " + "\(umidade)"
        self.velocVento.text = "Velocidade do vento: \(velocVento)KM/h"
        self.diaDaSemana.text = data
        
        switch tempoLocal {

        case TempoLocal.ensolarado:
            self.climaImage.image = #imageLiteral(resourceName: "sunny")
            break
        case TempoLocal.chuvoso:
            self.climaImage.image = #imageLiteral(resourceName: "rain")
            break
        case TempoLocal.fechado:
            self.climaImage.image = #imageLiteral(resourceName: "fog")
            break
        case TempoLocal.tepestade:
            self.climaImage.image = #imageLiteral(resourceName: "storm")
            break
        case TempoLocal.vendaval:
            self.climaImage.image = #imageLiteral(resourceName: "umbrella")
            break
            
        }
    }
    
}
