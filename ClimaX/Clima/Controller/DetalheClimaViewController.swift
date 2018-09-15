//
//  DetalheClimaViewController.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 30/04/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit

class DetalheClimaViewController: UIViewController {

    @IBOutlet weak var cidadeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var umidade: UILabel!
    @IBOutlet weak var probabilidadeDeChuva: UILabel!
    @IBOutlet weak var velocDoVento: UILabel!
    @IBOutlet weak var intensidadeUV: UILabel!
    @IBOutlet weak var sensacaoTermica: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var precipitacao: UILabel!
    @IBOutlet weak var codCidade: UILabel!
    @IBOutlet weak var situacao: UILabel!
    
    var cidade: String?
    var idCidade: String?
    var previsao: Datum?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.carregaDados()
    }
    
    func carregaDados() {
        
        if let previsao = self.previsao, let cidade = self.cidade, let idCidade = self.idCidade {
            self.cidadeLabel.text = cidade
            self.codCidade.text = idCidade
            self.dataLabel.text = previsao.dateBr
            self.umidade.text = "\((previsao.humidity.max + previsao.humidity.min)/2)"
            self.probabilidadeDeChuva.text = "\(previsao.rain.probability)%"
            self.velocDoVento.text = "\(previsao.wind.velocityAvg)km/h"
            self.intensidadeUV.text = "\(previsao.uv.max)"
            self.sensacaoTermica.text = "\((previsao.thermalSensation.max + previsao.thermalSensation.min)/2)C"
            self.tempMax.text = "\(previsao.temperature.max)C"
            self.tempMin.text = "\(previsao.temperature.min)C"
            self.precipitacao.text = "\(previsao.rain.precipitation)"
            self.situacao.text = previsao.textIcon.text.phrase.reduced ?? "----"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmar(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
