//
//  TempoCodable.swift
//  ClimaX
//
//  Created by Bruno Lopes de Mello on 28/04/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Welcome: Codable {
    let id: Int
    let name, state, country: String
    let data: [Datum]
}

struct Datum: Codable {
    let date, dateBr: String
    let humidity: Humidity
    let rain: Rain
    let wind: Wind
    let uv: Uv
    let thermalSensation: Humidity
    let textIcon: TextIcon
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateBr = "date_br"
        case humidity, rain, wind, uv
        case thermalSensation = "thermal_sensation"
        case textIcon = "text_icon"
        case temperature
    }
}

struct Humidity: Codable {
    let min, max: Int
}

struct Rain: Codable {
    let probability, precipitation: Int
}

struct Temperature: Codable {
    let min, max: Int
    let morning, afternoon, night: Humidity
}

struct TextIcon: Codable {
    let icon: Icon
    let text: Text
}

struct Icon: Codable {
    let dawn, morning, afternoon, night: String
    let day, reduced: String?
}

struct Text: Codable {
    let pt: String
    let en, es: String?
    let phrase: Icon
}

struct Uv: Codable {
    let max: Int
}

struct Wind: Codable {
    let velocityMin, velocityMax, velocityAvg: Int
    let gustMax: Double
    let directionDegrees: Int
    let direction: String
    
    enum CodingKeys: String, CodingKey {
        case velocityMin = "velocity_min"
        case velocityMax = "velocity_max"
        case velocityAvg = "velocity_avg"
        case gustMax = "gust_max"
        case directionDegrees = "direction_degrees"
        case direction
    }
}
