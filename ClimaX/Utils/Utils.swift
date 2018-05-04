//
//  Utils.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 04/05/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import CoreTelephony

class Utils {
    
    static var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func adjustScroll(scrollView: UIScrollView, keyboardHeight : CGFloat) {
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.bottom += keyboardHeight
        
        scrollView.contentInset = scrollViewInsets
        scrollView.scrollIndicatorInsets = scrollViewInsets;
    }
    
    // FORMATA LABEL COM SUBLINHADO SOBRE TEXTO
    static func formataTextosDoEstorno(label: UILabel) {
        
        let fonte = label.font.fontName
        let tamanho = label.font.pointSize
        
        let atributos: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: fonte, size: tamanho)!,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.gray,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.strikethroughColor.rawValue): UIColor.gray,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.strikethroughStyle.rawValue): 1 as AnyObject
        ]
        
        label.attributedText = NSAttributedString(string: label.text!, attributes: atributos)
    }
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
    static func exibirAlertaOK(titulo: String, msg: String, destaques: [String]!) {
        
        
        
    }
    
    static func exibirAlertaOK(titulo: String, msg: String, destaques: [String]!, controller: UIViewController) {
        
        let alert = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
        
    }
    
}

public class Util:NSObject {
    
    //MARK: - Funções
    class func log(texto: String) {
        let debug = true
        if debug {
            print(texto)
        }
    }
    
    class func retiraMascara(string: String) -> String {
        let components = string.components(separatedBy: NSCharacterSet(charactersIn: "1234567890").inverted)
        return components.joined(separator: "") as NSString as String
    }
    
    class func exibeMensagem(mensagem: String?, titulo: String, viewController: UIViewController) {
        exibeMensagem(mensagem: mensagem, titulo: titulo, delegate: nil, viewController: viewController)
    }
    
    class func exibeMensagem(mensagem: String?, titulo: String, delegate: AnyObject?, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.show(viewController, sender: nil)
        
    }
    
    class func dataValida(strData:String, formato:DateFormatter) -> Bool {
        if strData.count != formato.dateFormat.count {
            return false
        }
        formato.isLenient = false
        return formato.date(from: strData) != nil
    }
    
    class func dataPassada(strData:String, formato:DateFormatter) -> Bool {
        if strData.count != formato.dateFormat.count {
            return false
        }
        formato.isLenient = false
        if let data = formato.date(from: strData) {
            return data.timeIntervalSinceNow.isSignalingNaN
        } else {
            return false
        }
    }
    
    //funcao de conversao de datas
    class func dataStringToFormat(data : String , fromFormat:String , toFormat : String)->String? {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        if let date = formatter.date(from: data) {
            formatter.dateFormat = toFormat
            return formatter.string(from: date)
        }
        return data
        
    }
    
    //funcao de conversao de datas
    class func dataFromStringWithFormat(data : String , fromFormat:String, numCharaters:Int)->NSDate? {
        
        if (numCharaters>0) {
            let formatter = DateFormatter()
            formatter.dateFormat = fromFormat
            
            let index: String.Index = data.index(data.startIndex, offsetBy: numCharaters)
            let dateString = String(data[index])
            
            return formatter.date(from: dateString)! as NSDate
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        return formatter.date(from: data)! as NSDate
        
    }
    
    //funcao de conversao de datas
    class func dataToString(data: NSDate , toFormat:String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = toFormat
        return formatter.string(from: data as Date)
    }
    
    class func mascaraCpf (textField: UITextField, texto: String?) -> Void {
        var numeroComMascara: String = ""
        //Verifica se recebeu um novo texto
        if texto == nil {
            numeroComMascara = textField.text!
        } else {
            numeroComMascara = texto!
        }
        
