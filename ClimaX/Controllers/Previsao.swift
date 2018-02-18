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
    
    func commonInit(temp: String, sensTermica: String, umidade: String, velocVento: Double, data: String, tempoLocal: TempoLocal) {
        
        self.temperatura.text = "Temperaturas: " + temp
        self.sensTermica.text = "Sensação: " + sensTermica
        self.umidade.text = "Umidade: " + umidade
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
