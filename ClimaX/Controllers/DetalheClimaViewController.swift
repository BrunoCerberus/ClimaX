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
    
    var cidade: String? = nil
    var idCidade: String? = nil
    var previsao: Datum? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.carregaDados()
    }
    
    func carregaDados() {
        
        if let _previsao = self.previsao, let _cidade = self.cidade, let _idCidade = self.idCidade {
            self.cidadeLabel.text = _cidade
            self.codCidade.text = _idCidade
            self.dataLabel.text = _previsao.dateBr
            self.umidade.text = "\((_previsao.humidity.max + _previsao.humidity.min)/2)"
            self.probabilidadeDeChuva.text = "\(_previsao.rain.probability)%"
            self.velocDoVento.text = "\(_previsao.wind.velocityAvg)km/h"
            self.intensidadeUV.text = "\(_previsao.uv.max)"
            self.sensacaoTermica.text = "\((_previsao.thermalSensation.max + _previsao.thermalSensation.min)/2)C"
            self.tempMax.text = "\(_previsao.temperature.max)C"
            self.tempMin.text = "\(_previsao.temperature.min)C"
            self.precipitacao.text = "\(_previsao.rain.precipitation)"
            self.situacao.text = _previsao.textIcon.text.phrase.reduced ?? "----"
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