        // let digitos = NSCharacterSet.decimalDigitCharacterSet.invertedSet as NSCharacterSet
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        
        // let filtro = numeroComMascara.componentsSeparatedByCharactersInSet(digitos) as NSArray
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        //Aplica a mascara
        if tamanho == 3 || tamanho == 6 || tamanho == 9 {
            textField.text = numeroComMascara
        } else if tamanho < 3 {
            textField.text = numero as String
        } else if tamanho < 6 {
            let restante = tamanho - 3
            textField.text = NSString(format: "%@.%@", numero.substring(with: NSMakeRange(0, 3)),numero.substring(with: NSMakeRange(3, restante))) as String
        } else if tamanho < 9 {
            let restante = tamanho - 6
            textField.text = NSString(format: "%@.%@.%@", numero.substring(with: NSMakeRange(0, 3)),numero.substring(with: NSMakeRange(3, 3)),numero.substring(with: NSMakeRange(6, restante))) as String
        } else if tamanho > 9 {
            //limitar a 11
            let restante = ((tamanho - 9) > 2 ? 2 : tamanho - 9)
            textField.text = NSString(format: "%@.%@.%@-%@",
                                      numero.substring(with: NSMakeRange(0, 3)),
                                      numero.substring(with: NSMakeRange(3, 3)),
                                      numero.substring(with: NSMakeRange(6, 3)),
                                      numero.substring(with: NSMakeRange(9, restante))) as String
        } else {
            textField.text = ""
        }
    }
    
    class func mascaraCartao(textField: UITextField, texto: String?) -> Void {
        var numeroComMascara = ""
        //Verifica se recebeu um novo texto
        if texto == nil {
            numeroComMascara = textField.text!
        } else {
            numeroComMascara = texto!
        }
        
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        
        // Aplica a mascara
        if tamanho == 4 || tamanho == 8 || tamanho == 12{
            textField.text = numeroComMascara
        } else if tamanho < 4 {
            textField.text = numero as String
        } else if tamanho < 8 {
            let restante = tamanho - 4
            textField.text = NSString(format: "%@ %@", numero.substring(with: NSMakeRange(0, 4)),numero.substring(with: NSMakeRange(4, restante))) as String
        } else if tamanho < 12 {
            let restante = tamanho - 8
            textField.text = NSString(format: "%@ %@ %@", numero.substring(with: NSMakeRange(0, 4)),numero.substring(with: NSMakeRange(4, 4)),numero.substring(with: NSMakeRange(8, restante))) as String
        } else if tamanho > 12 {
            //Limitar a 16 digitos
            let restante = ((tamanho - 12) > 4 ? 4 : tamanho - 12)
            textField.text = NSString(format: "%@ %@ %@ %@", numero.substring(with: NSMakeRange(0, 4)),numero.substring(with: NSMakeRange(4, 4)),numero.substring(with: NSMakeRange(8, 4)),numero.substring(with: NSMakeRange(12, restante))) as String
            if(tamanho == 16){
                textField.tag = 1
                textField.resignFirstResponder()
            }
        } else {
            textField.text = ""
        }
    }
    
    class func mascaraCelular(textField: UITextField, texto: String?) -> Void {
        var numeroComMascara = ""
        //Verifica se recebeu um novo texto
        if texto == nil {
            numeroComMascara = textField.text!
        } else {
            numeroComMascara = texto!
        }
        
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        
        var hifen = 6
        var numeroValido = true
        
        //Verifica se é celular valido e ajusta a quantidade de digitos
        if tamanho >= 3 {
            let digito = Int(numero.substring(with: NSMakeRange(2,1)))!
            if digito < 5 {
                numeroValido = false
            }
            if tamanho>10 {
                if digito == 9 {
                    hifen = 7
                } else {
                    numeroValido = false
                }
            }
        }
        if numeroValido {
            //Aplica a mascara
            if tamanho == 0 {
                textField.text = ""
            } else if tamanho < 3 {
                textField.text = "(\(numero)"
            } else if tamanho < hifen {
                let restante = tamanho - 2
                textField.text = NSString(format: "(%@) %@", numero.substring(with: NSMakeRange(0, 2)),numero.substring(with: NSMakeRange(2, restante))) as String
            } else if tamanho > hifen {
                let restante = ((tamanho - hifen) > 4 ? 4 : tamanho - hifen)
                textField.text = NSString(format: "(%@) %@-%@", numero.substring(with: NSMakeRange(0, 2)),numero.substring(with: NSMakeRange(2, hifen - 2)),numero.substring(with: NSMakeRange(hifen, restante))) as String
            } else {
                textField.text = numeroComMascara
            }
        } else {
            //Aviso numero errado
        }
    }
    
