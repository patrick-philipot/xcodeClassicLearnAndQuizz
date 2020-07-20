//
//  ContentView.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 14/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings

    
    var myTitle = "Classic Quizz"
    
    let annonce = "Application pour étendre et tester ses connaissances en musique classique."
    
    @State private var isPlaying: Bool = false
    let musicplayer : MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
    
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
                    Button(action: {
                        self.isPlaying.toggle()
                        // jouer ou arrêter ?
                        self.isPlaying ? self.playQuizz(forPlaylist: self.settings.currentPlaylist) : self.stopQuizz()
                    }, label: {
                        Text(self.isPlaying ? "STOP" : "PLAY")
                            .font(.title)
                            .foregroundColor(.green)
                    })
                }
                
                Spacer()
                
                Text("Learn mode \(settings.learnMode ? "On" : "Off")")
                Text("Quizz mode \(settings.quizzMode ? "On" : "Off")")
                Text("Playlist : \(settings.currentPlaylist)")
            }
            .font(.body)
                
            .navigationBarTitle(Text(myTitle), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink( "Réglages", destination: SettingsView()))
        }
    }
    // mes fonctions
    func playQuizz(forPlaylist name: String) {
        musicplayer.stop()
        // construction d'une requête ramenant un seul morceau
        let query = MPMediaQuery()
        // le prédicat décrit les conditions
        let predicate = MPMediaPropertyPredicate(value: name, forProperty: MPMediaPlaylistPropertyName )
        query.addFilterPredicate(predicate)
        // --------------- songs ?
        let songs : [MPMediaItem] = query.items ?? []
        
        for song in songs {
            print(song.value(forProperty: MPMediaItemPropertyTitle) as! String)
        }
        // ---------------
        
        // passe la requête au player
        musicplayer.setQueue(with: query)
        musicplayer.repeatMode = .none
        musicplayer.play()
    }
    
    func stopQuizz() {
        musicplayer.stop()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}


