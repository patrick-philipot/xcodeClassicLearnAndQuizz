//
//  MesFonctions.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 23/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import Foundation
import MediaPlayer

// Cette fonction bloquait la preview ?
//
func getPlaylists(thatIncludeInName theString :String) -> [MPMediaItemCollection]{
    // retourne toutes les playlists dont le nom commence par "Classic"
    let noCloudPre = MPMediaPropertyPredicate(
        value: NSNumber(value: false),
      forProperty: MPMediaItemPropertyIsCloudItem
    )
    let query: MPMediaQuery = MPMediaQuery.playlists()
    // -----------
    query.addFilterPredicate(noCloudPre)
    query.addFilterPredicate(MPMediaPropertyPredicate(
      value: theString,
      forProperty: MPMediaPlaylistPropertyName,
      comparisonType: MPMediaPredicateComparison.contains
    ))
    // -----------
    let playlists :[MPMediaItemCollection] = query.collections ?? []
    return playlists
}

    // mes fonctions
    func playQuizz(forPlaylist name: String) {
        var songName: String = ""

        // Amelie est un objet de la classe Speaker pour la synthèse vocale
        let amelie = Speaker(voiceID: "com.apple.ttsbundle.Amelie-compact")
        
        let musicplayer : MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
        musicplayer.stop()
        // construction d'une requête ramenant tous les morceaux de la playlist
        let query = MPMediaQuery()
        // le prédicat décrit les conditions
        let predicate = MPMediaPropertyPredicate(value: name, forProperty: MPMediaPlaylistPropertyName )
        query.addFilterPredicate(predicate)
        
        // --------------- récupération des morceaux dans un tableau
        let songs : [MPMediaItem] = query.items ?? []
        songName = songs[0].value(forProperty: MPMediaItemPropertyTitle) as! String

        amelie.readText(someText: songName)
        // passe la requête au player
        musicplayer.setQueue(with: query)
        musicplayer.repeatMode = .none
        musicplayer.play()
        
        func stopQuizz() {
            musicplayer.stop()
        }
        
    }
    