    class func mascaraTelefone (textField: UITextField, texto: String?) -> Void {
        
        var numeroComMascara = ""
        
        //Verifica se recebeu um novo texto
        if texto == nil {
            numeroComMascara = textField.text!
        } else {
            numeroComMascara = texto!
        }
        
        // let digitos = NSCharacterSet.decimalDigitCharacterSet().invertedSet as NSCharacterSet
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        
        // let filtro = numeroComMascara.componentsSeparatedByCharactersInSet(digitos) as NSArray
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        var hifen = 6
        let numeroValido = true
        
        
        //Verifica se é celular valido e ajusta a quantidade de digitos
        if tamanho >= 3 {
            let digito = Int(numero.substring(with: NSMakeRange(2,1)))!
            
            if (tamanho > 10) {
                if digito >= 5 {
                    hifen = 7
                }
            }
        }
        
        if numeroValido {
            //Aplica a mascara
            if tamanho == 0 {
                textField.text = ""
            } else if tamanho < 3 {
                textField.text = "(\(numero)"
            } else if tamanho < hifen {
                let restante = tamanho - 2
                textField.text = NSString(format: "(%@) %@", numero.substring(with: NSMakeRange(0, 2)),numero.substring(with: NSMakeRange(2, restante))) as String
            } else if tamanho > hifen {
                let restante = ((tamanho - hifen) > 4 ? 4 : tamanho - hifen)
                textField.text = NSString(format: "(%@) %@-%@", numero.substring(with: NSMakeRange(0, 2)),numero.substring(with: NSMakeRange(2, hifen - 2)),numero.substring(with: NSMakeRange(hifen, restante))) as String
            } else {
                textField.text = numeroComMascara
            }
        }
    }
    
    
    class func mascaraData (textField: UITextField, texto: String?) -> Void {
        
        var numeroComMascara = ""
        
        //Verifica se recebeu um novo texto
        
        if texto == nil {
            
            numeroComMascara = textField.text!
            
        } else {
            
            numeroComMascara = texto!
            
        }
        
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        
        //Aplica a mascara
        if tamanho == 2 || tamanho == 4 {
            
            textField.text = numeroComMascara
            
        } else if tamanho < 2 {
            
            textField.text = numero as String
            
        } else if tamanho < 4 {
            
            let restante = tamanho - 2
            
            textField.text = NSString(format: "%@/%@", numero.substring(with: NSMakeRange(0, 2)),numero.substring(with: NSMakeRange(2, restante))) as String
            
        } else if tamanho > 4 {
            
            //limitar a 11
            
            let restante = ((tamanho - 4) > 4 ? 4 : tamanho - 4)
            
            textField.text = NSString(format: "%@/%@/%@",
                                      numero.substring(with: NSMakeRange(0, 2)),
                                      numero.substring(with: NSMakeRange(2, 2)),
                                      numero.substring(with: NSMakeRange(4, restante))) as String
        } else {
            
            textField.text = ""
            
        }
        
    }
    
    
    class func mascaraCep (textField: UITextField, texto: String?) -> Void {
        
        var numeroComMascara: String = ""
        //Verifica se recebeu um novo texto
        if texto == nil {
            numeroComMascara = textField.text!
        } else {
            numeroComMascara = texto!
        }
        
