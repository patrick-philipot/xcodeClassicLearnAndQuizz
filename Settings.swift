//
//  Settings.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 14/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import Foundation
import MediaPlayer

class UserSettings: ObservableObject {
    @Published var quizzMode = true
    @Published var learnMode = true
    
    // playlist en cours
    @Published var currentPlaylist : String = "aucune playlist sélectionnée"
    @Published var playlists: [MPMediaItemCollection] = []
}
