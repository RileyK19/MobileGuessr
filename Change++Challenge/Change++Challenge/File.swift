//
//  File.swift
//  Change++Challenge
//
//  Created by Riley Koo on 9/9/24.
//

let radius = 99999999
let timeLimit = 180

import Foundation
import MapKit

struct Coordinate
{
    var longitude: Double
    var latitude: Double
}

class Question
{
    var rightAnswer: Coordinate
    var userAnswer: Coordinate?
    var url: URL?
    var ansLoc: String
    var dist: Double
    var score: Double
    init() {
        dist = -1
        score = -1
        ansLoc = ""
        rightAnswer = Coordinate(longitude: 0, latitude: 0)
        let tmp = parseUrl(url: URL(string: "https://api.3geonames.org/?randomland=yes")!)
        rightAnswer = tmp.0
        ansLoc = tmp.1
        
        userAnswer = nil
        url = makeURL(rightAnswer.latitude, rightAnswer.longitude)
    }
    func getMetadata() async throws -> Int {
        if (url != nil) {
            var md: Metadata
            let (data, _) = try await URLSession.shared.data(from: url!)
            md = try JSONDecoder().decode(Metadata.self, from: data)
            if (md.error_message != "OK") {
                return -1
            }
            return 0
        }
        return -1
    }
    func generate() {
        rightAnswer = Coordinate(longitude: 0, latitude: 0)
        rightAnswer.latitude = Double.random(in: -90...90)
        rightAnswer.longitude = Double.random(in: -180...180)
        userAnswer = nil
        url = makeURL(rightAnswer.latitude, rightAnswer.longitude)
    }
    func getRandom() async throws {
        var rd: RandomData = RandomData(nearest: RandomData.nearest(latt: 0, longt: 0))
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.3geonames.org/?randomland=yes")!)
            rd = try JSONDecoder().decode(RandomData.self, from: data)
        } catch {
            print("Invalid data")
        }
        rightAnswer.longitude = rd.nearest.longt
        rightAnswer.latitude = rd.nearest.latt
        url = makeURL(rightAnswer.latitude, rightAnswer.longitude)
    }
    func calcDist() -> Double {
        if userAnswer == nil {
            return -1
        }
        let rightAnsPrime = degToKm(rightAnswer)
        let userAnsPrime = degToKm(userAnswer!)
        return abs(sqrt(square(rightAnsPrime.latitude - userAnsPrime.latitude) + square(rightAnsPrime.longitude - userAnsPrime.longitude)))
    }
    private func square(_ x: Double) -> Double {
        return x * x
    }
    func setUserAnswer(c: Coordinate) {
        userAnswer = c
        dist = calcDist()
        score = calcScore(dist)
    }
}

func makeURL(_ lat : Double, _ long : Double) -> URL? {
    return URL(string: "https://maps.googleapis.com/maps/api/streetview?location=\(lat),\(long)&size=600x400&key=AIzaSyB9FYnKmGT9K2SABpZ9XQXPZv8ZWhRY_8U&radius=\(radius)&fov=180")
}

struct Metadata: Codable {
    let error_message: String
    let status: String
}

struct RandomData: Codable {
    struct nearest: Codable {
        let latt: Double
        let longt: Double
    }
    let nearest: nearest
}

func parseUrl(url: URL) -> (Coordinate, String) {
    var ret: Coordinate = Coordinate(longitude: -1, latitude: -1)
    let str = urlToStr(url: url)
    var retStr = ""
    if str != "" {
        var latt = str.components(separatedBy: "<latt>")
        
        if latt.count < 2 {
            return parseUrl(url: url)
        }
        
        latt = latt[1].components(separatedBy: "</latt>")
        var longt = str.components(separatedBy: "<longt>")
        longt = longt[1].components(separatedBy: "</longt>")
        ret.latitude = Double(latt[0]) ?? -1
        ret.longitude = Double(longt[0]) ?? -1
        
        var city = str.components(separatedBy: "<city>")
        city = city[1].components(separatedBy: "</city>")
        var country = str.components(separatedBy: "<state>")
        country = country[1].components(separatedBy: "</state>")
        
        retStr += "\(city[0]), \(country[0])"
        
    }
    return (ret, retStr)
}

func urlToStr(url: URL) -> String {
    var str: String = ""
    do {
        let contents = try String(contentsOf: url)
        str = contents
    } catch {
        print("Invalid URL")
    }
    return str
}

func degToKm(_ a : Coordinate) -> Coordinate {
    let lat = a.latitude * 110.574
    let long = a.longitude * (111.320 * cos(lat))
    let ret = Coordinate(
        longitude: long,
        latitude: lat)
    return ret
}

func calcScore(_ x: Double) -> Double {
    return 5000 * exp(-x/2000)
}