        // let digitos = NSCharacterSet.decimalDigitCharacterSet().invertedSet as NSCharacterSet
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        
        // let filtro = numeroComMascara.componentsSeparatedByCharactersInSet(digitos) as NSArray
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        //Aplica a mascara
        if tamanho == 5 {
            textField.text = numeroComMascara
        } else if tamanho < 5 {
            textField.text = numero as String
        } else if tamanho > 5 {
            //Limitar em 8 digitos
            let restante = ((tamanho - 5) > 3 ? 3 : tamanho - 5)
            textField.text = NSString(format: "%@-%@", numero.substring(with: NSMakeRange(0, 5)),numero.substring(with: NSMakeRange(5, restante))) as String
        } else {
            textField.text = ""
        }
    }
    
    class func mascaraCVV (textField: UITextField, texto: String?) -> Void {
        
        var numeroComMascara = ""
        
        //Verifica se recebeu um novo texto
        if texto == nil {
            numeroComMascara = textField.text!
        } else {
            numeroComMascara = texto!
        }
        
        let digitos = NSCharacterSet.decimalDigits.inverted as NSCharacterSet
        let filtro = numeroComMascara.components(separatedBy: digitos as CharacterSet) as NSArray
        let numero = filtro.componentsJoined(by: "") as NSString
        let tamanho = numero.length
        
        //Aplica a mascara
        if tamanho == 3 {
            textField.text = numeroComMascara
            textField.resignFirstResponder()
        } else if tamanho < 3 {
            textField.text = numero as String
        } else {
            var text = ""
            text = text + String(Array(textField.text!)[0])
            text = text + String(Array(textField.text!)[1])
            text = text + String(Array(textField.text!)[2])
            textField.text = text
        }
    }
    
    class func mascaraNumeroCartao (texto: NSString) -> String {
        return NSString(format: "%@ **** **** %@", texto.substring(with: NSMakeRange(0, 4)) , texto.substring(with: NSMakeRange(15, 4))) as String
    }
    
    class func mascaraCelular(celular: String) -> String {
        let cel = celular as NSString
        
        if cel.length < 14 {
            return NSString(format: "%@XXX-%@", cel.substring(with: NSMakeRange(0, 5)) , cel.substring(with: NSMakeRange(9, 4))) as String
        }
        return NSString(format: "%@XXXX-%@", cel.substring(with: NSMakeRange(0, 5)) , cel.substring(with: NSMakeRange(10, 4))) as String
    }
    
    class func mascaraEmail (texto: NSString) -> String {
        
        var retorno: NSString = ""
        var flag: Bool = false
        
        let arroba = ("@" as NSString).character(at: 0)
        
        for x in 0...texto.length {
            if(x<3){
                retorno = "\(retorno)\(String(Character(UnicodeScalar(texto.character(at: x))!)))" as NSString
            }else{
                if(texto.character(at: x) == arroba||flag){
                    flag = true
                    retorno = "\(retorno)\(String(Character(UnicodeScalar(texto.character(at: x))!)))" as NSString
                }else{
                    retorno = "\(retorno)*" as NSString
                }
            }
        }
        
        for x in 0...texto.length {
            if(x<3){
                retorno = "\(retorno)\(String(Character(UnicodeScalar(texto.character(at: x))!)))" as NSString
            }else{
                if(texto.character(at: x) == arroba||flag){
                    flag = true
                    retorno = "\(retorno)\(String(Character(UnicodeScalar(texto.character(at: x))!)))" as NSString
                }else{
                    retorno = "\(retorno)*" as NSString
                }
            }
        }
        
        return retorno as String
        
    }
    
    class func mascaraEspacos(texto: NSString) -> String {
        var retorno: NSString = ""
        var flag: Bool = false
        
        let espaco = (" " as NSString).character(at: 0)
        
        for x in 0...texto.length{
            
            if(texto.character(at: x) == espaco && flag){
                flag = false
                retorno = "\(retorno)\(String(Character(UnicodeScalar(texto.character(at: x))!)))" as NSString
            }else if (texto.character(at: x) != espaco){
                flag = true
                retorno = "\(retorno)\(String(Character(UnicodeScalar(texto.character(at: x))!)))" as NSString
            }
        }
        return retorno as String
    }
    
