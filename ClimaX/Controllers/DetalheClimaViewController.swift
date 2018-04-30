//
//  DetalheClimaViewController.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 30/04/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit

class DetalheClimaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmar(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
