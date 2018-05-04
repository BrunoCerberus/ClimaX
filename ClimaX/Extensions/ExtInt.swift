//
//  ExtInt.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 04/05/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

extension Int {
    static func calculaTempoDeExpiracaoToken(_ dataStringCriacao: String, dataStringExpiracao: String) -> Int {
        let locale = Locale(identifier: "en_US_POSIX")
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let dataCriacao = formatter.date(from: dataStringCriacao) {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let dataExpiracao = formatter.date(from: dataStringExpiracao) {
                return Int(dataExpiracao.timeIntervalSince(dataCriacao))
            }
        }
        
        return 0
    }
    
    func getMesByInt() -> String{
        
        switch self {
        case 1:
            return "Janeiro"
        case 2:
            return "Fevereiro"
        case 3:
            return "Março"
        case 4:
            return "Abril"
        case 5:
            return "Maio"
        case 6:
            return "Junho"
        case 7:
            return "Julho"
        case 8:
            return "Agosto"
        case 9:
            return "Setembro"
        case 10:
            return "Outubro"
        case 11:
            return "Novembro"
        case 12:
            return "Dezembro"
        default:
            return ""
        }
        
    }
    
    func getMesByIntNotCapitalized() -> String{
        
        switch self {
        case 1:
            return "janeiro"
        case 2:
            return "fevereiro"
        case 3:
            return "março"
        case 4:
            return "abril"
        case 5:
            return "maio"
        case 6:
            return "junho"
        case 7:
            return "julho"
        case 8:
            return "agosto"
        case 9:
            return "setembro"
        case 10:
            return "outubro"
        case 11:
            return "novembro"
        case 12:
            return "dezembro"
        default:
            return ""
        }
        
    }
    
    
}
