//
//  PlaylistDetail.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 18/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI
import MediaPlayer


struct PlaylistDetail: View {
    @EnvironmentObject var settings: UserSettings
    var playlistName : String
    
    var body: some View {
        HStack {
            Text(playlistName)
                .foregroundColor(self.settings.currentPlaylist == playlistName ? Color.red : Color.blue)
                
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.settings.currentPlaylist = self.playlistName
            UserDefaults.standard.set(self.playlistName, forKey: "currentPlaylist")
        }    }
}

struct PlaylistDetail_Previews: PreviewProvider {
    static var settings = UserSettings()
    static var previews: some View {
        PlaylistDetail(playlistName: "a playlist name").environmentObject(settings)
    }
}
