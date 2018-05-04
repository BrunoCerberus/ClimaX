//
//  ExtString.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 04/05/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

extension String {
    
    //    func slice(from: String, to: String) -> String? {
    //
    //        return (range(of: from)?.upperBound).flatMap { substringFrom in
    //            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
    //                substring(with: substringFrom..<substringTo)
    //            }
    //        }
    //    }
    
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    //MARK: extensoes gerais string
    
    // TRIM
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    // SUBSTRING
    func substring(_ from: Int?, _ to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0 && end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from, nil)
    }
    
    func substringTo(_ to: Int) -> String {
        return self.substring(nil, to)
    }
    
    func substringFrom(_ from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from, end)
    }
    
    
    // FORMATING
    func removeFormatacao() -> String {
        
        // return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: self.indices)
        return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
        
    }
    
    func removeFormatacaoValorMonetario() -> String {
        if self == "" { return "0" }
        return self.removeFormatacao()
    }
    
    func formataCpfCnpj() -> String {
        
        if self == "" {
            return ""
        }
        
        if self.count == 11 {
            let cpf1 = self.substring(0, 2)
            let cpf2 = self.substring(3, 5)
            let cpf3 = self.substring(6, 8)
            let cpf4 = self.substring(9, 11)
            
            return "\(cpf1).\(cpf2).\(cpf3)-\(cpf4)"
            
        } else {
            
            let cnpj1 = self.substring(0, 1)
            let cnpj2 = self.substring(2, 4)
            let cnpj3 = self.substring(5, 7)
            let cnpj4 = self.substring(8, 11)
            let cnpj5 = self.substring(12, 13)
            
            return "\(cnpj1).\(cnpj2).\(cnpj3)/\(cnpj4)-\(cnpj5)"
            
        }
        
    }
    
    func primeirasMaiusculas() -> String {
        var novoString = ""
        let preposicoes = ["de", "da", "das", "do", "dos", "para", "por", "no", "nos", "na", "nas", "que", "em"]
        
        if self.isEmpty {
            return novoString
        }
        
        let palavras = self.components(separatedBy: " ")
        for palavra in palavras {
            if let _ = preposicoes.index(of: palavra.trim().lowercased()) {
                novoString += "\(palavra.lowercased()) "
                continue
            }
            
            novoString += "\(palavra.capitalized) "
        }
        
        return novoString.trim()
    }
    
    func aesEncrypt(_ key: String /*, iv: String */) throws -> String {
        let data = self.data(using: String.Encoding.utf8)
        
        // let enc = try AES(key: key, iv: "0000000000000000", blockMode:.CBC).encrypt(data!.bytes)
        let enc = try AES(key: key, iv: "0000000000000000").encrypt(data!.bytes)
        
        let encData = Data(bytes: enc, count: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let result = String(base64String)
        
        return result
    }
    
    func aesDecrypt(_ key: String /* , iv: String */) throws -> String {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        // let dec = try AES(key: key, iv: "0000000000000000", blockMode:.CBC).decrypt(data!.bytes)
        let dec = try AES(key: key, iv: "0000000000000000").decrypt(data!.bytes)
        
        let decData = Data(bytes: dec, count: Int(dec.count))
        let result = NSString(data: decData, encoding: String.Encoding.utf8.rawValue)
        return String(result!)
    }
    
    init(dict: [String: AnyObject]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            if let dataString = String(data: data, encoding: String.Encoding.utf8) {
                self = dataString
            } else {
                self = ""
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            self = ""
        }
    }
    
    func toArray() -> [String] {
        let string = self.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "'", with: "\"").replacingOccurrences(of: "\"", with: "")
        return string.components(separatedBy: ",")
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isAlphanumericAndSpace: Bool {
        return !isEmpty && range(of: "/ˆ[-_ a-zA-Z0-9]+$/", options: .regularExpression) == nil
        //        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var parseJSONString: Any? {
        let jsonString = self.replacingOccurrences(of: "'", with: "\"")
        let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
            } catch let error as NSError {
                print("Error parsing JSON: \(error.description)")
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
    
    var detectaData: [Date]? {
        do {
            return try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue).matches(in: self, options: [], range: NSMakeRange(0, (self as NSString).length)).flatMap{ $0.date }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func isCpf() -> Bool {
        
        let valor = self
        
        if (valor.isVazio()) {
            return false
        }
        
        let cpf = valor.filter{"0123456789".contains($0)}
        if cpf.count == 11 {
            
            if (valor == "00000000000" || valor == "11111111111" || valor == "22222222222" ||
                valor == "33333333333" || valor == "44444444444" || valor == "55555555555" ||
                valor == "66666666666" || valor == "77777777777" || valor == "88888888888" ||
                valor == "99999999999"
                ) {
                return false
            }
            
            var digitTen = (Int(String(cpf[9])) ?? 0)
            var digitEleven = (Int(String(cpf[10])) ?? 0)
            
            var resultModuleOne: Int = 0, resultModuleTwo: Int = 0, realValue: Int = 0
            var i: Int = 0, j: Int = 11
            for index in 0..<cpf.count-1 {
                realValue = (Int(String(cpf[index])) ?? 0)
                resultModuleTwo += (realValue * j)
                
                if (i > 0) {
                    realValue = (Int(String(cpf[index-1])) ?? 0)
                    resultModuleOne += (realValue * j)
                }
                
                i += 1; j -= 1;
            }
            
            resultModuleOne %= 11
            resultModuleOne = resultModuleOne < 2 ? 0 : resultModuleOne-11
            
            resultModuleTwo %= 11
            resultModuleTwo = resultModuleTwo < 2 ? 0 : resultModuleTwo-11
            
            resultModuleOne = resultModuleOne < 0 ? resultModuleOne * -1 : resultModuleOne
            digitTen        = digitTen < 0 ? digitTen * -1 : digitTen
            resultModuleTwo = resultModuleTwo < 0 ? resultModuleTwo * -1 : resultModuleTwo
            digitEleven     = digitEleven < 0 ? digitEleven * -1 : digitEleven
            
            if (resultModuleOne == digitTen && resultModuleTwo == digitEleven) {
                return true
            }
        }
        
        return false
        
    }
    
    func isCnpj() -> Bool {
        
        return false
        
    }
    
    func isEmail() -> Bool {
        
        if !self.isVazio(){
            
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            // verificando se email e valido a partir da expressao regular
            if emailTest.evaluate(with: self) {
                
                let dominiosInvalidos = ["temporarioemail.com.br",
                                         "rmqkr.net",
                                         "mailinator.com",
                                         "spamfree24.org",
                                         "tempemail.net",
                                         "jourrapide.com",
                                         "teleworm.com",
                                         "dayrep.com",
                                         "rhyta.com",
                                         "armyspy.com",
                                         "drdrb.com",
                                         "mcalc.com",
                                         "dialog.zzn.com",
                                         "mkalc.com",
                                         "yopmail.com",
                                         "sharklasers.com",
                                         "mailmetrash.com",
                                         "mailexpire.com",
                                         "jetable.org",
                                         "maileater.com"]
                
                var dominio = ""
                
                // encontrando dominio do email
                for (key,char) in self.enumerated() {
                    
                    if char == "@" {
                        
                        dominio = self.substring(with: (self.index(self.startIndex, offsetBy: key + 1) ..< self.index(self.endIndex, offsetBy: 0)))
                        // dominio = String(describing: (self.index(self.startIndex, offsetBy: key + 1) ..< self.index(self.endIndex, offsetBy: 0)))
                    }
                    
                }
                
                return !dominiosInvalidos.contains(dominio)
                
            }
            
            return false
            
        }
        
        return false
        
    }
    
    func isVazio() -> Bool {
        
        return self.trim().count == 0
        
    }
    
    func convertStringForNsdate() -> NSDate{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dataConvertida = dateFormatter.date(from: self) {
            
            return dataConvertida as NSDate
            
        }
        
        return NSDate()
        
    }
    
    func convertStringForBRFormat() -> String {
        
        if let retorno: Date = self.dataEHoraDeString(formato: "yyyy-MM-dd") {
            
            return retorno.stringFromDateBR()
            
        }
        
        return  ""
        
    }
    
    //MARK: manipulacao e formatacao de codigo de barra
    fileprivate func somaAlgarismos(_ num: Int) -> Int {
        if num < 10 {
            return num
        }
        
        var numero = num
        var soma = 0
        while ((numero/10) > 0) {
            soma += numero % 10
            numero = numero / 10
        }
        
        soma += numero
        return soma
    }
    
    fileprivate func calculaDigitoComModulo11(_ numero: String) -> Int {
        var soma = 0
        let multiplicadores = [2, 3, 4, 5, 6, 7, 8, 9]
        
        let lenght = numero.count
        var indexMulti = 0
        for index in (0 ..< lenght).reversed() {
            soma += Int(numero.substring(index, index))! * multiplicadores[indexMulti % 8]
            indexMulti += 1
        }
        
        let resto = soma % 11
        if resto >= 0 && resto <= 1 {
            return 0
        } else if resto == 10 {
            return 1
        }
        
        return 11 - resto
    }
    
    fileprivate func calculaDigitoComModulo10(_ numero: String) -> Int {
        var soma = 0
        let multiplicadores = [2, 1]
        
        let lenght = numero.count
        var indexMulti = 0
        for index in (0 ..< lenght).reversed() {
            soma += somaAlgarismos(Int(numero.substring(index, index))! * multiplicadores[indexMulti % 2])
            indexMulti += 1
        }
        
        let resto = soma % 10
        if resto == 0 {
            return 0
        }
        
        return 10 - resto
    }
    
    func linhaDigitavelConvenio() -> String {
        
        if self.count == 44 {
            let cb1 = self.substring(0, 10)
            let cb2 = self.substring(11, 21)
            let cb3 = self.substring(22, 32)
            let cb4 = self.substring(33, 43)
            let identificacao = self.substring(2, 2)
            
            if identificacao == "6" || identificacao == "7" {
                return "\(cb1)\(calculaDigitoComModulo10(cb1))\(cb2)\(calculaDigitoComModulo10(cb2))\(cb3)\(calculaDigitoComModulo10(cb3))\(cb4)\(calculaDigitoComModulo10(cb4))"
            }
            
            return "\(cb1)\(calculaDigitoComModulo11(cb1))\(cb2)\(calculaDigitoComModulo11(cb2))\(cb3)\(calculaDigitoComModulo11(cb3))\(cb4)\(calculaDigitoComModulo11(cb4))"
        }
        
        let cb1 = "\(self.substring(0,10))-\(self.substring(11,11))"
        let cb2 = "\(self.substring(12,22))-\(self.substring(23,23))"
        let cb3 = "\(self.substring(24,34))-\(self.substring(35,35))"
        let cb4 = "\(self.substring(36,46))-\(self.substring(47,47))"
        
        return "\(cb1) \(cb2) \(cb3) \(cb4)"
        
    }
    
    func linhaDigitavelTitulo() -> String {
        
        if self.count == 44 {
            
            let cb1 = "\(self.substring(0, 3))\(self.substring(19, 23))"
            let cb2 = self.substring(24, 33)
            let cb3 = self.substring(34, 43)
            let cb4 = self.substring(4, 4)
            let cb5 = self.substring(5, 18)
            
            return "\(cb1)\(calculaDigitoComModulo10(cb1))\(cb2)\(calculaDigitoComModulo10(cb2))\(cb3)\(calculaDigitoComModulo10(cb3))\(cb4)\(cb5)"
            
        }
        
        return self
        
    }
    
    //MARK: data e hora
    func dataEHoraDeString(formato f: String) -> Date? {
        // let local = NSLocale(localeIdentifier: "en_US_POSIX")
        
        let formatter = DateFormatter()
        // formatter.locale = local
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        formatter.isLenient = true
        formatter.dateFormat = f
        
        if let date = formatter.date(from: self) {
            return date
        }
        
        return nil
    }
    
    // Data
    func dateFromString() -> Date? {
        return self.dataEHoraDeString(formato: "yyyy-MM-dd")
    }
    
    // Hora
    func hourFromString() -> Date? {
        return self.dataEHoraDeString(formato: "HH:mm")
    }
    
    
    func semMascara() -> String {
        let components = self.components(separatedBy: NSCharacterSet(charactersIn: "1234567890").inverted)
        return components.joined(separator: "")
    }
    
    func adicionaMascaraConta() -> String {
        
        let strLenght = self.count
        
        if strLenght == 0 || strLenght == 1 {
            
            return self
            
        } else if strLenght == 2 {
            
            return self.replacingOccurrences(of: "-", with: "")
            
        } else {
            
            let contaLimpo = self.replacingOccurrences(of: "-", with: "")
            
            return "\(contaLimpo.substring(0, contaLimpo.count - 2))-\(contaLimpo.substring(contaLimpo.count - 1, contaLimpo.count))"
            
            
        }
        
    }
    
    var floatValue: Float {
        
        return (self as NSString).floatValue
        
    }
    
    //MARK: retornar o primeiro trecho de uma cadeia de caracteres. Procura por espaco vazio
    func getPrimeiroTrecho() -> String {
        
        var first: String = ""
        
        for char in self {
            
            if char == " "{
                break
            }
            
            first = "\(first)\(char)"
            
        }
        
        return first
        
    }
    
    func formataNome() -> String {
        
        var first: Bool = true
        
        var nome: String = ""
        
        for char in self {
            
            if first {
                nome = char.description.uppercased()
                first = false
            } else {
                nome = "\(nome)\(char.description.lowercased())"
            }
        }
        
        return nome
        
    }
    
    func convertDataBrForNSDate() -> NSDate! {
        
        var retorno: NSDate!
        
        if !self.isVazio() {
            
            let dia: String = self.substring(0, 1)
            let mes: String = self.substring(3, 4)
            let ano: String = self.substring(6, 9)
            let data: String = "\(ano)-\(mes)-\(dia)"
            
            retorno = data.dateFromString()
            
        }
        
        return retorno!
        
    }
    
    func convertCurrentValueForDouble() -> Double! {
        
        var retorno: Double!
        
        if let _doubleValue = Double(self.replacingOccurrences(of: "R$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").trim()) {
            retorno = _doubleValue
        }
        
        return retorno
        
    }
    
    func senhaValida() -> Bool{
        
        if !self.isVazio() {
            
            let letters = CharacterSet.letters
            
            let digits = CharacterSet.decimalDigits
            
            var letterCount = 0
            
            var digitCount = 0
            
            // verificando ocorrencias de letras e numeros
            for uni in self.unicodeScalars {
                
                if letters.contains(uni) {
                    
                    letterCount += 1
                    
                } else if digits.contains(uni) {
                    
                    digitCount += 1
                    
                }
                
            }
            
            // procurando por espacos
            let qtEspaco = self.components(separatedBy: " ").count
            
            return letterCount > 0 && digitCount > 0 && qtEspaco == 1
            
        }
        
        return false
        
    }
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    func dropLast(_ n: Int = 1) -> String {
        return String(dropLast(n))
    }
    
    func dropFirst(_ n: Int = 1) -> String {
        return String(dropFirst(n))
    }
    
    var dropLast: String {
        return dropLast()
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func dataEHoraDeString(formato f: String) -> NSDate? {
        
        // let local = NSLocale(localeIdentifier: "en_US_POSIX")
        
        let formatter = DateFormatter()
        // formatter.locale = local
        formatter.dateStyle = DateFormatter.Style.long
        formatter.dateStyle = DateFormatter.Style.none
        
        formatter.isLenient = true
        formatter.dateFormat = f
        
        if let date = formatter.date(from: self) {
            return date as NSDate
        }
        
        return nil
        
    }
    
    // Data
    func dateFromString() -> NSDate? {
        return self.dataEHoraDeString(formato: "yyyy-MM-dd")
    }
    
    // Hora
    func hourFromString() -> NSDate? {
        return self.dataEHoraDeString(formato: "HH:mm")
    }
}

extension NSDate {
    static func utilizaRelogio24Horas() -> Bool {
        let local = NSLocale.current
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: local)!
        return formatter.range(of: "a") == nil
    }
    
    func stringDeData(formato f: String) -> String {
        let local = NSLocale(localeIdentifier: "en_US_POSIX")
        
        let formatter = DateFormatter()
        formatter.locale = local as Locale?
        formatter.dateFormat = f
        
        return formatter.string(from: self as Date)
    }
    
    
    // Componentes
    // Dia da semana
    func diaDaSemana() -> Int {
        let components = (NSCalendar.current as NSCalendar).components(.weekday, from: self as Date)
        return components.weekday!
    }
    // Dia
    func dia() -> Int {
        let components = (NSCalendar.current as NSCalendar).components(.day, from: self as Date)
        return components.day!
    }
    // Mês
    func mes() -> Int {
        let components = (NSCalendar.current as NSCalendar).components(.month, from: self as Date)
        return components.month!
    }
    // Ano
    func ano() -> Int {
        let components = (NSCalendar.current as NSCalendar).components(.year, from: self as Date)
        return components.year!
    }
    
    
    // Compõe hora atual
    func now() -> NSDate? {
        let calendar = NSCalendar.current
        var date = (calendar as NSCalendar).components([.day, .month, .year], from: self as Date)
        let hour = (calendar as NSCalendar).components([.hour, .minute], from: NSDate() as Date)
        date.hour = hour.hour
        date.minute = hour.minute
        // return calendar.dateComponents(date)
        return calendar.date(from: date) as NSDate?
    }
    
    
    // Data para String
    // String Data
    func stringFromDate() -> String {
        return self.stringDeData(formato: "yyyy-MM-dd")
    }
    
    func stringFromDateBR() -> String {
        return self.stringDeData(formato: "dd/MM/yyyy")
    }
    // String Hora
    func stringFromHour() -> String {
        return self.stringDeData(formato: "HH:mm")
    }
    
    
    // Fórmulas matemáticas
    // Diferença em dias entre datas
    func dias(para data: NSDate) -> ComparisonResult {
        return NSCalendar.current.compare(data as Date, to: self as Date, toGranularity: .day)
    }
    
}
