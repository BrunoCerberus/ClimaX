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
    
    override func prepareForReuse() {
        self.temperatura.text = ""
        self.sensTermica.text = ""
        self.umidade.text = ""
        self.velocVento.text = ""
        self.diaDaSemana.text = ""
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
        
        switch previsaoTempo.textIcon.icon.day {
        case "1":
            tempoLocal = TempoLocal.ensolarado
            break
        case "2":
            tempoLocal = TempoLocal.solComNuvens
            break
        case "3":
            tempoLocal = TempoLocal.fechado
            break
        case "4":
            tempoLocal = TempoLocal.solComChuva
            break
        case "5":
            tempoLocal = TempoLocal.chuvoso
            break
        case "6":
            tempoLocal = TempoLocal.tepestade
            break
        case "7":
            tempoLocal = TempoLocal.vendaval
            break
        case "8":
            tempoLocal = TempoLocal.neve
            break
        case "9":
            tempoLocal = TempoLocal.solComNuvens
            break
        default:
            tempoLocal = TempoLocal.ensolarado
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
        case TempoLocal.neve:
            self.climaImage.image = #imageLiteral(resourceName: "snowflake")
            break
        case TempoLocal.solComNuvens:
            self.climaImage.image = #imageLiteral(resourceName: "clouds-and-sun")
            break
        case TempoLocal.solComChuva:
            self.climaImage.image = #imageLiteral(resourceName: "sun_and_rain")
            break
            
        }
    }
    
}
