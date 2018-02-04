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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(tempo: Tempo) {
        
        if let _temp = tempo.temperatura {
            if let _sensTermica = tempo.sensTermica {
                if let _umidade = tempo.umidade {
                    if let _velocVento = tempo.velocVento {
                        self.temperatura.text = "Temperatura: \(_temp)"
                        self.sensTermica.text = "Sensação: \(_sensTermica)"
                        self.umidade.text = "Umidade: \(_umidade)"
                        self.velocVento.text = "Velocidade do Vento: \(_velocVento)"
                    }
                }
            }
        }
        
        switch tempo.tempoLocal.rawValue {
            
        case TempoLocal.ensolarado.rawValue:
            self.climaImage.image = #imageLiteral(resourceName: "sunny")
            break
        case TempoLocal.chuvoso.rawValue:
            self.climaImage.image = #imageLiteral(resourceName: "drop")
            break
        case TempoLocal.fechado.rawValue:
            self.climaImage.image = #imageLiteral(resourceName: "cloud")
            break
        case TempoLocal.tepestade.rawValue:
            self.climaImage.image = #imageLiteral(resourceName: "storm")
            break
        case TempoLocal.vendaval.rawValue:
            self.climaImage.image = #imageLiteral(resourceName: "wind")
            break
        default: break
            
        }
    }
    
}
