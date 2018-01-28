//
//  Grafico.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 28/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth

class Grafico: UIViewController {
    
    var auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sair(_ sender: Any) {
        
        do {
            try self.auth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let erro {
            print("Erro: " + erro.localizedDescription)
        }
        
    }
    
}
