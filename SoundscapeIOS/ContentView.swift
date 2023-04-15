//
//  ContentView.swift
//  ReactiveSoundscape
//
//  Created by Renas Ali on 15/04/2023.
//

import SwiftUI
import CoreLocation
import AVFoundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last
    }
}

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var homeLocation = CLLocation(latitude: 52.8021 , longitude: 5.6999)
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            
            Spacer()
            if let userLocation = locationManager.userLocation {
                let distance = userLocation.distance(from: homeLocation) / 1000
                Text(String(format: "Distance: %.2f km", distance))
                    .font(.title)
                    .foregroundColor(.black)
            } else {
                Text("Calculating distance...")
                    .font(.title)
                    .foregroundColor(.black)
            }
            Spacer()
            Button(action: {
                if let player = audioPlayer {
                    if player.isPlaying {
                        player.stop()
                        isPlaying = false
                    } else {
                        player.play()
                        isPlaying = true
                    }
                } else {
                    var fileName = ""
                    if let userLocation = locationManager.userLocation {
                        let distance = userLocation.distance(from: homeLocation) / 1000
                        switch distance {
                        case 0..<5:
                            fileName = "super1"
                        case 5..<10:
                            fileName = "super2"
                        case 10..<15:
                            fileName = "super3"
                        case 15..<20:
                            fileName = "super4"
                        default:
                            fileName = "super1"
                        }
                    }
                    guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                        audioPlayer?.play()
                        isPlaying = true
                    } catch let error {
                        print("Error playing music: \(error.localizedDescription)")
                    }
                }
            }) {
                if isPlaying {
                    Text("Stop Music")
                        .foregroundColor(.white)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 15)
                        .background(Color.red)
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 435)
                } else {
                    Text("Play Music")
                        .foregroundColor(.white)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 435)
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