    class func mascaraNomeCartao (texto: NSString) -> String {
        return texto.substring(to: 1) + texto.substring(from: 1).lowercased() as String
    }
    
    class func formataData(string: String) -> String {
        var stringFinal = ""
        stringFinal = stringFinal + String(Array(string)[0])
        stringFinal = stringFinal + String(Array(string)[1])
        stringFinal = stringFinal + "/"
        stringFinal = stringFinal + String(Array(string)[2])
        stringFinal = stringFinal + String(Array(string)[3])
        stringFinal = stringFinal + "/"
        stringFinal = stringFinal + String(Array(string)[4])
        stringFinal = stringFinal + String(Array(string)[5])
        stringFinal = stringFinal + String(Array(string)[6])
        stringFinal = stringFinal + String(Array(string)[7])
        return stringFinal
    }
    
    class func proximoMes(string: String) -> String {
        
        var stringFinal = ""
        stringFinal = stringFinal + String(Array(string)[0])
        stringFinal = stringFinal + String(Array(string)[1])
        stringFinal = stringFinal + String(Array(string)[2])
        
        // var digito: String = "\(string[3])"
        var digito: String = "\(String(Array(string)[3]))"
        
        var mes: Int = Int(digito)!
        mes = mes * 10
        
        // digito = "\(string[4])"
        digito = "\(String(Array(string)[4]))"
        
        mes = mes + Int(digito)!
        if(mes<12){
            mes = mes+1
        }else{
            mes = 1
        }
        
        var mes2: String
        if mes<10{
            mes2 = "0\(mes)"
        }else{
            mes2 = "\(mes)"
        }
        
        stringFinal = stringFinal + String(Array(mes2)[0])
        stringFinal = stringFinal + String(Array(mes2)[1])
        stringFinal = stringFinal + String(Array(string)[5])
        stringFinal = stringFinal + String(Array(string)[6])
        stringFinal = stringFinal + String(Array(string)[7])
        stringFinal = stringFinal + String(Array(string)[8])
        stringFinal = stringFinal + String(Array(string)[9])
        return stringFinal
        
    }
    
    class func formataReal(number : String,simboloMoeda : String) -> String {
        let formatter = NumberFormatter()
        
        if let _number = Float(number){
            
            let numero = NSNumber(value:_number)
            formatter.decimalSeparator = ","
            formatter.numberStyle = NumberFormatter.Style.currencyAccounting
            formatter.currencySymbol = simboloMoeda
            
            if let numeroString = formatter.string(from: numero) {
                return numeroString
            }
            
        }
        
        return ""
    }
    
    class func formataRealNumerico(numero : NSNumber,simboloMoeda : String) -> String {
        
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.numberStyle = NumberFormatter.Style.currencyAccounting
        formatter.currencySymbol = simboloMoeda
        
        if let numeroString = formatter.string(from: numero) {
            return numeroString
        }
        
        return ""
        
    }
    
    class func formataValorReal(string : NSString) -> String {
        
        let entrada = string.replacingOccurrences(of: ",", with: ".") as NSString
        
        var string2 = String(entrada)
        
        var negativo = false
        
        if string2.substring(0,0) == "-"{
            string2 = String(string2.dropFirst())
            negativo = true
        }
        let decimal: NSDecimalNumber = NSDecimalNumber(string: string2)
        
        var retorno = NSString(format: "%.2f", decimal.doubleValue)
        
        retorno = retorno.replacingOccurrences(of: ".", with: ",") as NSString
        
        var retorno2: NSString = ""
        
        for x in 0...2 {
            retorno2 = "\(String(Character(UnicodeScalar(retorno.character(at: retorno.length-x-1))!)))\(retorno2)" as NSString
        }
        
