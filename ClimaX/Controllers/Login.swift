//
//  ViewController.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 28/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.auth = Auth.auth()
        
        self.auth.addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                self.performSegue(withIdentifier: "segueLogin", sender: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == email {
            self.senha.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            self.loginNow()
        }
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loginNow() {
        
        if let _email = self.email.text {
            if let _senha = self.senha.text {
                self.auth.signIn(withEmail: _email, password: _senha, completion: { (user, erro) in
                    
                    if erro == nil {
                        // sucesso ao logar o usuario
                        
                    } else {
                        //alerta de erro
                    }
                })
            }
        }
    }

    @IBAction func logar(_ sender: Any) {
        self.loginNow()
    }
    

}

