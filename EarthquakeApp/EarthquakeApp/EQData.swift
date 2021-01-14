//
//  EQData.swift
//  EarthquakesCodable
//
//  Created by Mobile on 11/4/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import Foundation

struct Geometry:Codable {
    let type:String // eg "Point"
    let coordinates:[Double]  // lon, lat, depth
}

struct Properties:Codable {
    let mag:Double
    let place:String
    let time:Int64 // unix epoch time in milliseconds
}

// **** 
//  For both UIKit and SwiftUI, use an array of
//  these from which to build your master list!
// ****
struct Feature:Codable, Identifiable {
    let properties:Properties
    let geometry:Geometry
    let id = UUID()
}

struct MetaData:Codable {
    let title:String
}

struct EarthquakeData:Codable {
    let features:[Feature]
    let metadata:MetaData
}

