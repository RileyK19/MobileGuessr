//
//  ContentView.swift
//  Change++Challenge
//
//  Created by Riley Koo on 9/9/24.
//

import SwiftUI
import CoreLocation
import MapKit

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
    @State private var score: Double = 0
    @State private var lastScore: Double = 0
    @State private var questionNum: Int = 7
    
    @State private var startQuestion: Bool = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = timeLimit
    @State private var startToggle = false
    
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if startQuestion {
            VStack {
                ZStack {
                    Rectangle()
                        .frame(width: 5000, height: 100)
                        .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.35) : Color.black.opacity(0.35))
                    Text("WHERE IS THIS??")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                }
                Spacer()
                    .frame(height: 45)
                HStack {
                    Spacer()
                        .frame(width: 10)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 200, height: 70)
                            .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.35) : Color.black.opacity(0.35))
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
                                .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.35) : Color.black.opacity(0.35))
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
                                        question.dist = 50000
                                        startQuestion = false
                                        startToggle.toggle()
                                    }
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 150, height: 45)
                                .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.35) : Color.black.opacity(0.35))
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
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 175, height: 65)
                            .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        Text("Display Map")
                            .font(.title3)
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
                                    question.setUserAnswer(c: Coordinate(longitude: region.center.longitude, latitude: region.center.latitude))
                                    lastScore = question.score
                                    score += question.score
                                    displayMap = false
                                    questionNum += 1
                                    reset = true
                                    
                                    startQuestion = false
                                    
                                    startToggle.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding()
                                .background((colorScheme == . dark) ?  Color.white.opacity(0.7) : Color.black.opacity(0.7))
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
                                        .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.7) : Color.black.opacity(0.7))
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
                Text("Distance: \(question.dist, specifier: "%.2f") km")
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
                            startQuestion = true
                            
                            startToggle.toggle()
                            timeRemaining = timeLimit
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 75, height: 35)
                            .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.7) : Color.black.opacity(0.7))
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
                    Rectangle()
                        .frame(width: 5000, height: 100)
                        .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.5) : Color.black.opacity(0.5))
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
                        .foregroundStyle(.white)
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
                    score = 0
                    lastScore = 0
                    questionNum = 0
                    
                    startQuestion = true
                    
                    startToggle.toggle()
                    timeRemaining = timeLimit
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 150, height: 50)
                            .foregroundStyle((colorScheme == . dark) ?  Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        Text("Start")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .bold()
                    }
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
