//
//  ExtDate.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 04/05/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

extension Date {
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    static func utilizaRelogio24Horas() -> Bool {
        let local = Locale.current
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: local)!
        return formatter.range(of: "a") == nil
    }
    
    func stringDeData(formato f: String) -> String {
        let local = Locale(identifier: "en_US_POSIX")
        
        let formatter = DateFormatter()
        formatter.locale = local
        formatter.dateFormat = f
        
        return formatter.string(from: self)
    }
    
    
    // Componentes
    // Dia da semana
    func diaDaSemana() -> Int {
        let components = (Calendar.current as NSCalendar).components(.weekday, from: self)
        return components.weekday!
    }
    // Dia
    func dia() -> Int {
        let components = (Calendar.current as NSCalendar).components(.day, from: self)
        return components.day!
    }
    // Mês
    func mes() -> Int {
        let components = (Calendar.current as NSCalendar).components(.month, from: self)
        return components.month!
    }
    // Ano
    func ano() -> Int {
        let components = (Calendar.current as NSCalendar).components(.year, from: self)
        return components.year!
    }
    
    
    // Compõe hora atual
    func now() -> Date? {
        let calendar = Calendar.current
        var date = (calendar as NSCalendar).components([.day, .month, .year], from: self)
        let hour = (calendar as NSCalendar).components([.hour, .minute], from: Date())
        date.hour = hour.hour
        date.minute = hour.minute
        
        return calendar.date(from: date)
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
    func dias(para data: Date) -> ComparisonResult {
        return (Calendar.current as NSCalendar).compare(data, to: self, toUnitGranularity: .day)
    }
    
    // Fórmulas matemáticas
    // Diferença em dias entre datas
    //    func dias(para data: NSDate) -> Int {
    //        return NSCalendar.currentCalendar().components([.Day], fromDate: data, toDate: self, options: []).day //.dateComponents([.day], from: data, to: self).day ?? 0
    //    }
    
    // Diferença em meses entre datas
    func meses(para data: Date) -> Int {
        return (Calendar.current as NSCalendar).components([.month], from: data, to: self, options: []).month!
    }
    // Diferença em anos entre datas
    func anos(para data: Date) -> Int {
        return (Calendar.current as NSCalendar).components([.year], from: data, to: self, options: []).year!
    }
    // Diferença em horas entre datas
    func horas(para data: Date) -> Int {
        return (Calendar.current as NSCalendar).components([.hour], from: data, to: self, options: []).hour!
    }
    // Diferença em minutos entre datas
    func minutos(para data: Date) -> Int {
        return (Calendar.current as NSCalendar).components([.minute], from: data, to: self, options: []).minute!
    }
    // Diferença em segundos entre datas
    func segundos(para data: Date) -> Int {
        return (Calendar.current as NSCalendar).components([.second], from: data, to: self, options: []).second!
    }
    // Diferença em semanas entre datas
    func semanas(para data: Date) -> Int {
        return (Calendar.current as NSCalendar).components([.weekOfYear], from: data, to: self, options: []).weekOfYear!
    }
    
    
}

