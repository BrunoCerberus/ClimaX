//
//  Base64.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 27/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

class Base64 {
    
    func codificarStringBase64(texto: String) -> String {
        
        let dados = texto.data(using: String.Encoding.utf8)
        let base64 = dados!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return base64
    }
}
