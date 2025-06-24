//
//  SwiftUIView.swift
//  Radio City
//
//  Created by praveen hiremath on 15/06/25.
//


import SwiftUI
import AVKit
import AVFoundation
import ModernSlider

struct RadioPlayerView: View {
    
    @StateObject private var playerManager = RadioPlayerManager("")
    @State private var isPlaying = false
    @State private var volume: Double = 0.9
    @State private var currentTime = Date.getCurrentTime()
    @State private var currentFM = "Radio Suno Melody"
    @State private var showMenu = false
    @Binding var presentSideMenu: Bool
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 10) {
                HStack {
                    Button{
                        presentSideMenu.toggle()
                        print("Side Menu Toggled")
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(-10)
                Text("Radio")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Image(systemName: "music.note.list")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                
                Text(currentFM)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(currentTime)
                    .font(.system(size: 26, weight: .bold, design: .monospaced))
                    .padding()
                    .onReceive(timer) { _ in
                        currentTime = Date.getCurrentTime()
                    }
                
                ModernSlider("",
                             systemImage: "speaker.wave.2.fill",
                             sliderHeight: 20,
                             value: $volume,
                             in: 0...1,
                             onChange: { newValue in
                },
                             onChangeEnd: { finalValue in
                    self.volume = finalValue
                    playerManager.player?.volume = Float(finalValue)
                }
                )
                
                // Playback Buttons
                HStack(spacing: 30) {
                    
                    Button(action: {
                        if isPlaying {
                            playerManager.pauseRadio()
                        } else {
                            playerManager.playRadio()
                        }
                        isPlaying.toggle()
                    }) {
                        Image(systemName: "play.fill")
                            .font(.title)
                            .padding()
                            .background(!isPlaying == true ? Color.pink : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .disabled(isPlaying)
                    
                    Button(action: {
                        if isPlaying {
                            playerManager.pauseRadio()
                        } else {
                            playerManager.playRadio()
                        }
                        isPlaying.toggle()
                    }) {
                        Image(systemName: "pause.fill")
                            .font(.title)
                            .padding()
                            .background(isPlaying == true ? Color.orange : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .disabled(!isPlaying)
                }
                
                // Recently Played
                Text("Your FM List")
                    .font(.headline)
                    .padding(.top)
                let radioList = playerManager.getReadioList()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(radioList) { station in
                            VStack {
                                Button(action: {
                                    playerManager.changeStream(to: station.url, volume: volume)
                                    playerManager.playRadio()
                                    currentFM = station.station
                                }) {
                                    Image(systemName: station.imageName)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding()
                                        .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
                                        .cornerRadius(15)
                                }
                                Text(station.radioName)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Text(station.station)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 100)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.pink, .blue, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            .onAppear {
                playerManager.changeStream(to: "https://25083.live.streamtheworld.com/RADIO_SUNO_MELODY_S06.mp3", volume: volume)
            }
           
        }
    }
}

class RadioPlayerManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var currentURL: String?
    @Published var volume : Double = 0.9
    
    init(_ url: String) {
        self.currentURL = url
        setupPlayer(with: url, volume: volume)
    }
    
    func setupPlayer(with url: String, volume: Double) {
        guard let streamURL = URL(string: url) else { return }
        player = AVPlayer(url: streamURL)
        self.player?.volume = Float(volume)
    }
    
    func playRadio() {
        player?.play()
        isPlaying = true
    }
    
    func pauseRadio() {
        player?.pause()
        isPlaying = false
    }
    
    func changeStream(to newURL: String, volume: Double) {
        player = nil
        isPlaying = false
        currentURL = nil
        currentURL = newURL
        setupPlayer(with: newURL, volume: volume)
    }
    
    func getReadioList() -> [RadioModel] {
        return [
            RadioModel(imageName: "music.quarternote.3",
                       radioName: "Kannada FM",
                       station: "Suno Melody",
                       url: "https://25083.live.streamtheworld.com/RADIO_SUNO_MELODY_S06.mp3"),
            RadioModel(imageName: "music.microphone.circle.fill",
                       radioName: "Hindi FM",
                       station: "Vividh Bharati",
                       url: "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8"),
            RadioModel(imageName: "radio",
                       radioName: "Radio City",
                       station: "91.1 FM",
                       url: "https://stream.zeno.fm/pxc55r5uyc9uv"),
            RadioModel(imageName: "music.note.tv",
                       radioName: "Radio Mirchi",
                       station: "98.3 FM",
                       url: "https://18093.live.streamtheworld.com/NJS_HIN_ESTAAC/HLS/5b01b0d3-75bc-4d43-8908-ed743ed30007/0/playlist.m3u8"),
            RadioModel(imageName: "apple.haptics.and.music.note",
                       radioName: "Radio Mango",
                       station: "91.9 FM",
                       url: "https://eu10.fastcast4u.com/clubfmuae"),
            RadioModel(imageName: "music.mic",
                       radioName: "Air FM Gold",
                       station: "खरा सोना (Real Gold)",
                       url: "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio005/hlspbaudio005_Auto.m3u8"),
            RadioModel(imageName: "music.note",
                       radioName: "Raagam Radio",
                       station: "Anytime Indian",
                       url: "https://uk2.internet-radio.com/proxy/desiradio?mp=/stream"),
            RadioModel(imageName: "antenna.radiowaves.left.and.right",
                       radioName: "Namm Radio",
                       station: "Kannada Kelo Majaane Bere",
                       url: "https://stream.zeno.fm/6quh1pfnt1duv"),
            RadioModel(imageName: "dot.radiowaves.left.and.right",
                       radioName: "All India Radio",
                       station: "AIR Dharwad",
                       url: "https://air.pc.cdn.bitgravity.com/air/live/pbaudio150/playlist.m3u8")
        ]
    }
}


struct RadioModel : Identifiable {
    let id = UUID()
    let imageName: String
    let radioName: String
    let station: String
    let url: String
    
}


struct RadioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RadioPlayerView(presentSideMenu: .constant(true))
        
    }
}

extension Date {
    static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}