        for y in 3...retorno.length - 1{
            if(((y)%3==0) && (y != 3)){
                retorno2 = ".\(retorno2)" as NSString
            }
            
            retorno2 = "\(String(Character(UnicodeScalar(retorno.character(at: retorno.length-y-1))!)))\(retorno2)" as NSString
            
        }
        
        if negativo {
            retorno2 = "- R$ \(retorno2)" as NSString
        }else{
            retorno2 = "R$ \(retorno2)" as NSString
        }
        
        return retorno2 as String
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    class func limpa( string :String) -> String {
        
        var string = string
        
        string = string.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        string = string.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        string = string.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        string = string.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
        string = string.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        string = string.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        string = string.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        return string
        
    }
    
    class func alertaCliente(titulo : String,mensagem:String, BotaoOk: String){
        
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BotaoOk, style: .default, handler: nil)
        alert.addAction(confirmAction)
    }
    
    class func alertaCliente(titulo : String,mensagem:String, BotaoOk: String, controller: UIViewController){
        
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BotaoOk, style: .default, handler: nil)
        alert.addAction(confirmAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func alertaClienteMensagemCentralAtendimento(titulo : String,mensagem:String,BotaoOk:String, controller: UIViewController) {
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BotaoOk, style: .default, handler: nil)
        alert.addAction(confirmAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func alertaClienteVertical(titulo : String,mensagem:String,BotaoOk:String, controller: UIViewController) {
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BotaoOk, style: .default, handler: nil)
        alert.addAction(confirmAction)
        controller.present(alert, animated: true) {
            alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
        }
    }
    
    // Helper function to convert from RGB to UIColor
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            
            alpha: CGFloat(1.0)
            
        )
        
    }
    
    class func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.cgImage;
        let width = CGFloat(imgRef!.width);
        let height = CGFloat(imgRef!.height);
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        var scaleRatio : CGFloat = 1
        
        if (width > maxResolution || height > maxResolution) {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
            
        }
        
