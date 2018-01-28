//
//  SignUp.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 28/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmaSenha: UITextField!
    
    var auth: Auth!
    var database: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        self.database = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case nome:
            self.email.becomeFirstResponder()
            break
        case email:
            self.senha.becomeFirstResponder()
            break
        case senha:
            self.confirmaSenha.becomeFirstResponder()
            break
        default:
            self.view.endEditing(true)
            self.cadastraUsuario()
            break
        }
        
        return false
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        self.cadastraUsuario()
        
    }
    
    func verificaCampos() -> String {
        
        var msg = ""
        
        if self.nome.text == "" {
            msg = "Preencha nome"
        } else if self.email.text == "" {
            msg = "Preencha o email"
        } else if self.senha.text == "" {
            msg = "Preencha a senha"
        } else {
            msg = "Confirme a sua senha"
        }
        
        return msg
    }
    
    func confirmaSenhas() -> Bool {
        
        if self.senha.text == self.confirmaSenha.text {
            return true
        } else {
            return false
        }
        
    }

    func cadastraUsuario() {
        
        if self.verificaCampos() != "" {
            
            if self.confirmaSenhas() {
                
                if let _nome = nome.text {
                    if let _email = email.text {
                        if let _senha = senha.text {
                            
                            self.auth.createUser(withEmail: _email, password: _senha, completion: { (user, erro) in
                                
                                if erro == nil {
                                    
                                    // converter email para base 64
                                    let chave = Base64().codificarStringBase64(texto: _email)
                                    
                                    let usuarios = self.database.child("usuarios")
                                    
                                    let dadosUsuario: Dictionary<String, String> = [
                                        "nome": _nome,
                                        "email": _email
                                    ]
                                    usuarios.child(chave).setValue(dadosUsuario)
                                    
                                } else {
                                    // houve um erro ao cadastrar o usuario
                                    
                                }
                            })
                        }
                    }
                }
            } else {
                //Exibir alerta senhas diferentes
            }
            
            
        } else {
            // exibir alerta
        }
    }
    

}
