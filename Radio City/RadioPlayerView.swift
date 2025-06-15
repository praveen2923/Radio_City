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
    
    @StateObject private var playerManager = RadioPlayerManager()
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    @State private var volume: Double = 0.5
    
    @State private var currentTime = Self.getCurrentTime()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            Text("Vividh Bharati  FM")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(currentTime)
                .font(.system(size: 36, weight: .bold, design: .monospaced))
                .padding()
                .onReceive(timer) { _ in
                    currentTime = Self.getCurrentTime()
                }
            
            ModernSlider(
                "Volume",
                systemImage: "speaker.wave.2.fill",
                value: $volume,
                in: 0...1,
                onChange: { newValue in
                    //  self.volume
                    // Nothinf Do On Chnage
                },
                onChangeEnd: { finalValue in
                    self.volume = finalValue
                    self.player?.volume = Float(finalValue)
                }
            )
            
            // Playback Buttons
            HStack(spacing: 30) {
                
                Button(action: {
                    if isPlaying {
                        pauseRadio()
                    } else {
                        playRadio()
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
                        pauseRadio()
                    } else {
                        playRadio()
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(["Kannada FM", "Hindi FM", "Marati FM", "Telagu FM"], id: \.self) { station in
                        VStack {
                            Image(systemName: "music.quarternote.3")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(15)
                            
                            Text(station)
                                .font(.subheadline)
                            Text("00.00")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 100)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(.white)
        .onAppear {
            let url = URL(string: "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8")!
            self.player = AVPlayer(url: url)
            self.player?.volume = Float(self.volume)
        }
    }
    
    
    func playRadio() {
        player?.play()
    }
    
    func pauseRadio() {
        player?.pause()
    }
    
    static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

class RadioPlayerManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    
    init() {
        let url = URL(string: "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8")!
        player = AVPlayer(url: url)
    }
    
    func playRadio() {
        player?.play()
        isPlaying = true
    }
    
    func pauseRadio() {
        player?.pause()
        isPlaying = false
    }
}

struct RadioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RadioPlayerView()
    }
}

// "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8"
// http://peridot.streamguys.com:7150/Mirchi
