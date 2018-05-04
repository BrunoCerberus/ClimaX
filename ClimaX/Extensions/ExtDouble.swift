//
//  ExtDouble.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 04/05/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

extension Double {
    static func doubleDeString(_ valorString: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencyCode = "R$ "
        
        if let valor = formatter.number(from: valorString) {
            return valor.doubleValue
        }
        
        return nil
    }
    
    func formata() -> String {
        let valorFormatado = self.formataValorMonetario()
        return valorFormatado.replacingOccurrences(of: "R$ ", with: "")
    }
    
    func formataValorMonetario() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencyCode = "R$ "
        
        let valorFormatar = NSNumber(value: self as Double)
        if let valor = formatter.string(from: valorFormatar) {
            return valor
        }
        
        return ""
    }
    
    func formataValorMonetario(simbolo: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencyCode = "R$ "
        
        let valorFormatar = NSNumber(value: self as Double)
        if let valor = formatter.string(from: valorFormatar) {
            let retorno = valor.replacingOccurrences(of: "R$ ", with: "\(simbolo) ")
            return retorno
        }
        
        return ""
    }
    
    func formataTaxaDeJuros() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "pt_BR")
        
        let valorFormatar = NSNumber(value: self as Double)
        if let valor = formatter.string(from: valorFormatar) {
            return "Juros \(valor)% a.m."
        }
        
        return ""
    }
    
    func calculaValorMinimo() -> Double {
        let valorMinimo = self * 0.15
        return valorMinimo
    }
}

