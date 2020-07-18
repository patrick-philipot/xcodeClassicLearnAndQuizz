//
//  settingsView.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 14/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct SettingsView: View {
    @EnvironmentObject var settings: UserSettings
    
    let infos = "Chaque morceau de la playlist doit inclure un titre indiquant le nom de l'oeuvre et son auteur"
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Mode : Quizz / Learn")
                    .font(.headline)){
                        Toggle(isOn: $settings.quizzMode ) {
                            Text("Test (Quizz)")
                        }
                        Toggle(isOn: $settings.learnMode ) {
                            Text("Apprentissage (Learn)")
                        }
                }
                Section(header: Text("Playlist de musique classique")
                    .font(.headline)) {
                        Text(infos)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                            .background(Color(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)))
                            .cornerRadius(10)
                        NavigationLink("\(settings.currentPlaylist)", destination: PlaylistView())
                }
            }.navigationBarTitle(Text("Réglages"), displayMode: .inline)
        }.onAppear(perform: {
            self.settings.playlists = getPlaylists()
            
        })
    }
}

struct settingsView_Previews: PreviewProvider {
    static let settings = UserSettings()
    static var previews: some View {
        SettingsView()
        .environmentObject(settings)
    }
}

func getPlaylists() -> [MPMediaItemCollection]{
    print("getPlaylists")
    let query: MPMediaQuery = MPMediaQuery.playlists()
    let playlists = query.collections ?? []
    // print(playlists?.description)
    for playlist in playlists{
        // print(playlist.value(forProperty: MPMediaPlaylistPropertyName)!)
        print(playlist.value(forProperty: MPMediaPlaylistPropertyName)! as! String)
    }
    return playlists
}
