//
//  PlaylistView.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 17/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI
import MediaPlayer

// private var playlists: [MPMediaItemCollection] = []

struct PlaylistView: View {
    @EnvironmentObject var settings: UserSettings
    // @State private var selection: String? = nil
    
    var body: some View {
        VStack {
            List(settings.playlists, id: \.self){ playlist in
                PlaylistDetail(playlistName: playlist.value(forProperty: MPMediaPlaylistPropertyName)! as! String)
            }.navigationBarTitle("Choix de la playlist", displayMode: .inline)
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static let settings = UserSettings()
    static var previews: some View {
        PlaylistView().environmentObject(settings)
    }
}


