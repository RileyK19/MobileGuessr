//
//  ContentView.swift
//  Change++Challenge
//
//  Created by Riley Koo on 9/9/24.
//

import SwiftUI
import CoreLocation
import MapKit

let timeLimit = 180

struct ContentView: View {
    @SceneStorage("HighScore") var highScore: Double = 0
    
    @State private var locations: [Mark] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.7128,
            longitude: -74.0060
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 180,
            longitudeDelta: 360
        )
    )
    @State private var question = Question()
    @State private var displayMap: Bool = false
    @State private var reset: Bool = true
    @State private var dist: Double = 0
    @State private var score: Double = 0
    @State private var lastScore: Double = 0
    @State private var questionNum: Int = 7
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = timeLimit
    @State var startToggle = false

    var body: some View {
        if dist == -1 {
            VStack {
                Text("WHERE IS THIS??")
                    .font(.title)
                Spacer()
                    .frame(height: 60)
                HStack {
                    Spacer()
                        .frame(width: 10)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 200, height: 70)
                            .foregroundStyle(Color.black.opacity(0.7))
                        VStack {
                            Text("Current Score: \(score, specifier:  "%.2f")")
                                .foregroundStyle(.white)
                            Spacer()
                                .frame(height: 10)
                            Text("High Score: \(highScore, specifier:  "%.2f")")
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 150, height: 45)
                                .foregroundStyle(Color.black.opacity(0.7))
                            Text("Time: \(timeRemaining) s")
                                .foregroundStyle(.white)
                                .frame(width: 100)
                                .onReceive(timer) { time in
                                    guard startToggle else { return }
                                    
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                    }
                                }
                                .onChange(of: timeRemaining) {
                                    if timeRemaining == 0 && startToggle {
                                        self.startToggle.toggle()
                                        
                                        timeRemaining = timeLimit
                                        
                                        questionNum += 1
                                        dist = 50000
                                        startToggle.toggle()
                                    }
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 150, height: 45)
                                .foregroundStyle(Color.black.opacity(0.7))
                            Text("Question: \(questionNum+1) / 5")
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                        .frame(width: 10)
                }
                Spacer()
                    .frame(height: 10)
                AsyncImage(url: question.url)
                Spacer()
                    .frame(height: 15)
                Button {
                    displayMap = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 150, height: 35)
                            .foregroundStyle(Color.black.opacity(0.7))
                        Text("Display Map")
                            .foregroundStyle(.white)
                    }
                }
            }
            .popover(isPresented: $displayMap, content: {
                ZStack {
                    ZStack {
                        Map(coordinateRegion: $region, annotationItems: locations) { location in
                            MapAnnotation(
                                coordinate: location.coordinate,
                                anchorPoint: CGPoint(x: 0.5, y: 0.7)
                            ) {
                                VStack{
                                    if location.show {
                                        Text("Test")
                                    }
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            let index: Int = locations.firstIndex(where: {$0.id == location.id})!
                                            locations[index].show.toggle()
                                        }
                                }
                            }
                        }
                        Circle()
                            .fill(Color.blue)
                            .opacity(0.3)
                            .frame(width: 32, height: 32)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    //locations.append(Mark(coordinate: region.center))
                                    question.userAnswer = Coordinate(longitude: region.center.longitude, latitude: region.center.latitude)
                                    displayMap = false
                                    dist = question.dist()
                                    lastScore = calcScore(dist)
                                    score += lastScore
                                    questionNum += 1
                                    reset = true
                                    
                                    startToggle.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(20)
                            }
                        }
                    }
                    .ignoresSafeArea()
                    VStack {
                        Spacer()
                            .frame(height: 10)
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            Button {
                                displayMap = false
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 75, height: 35)
                                        .foregroundStyle(Color.black.opacity(0.7))
                                    Text("Close")
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
            })
        } else if questionNum <= 6 {
            VStack (spacing: 10) {
                Text("Score: \(score-lastScore, specifier: "%.2f") + \(lastScore, specifier: "%.2f")")
                Text("Distance: \(dist, specifier: "%.2f") km")
                Text("Answer: \(question.ansLoc)")
                Text("Question: \(questionNum) / 5")
                Button {
                    if questionNum <= 5 {
                        question = Question()
                        if questionNum == 5 {
                            questionNum += 10
                            highScore = highScore < score ? score : highScore
                        }
                        else {
                            dist = -1
                            
                            startToggle.toggle()
                            timeRemaining = timeLimit
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 75, height: 35)
                            .foregroundStyle(Color.black.opacity(0.7))
                        Text("Next")
                            .foregroundStyle(.white)
                    }
                }
            }
        } else {
            VStack {
                Spacer()
                    .frame(height: 100)
                ZStack {
                    HStack {
                        Spacer()
                            .frame(width: 200)
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .rotationEffect(.degrees(22.5))
                            .foregroundStyle(.red)
                            .opacity(0.75)
                    }
                    Text("MobileGuessr")
                        .font(.title)
                        .bold()
                }
                Spacer()
                Text("High Score: \(highScore, specifier: "%.2f")")
                    .font(.title2)
                    .bold()
                Spacer()
                    .frame(height: 50)
                if score != 0 {
                    Text("Score: \(score, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                    Spacer()
                        .frame(height: 50)
                }
                Button {
                    
                    locations = []
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: 40.7128,
                            longitude: -74.0060
                        ),
                        span: MKCoordinateSpan(
                            latitudeDelta: 180,
                            longitudeDelta: 360
                        )
                    )
                    question = Question()
                    displayMap = false
                    reset = true
                    dist = -1
                    score = 0
                    lastScore = 0
                    questionNum = 0
                    
                    startToggle.toggle()
                    timeRemaining = timeLimit
                } label: {
                    Text("Start")
                        .bold()
                }
                Spacer()
                    .frame(height: 50)
                Spacer()
            }
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Mark: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var show = false
}
func calcScore(_ x: Double) -> Double {
    return 5000 * exp(-x/2000)
}