        var transform = CGAffineTransform.identity
        
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef!.width), height: CGFloat(imgRef!.height))
        
        switch(imageSource.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
            
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat(Double.pi) / 2.0)
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * CGFloat(Double.pi) / 2.0)
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat(Double.pi) / 2.0)
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(Double.pi) / 2.0)
            
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            
            context.concatenate(transform)
            
            context.draw(UIGraphicsGetCurrentContext()! as! CGImage, in: CGRect(x: 0, y: 0, width: width, height: height), byTiling: imgRef! as! Bool)
            
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy!
        
    }
    
    
    class func reduzirTamanhoFoto(imagem: UIImage) -> UIImage {
        
        var novaImagem:UIImage = UIImage()
        let largura:CGFloat = 576 // 960 -> 768
        let altura:CGFloat = 768 // 1280 -> 1024
        var novoTamanho:CGSize = CGSize()
        let orientacao = imagem.imageOrientation.rawValue
        
        if orientacao == 2 || orientacao == 3 {
            novoTamanho = CGSize(width: largura, height: altura)
            UIGraphicsBeginImageContext(novoTamanho)
            imagem.draw(in: CGRect(x: 0, y: 0, width: novoTamanho.width, height: novoTamanho.height))
            
        } else {
            novoTamanho = CGSize(width: altura, height: largura)
            UIGraphicsBeginImageContext(novoTamanho)
            imagem.draw(in: CGRect(x: 0, y: 0, width: novoTamanho.width, height: novoTamanho.height))
        }
        
        novaImagem = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Reduzindo a qualidade da imagem
        let dataJpeg = UIImageJPEGRepresentation(novaImagem, 0.8)
        let imagemJpeg = UIImage(data: dataJpeg!)!
        return imagemJpeg
        
    }
    
    class func reduzirTamanhoFotoEmBytes(imagem: UIImage, percentual : CGFloat) -> NSData? {
        var novaImagem:UIImage = UIImage()
        
        let largura:CGFloat = imagem.size.width - (imagem.size.width * (percentual/100.0))
        let altura:CGFloat  = imagem.size.height - (imagem.size.height * (percentual/100.0))
        var novoTamanho:CGSize = CGSize()
        let orientacao = imagem.imageOrientation.rawValue
        if orientacao == 2 || orientacao == 3 {
            
            novoTamanho = CGSize(width: largura, height: altura)
            UIGraphicsBeginImageContext(novoTamanho)
            imagem.draw(in: CGRect(x: 0, y: 0, width: novoTamanho.width, height: novoTamanho.height))
            
        } else {
            
            novoTamanho = CGSize(width: altura, height: largura)
            UIGraphicsBeginImageContext(novoTamanho)
            imagem.draw(in: CGRect(x: 0, y: 0, width: novoTamanho.width, height: novoTamanho.height))
            
        }
        
        novaImagem = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Reduzindo a qualidade da imagem
        return UIImageJPEGRepresentation(novaImagem, 0.98) as NSData?
        
    }
    
    class func defineThumb(image:UIImage, view:UIImageView) -> Void {
        
        let escala = UIScreen.main.scale
        let base:CGFloat = 100
        let thumbSize:CGSize = CGSize(width: base, height: base)
        UIGraphicsBeginImageContextWithOptions(thumbSize, false, escala)
        let orientacao = image.imageOrientation.rawValue
        let tamanhoAjustado:CGFloat = (image.size.height > image.size.width) ? (image.size.width / image.size.height) * base : (image.size.height / image.size.width) * base
        let posicaoAjustada: CGFloat = (base - tamanhoAjustado) / 2
        if orientacao == 2 || orientacao == 3 {
            image.draw(in: CGRect(x: posicaoAjustada, y: 0, width: tamanhoAjustado, height: thumbSize.width))
        } else {
            image.draw(in: CGRect(x: 0, y: posicaoAjustada, width: thumbSize.width, height: tamanhoAjustado))
        }
        view.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    class func base64ImageString(image:UIImage)->String? {
        let tempImg = UIImagePNGRepresentation(image)
        return tempImg!.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0)).base64EncodedString()
    }
    
    class func getVersaoApp() -> String{
        
        //First get the nsObject by defining as an optional anyObject
        let nsObject: Any? = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        return nsObject as! String
        
    }
    
    class func getVersonSO() -> String {
        
        return UIDevice.current.systemVersion
        
    }
    
    class func formataTextos(texto: String, destacandoTexto destaque: String?, nomeFonte: String, tamanhoFonte: CGFloat, strColor: String = "333333") -> NSAttributedString {
        
        let textoString = texto as NSString
        let range = NSMakeRange(0, textoString.length)
        
        let textoFormatado = NSMutableAttributedString(string: String(textoString))
        textoFormatado.addAttribute(NSAttributedStringKey.font, value: UIFont(name: nomeFonte, size: tamanhoFonte)!, range: range)
        textoFormatado.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: strColor), range: range)
        
        if let destaque = destaque {
            
            let corDestaque = UIColor(hexString: strColor)
            let rangeDestaque = textoString.range(of: destaque)
            
            textoFormatado.addAttribute(NSAttributedStringKey.foregroundColor, value: corDestaque, range: rangeDestaque)
            textoFormatado.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Corbert-Bold", size: tamanhoFonte)!, range: rangeDestaque)
            
            
        }
        
        return textoFormatado
        
    }
    
    class func formataTextosMulti(texto: String, destacandoTexto destaques: [String]?, nomeFonte: String, tamanhoFonte: CGFloat) -> NSAttributedString {
        
        let textoString = texto as NSString
        let range = NSMakeRange(0, textoString.length)
        
        let textoFormatado = NSMutableAttributedString(string: String(textoString))
        textoFormatado.addAttribute(NSAttributedStringKey.font, value: UIFont(name: nomeFonte, size: tamanhoFonte)!, range: range)
        textoFormatado.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "333333"), range: range)
        
        if let _destaques = destaques {
            
            for destaque in _destaques {
                
                let corDestaque = UIColor(hexString: "333333")
                let rangeDestaque = textoString.range(of: destaque)
                
                textoFormatado.addAttribute(NSAttributedStringKey.foregroundColor, value: corDestaque, range: rangeDestaque)
                textoFormatado.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Corbert-Bold", size: tamanhoFonte)!, range: rangeDestaque)
                
            }
            
        }
        
        return textoFormatado
        
    }
    
    class func getCurrecyDateString() -> String {
        
        return Util.dataToString(data: NSDate(), toFormat: "yyyy-MM-dd HH:mm:ss")!
        
    }
    
    /**
     Os códigos de país móvel (MCC) são usados ​​em redes telefônicas sem fio (GSM, CDMA, UMTS, etc.) para identificar o país a que um assinante móvel pertence. Para identificar de forma exclusiva uma rede de assinantes móveis, o MCC é combinado com um Código de Rede Móvel (MNC). A combinação de MCC e MNC é chamada de HNI (identidade de rede doméstica) e é a combinação de ambas em uma seqüência de caracteres (por exemplo, MCC = 262 e MNC = 01 resulta em uma HNI de 26201). Se você combina o HNI com o MSIN (número de identificação do assinante móvel), o resultado é o chamado IMSI (identificação de assinante móvel integrado). Abaixo você pode navegar / pesquisar gratuitamente a lista de países e seus MCC para identificar qualquer MCC, MNC ou HNI do mundo.
     
     Para maiores informacoes, acesse http://mcc-mnc.com/
     
     **/
    class func getDadosTelefonia() -> [String : Any] {
        
        var retorno : [String : Any] = [:]
        
        let networkInfo = CTTelephonyNetworkInfo()
        
        let carrier = networkInfo.subscriberCellularProvider
        
        if let _carrier = carrier {
            
            retorno["CARRIER_NAME"] = _carrier.carrierName
            retorno["MOBILE_COUNTRY_CODE"] = _carrier.mobileCountryCode
            retorno["MOBILE_NETWORK_CODE"] = _carrier.mobileNetworkCode
            retorno["ISO_COUNTRY_CODE"] = _carrier.isoCountryCode
            retorno["ALLOWS_VOIP"] = _carrier.allowsVOIP
            retorno["CURRENT_RADIO_ACCESS_TECHNOLOGY"] = networkInfo.currentRadioAccessTechnology
            retorno["MODEL_PHONE"] = UIDevice.current.modelName
            
        }
        
        return retorno
        
    }
    
    // Codigo 724 representa o Brasil, segundo http://mcc-mnc.com/
    class func celularNoBrasil() -> Bool {
        
        let networkInfo = CTTelephonyNetworkInfo()
        
        let carrier = networkInfo.subscriberCellularProvider
        
        if let _carrier = carrier {
            
            if let _mobileCountryCode = _carrier.mobileCountryCode {
                
                if let mobileCountryCodeInt = Int(_mobileCountryCode) {
                    
                    return mobileCountryCodeInt == 724
                    
                }
                
            }
            
        }
        
        return false
        
    }
    
    class func getDicionarioHttpResponse(httpResponse: HTTPURLResponse) -> [String : AnyObject] {
        
        var retorno: [String : AnyObject] = [:]
        
        retorno = httpResponse.allHeaderFields as! [String : AnyObject]
        
        retorno["STATUS_CODE"] = httpResponse.statusCode as AnyObject
        
        return retorno
        
    }
    
    class func getDadosDevice() {
        
        print("#### UUID STRING: \(String(describing: UIDevice.current.identifierForVendor?.uuidString))")
        
        //        UIDevice.current.identifierForVendor
        
    }
    
    
}

internal extension Array {
    func contem(item: Int) -> Bool {
        for it in self {
            if (it as! Int) == item {
                return true
            }
        }
        return false
    }
}

