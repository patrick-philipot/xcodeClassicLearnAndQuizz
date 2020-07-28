//
//  ContentView.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 14/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI
import MediaPlayer
import Combine

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings

    var myTitle = "Classic Quizz"
    let annonce = "Application pour étendre et tester ses connaissances en musique classique."
    
    @State private var isPlaying: Bool = false
   
    var body: some View {
        NavigationView {
            VStack {
                Text(annonce)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding()
                    .background(Color(.systemBlue))
                
                Spacer()
                
                if settings.currentPlaylist != "aucune" {
                    PlayView()
                }
                
                Spacer()
                
                Text("Learn mode \(settings.learnMode ? "On" : "Off")")
                Text("Quizz mode \(settings.quizzMode ? "On" : "Off")")
                Text("Playlist : \(settings.currentPlaylist)")
            }
            .font(.body)
            .navigationBarTitle(Text(myTitle), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink( "Réglages", destination: SettingsView()))
        }.onAppear(perform: {
            self.settings.currentPlaylist = UserDefaults.standard.string(forKey: "currentPlaylist") ?? "Aucune"
            self.settings.MusicPlayer = MPMusicPlayerController.applicationQueuePlayer
            })
            
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("Moving to the background!")
                self.settings.isInBackground = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("Moving back to the foreground!")
                self.settings.isInBackground = false
            }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}

