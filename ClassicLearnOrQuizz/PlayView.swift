//
//  PlayView.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 22/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI

struct PlayView: View {
    // affiche le bouton PLAY/STOP
    // affiche le nom de la chanson courante
    @EnvironmentObject var settings: UserSettings
    @State private var songIndex: Int = 0
    @State private var isPlaying: Bool = false
    
    
    var body: some View {
        VStack {
            if !isPlaying {
                Button(action: {
                    self.isPlaying = true
                    // jouer ou arrêter ?
                    self.isPlaying ? self.playStart() : self.playStop()
                }, label: {
                    Text("PLAY")
                        .font(.title)
                        .foregroundColor(.green)
                })
            }
            if isPlaying {
                Button(action: {
                self.isPlaying = false
                self.playStop()
                }, label: {
                    Text("STOP")
                        .font(.title)
                        .foregroundColor(.red)
                })
            }
//            Button(action: {}, label: {
//                Text("RESUME")
//                    .font(.title)
//                    .foregroundColor(.blue)
//            })
            Text(settings.currentSong)
            Text("IOS 14")
        }
    }
    
    // fonctions
    func playStart() {
        print("playStart")
        settings.stopped = false
        playAllSong(withSettings: settings)
    }
    
    func playStop() {
        print("playStop")
        settings.MusicPlayer?.stop()
        settings.stopped = true
    }
}

struct PlayView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayView().environmentObject(UserSettings())
    }
}
