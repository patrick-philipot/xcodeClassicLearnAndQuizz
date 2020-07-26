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
//
//MARK playAllSong
// fonction récursive
func playAllSong(forPlaylist name: String, withSettings settings: UserSettings){
    // Joue tous les morceaux de la playlist séquentiellement
    // - avec une annonce avant
    // - avec une annonce après
    //
    print("PlayAllSong")
    let musicplayer : MPMusicPlayerController = settings.MusicPlayer!
    
    // nombre de morceaux à jouer
    // construction d'une requête ramenant tous les morceaux de la playlist
    let query = MPMediaQuery()
    // le prédicat décrit les conditions
    let predicate = MPMediaPropertyPredicate(value: name, forProperty: MPMediaPlaylistPropertyName )
    query.addFilterPredicate(predicate)
    // --------------- récupération des morceaux dans un tableau
    let allsongs : [MPMediaItem] = query.items ?? []
    let songs : [MPMediaItem] = allsongs.shuffled()
    let count = songs.count
    
    // Amelie est un objet de la classe Speaker pour la synthèse vocale
    let amelie = Speaker(voiceID: "com.apple.ttsbundle.Amelie-compact")

    // booléen pour sortir avant la fin
    // passe à Vrai sur l'action du bouton STOP
    let stopPlayAll = false
    
    func ActAndWait( index: Int, step: Int) {
        // index est l'indice d'accès séquentiel aux morceaux de la playlist
        // step décrit l'action à réaliser
        // step = 0 -> lire l'annonce d'intro, puis jouer le morceau
        // step > 0 -> lire l'annonce après

        // nom du morceau à jouer
        var title: String
        
        // sortie avant la fin
        if stopPlayAll == true { return }
        
        // boucle récursive et asynchrone
        switch step {
        case 0 :
            // lire l'annonce de début et jouer le morceau
            // affichage sur la fenêtre
            title = songs[index].value(forProperty: MPMediaItemPropertyTitle) as! String
            // update view
            settings.currentSong = title

            // todoNext est une fonction qui décrit l'action suivante
            // elle sera appelée après la lecture de l'introduction
            // grâce à un timer
            // Préparer le traitement suivant
            amelie.todoNext = {
                let duration: Double = songs[index].value(forKey: MPMediaItemPropertyPlaybackDuration) as! TimeInterval

                // équivalent d'un timer asynchrone
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    // pour lire l'annonce après
                    ActAndWait(index: index, step: 1)
                }
                // lancer après délai
                // obtenir le ID persistent du morceau (ne dépend pas de la playlist)
                let selectedItem: NSNumber = songs[index].value(forKey: MPMediaItemPropertyPersistentID) as! NSNumber
                
                print("MPMediaItemPropertyPersistentID \(selectedItem)")
                
                musicplayer.stop()
                // construction d'une requête ramenant un seul morceau
                let query = MPMediaQuery()
                // le prédicat décrit les conditions
                let predicate = MPMediaPropertyPredicate(value: selectedItem, forProperty: MPMediaItemPropertyPersistentID )
                query.addFilterPredicate(predicate)
                // passe la requête au player
                musicplayer.setQueue(with: query)
                musicplayer.repeatMode = .none
                musicplayer.play()
                
            }
            // traitement immédiat
            // lire l'annonce intro
            // readText appellera todoNext() quand le texte aura été lu (didFinish)
            amelie.readText(someText: "Vous allez entendre. Un extrait de. \(title)")
            
            
        default :
            // lire l'annonce de fin
            // préparer le traitement suivant
            amelie.todoNext = {
                // jouer le morceau suivant
                let n = index + 1
                if n < count {
                    ActAndWait(index: n, step: 0)
                }
                
            }
            // traitement immédiat
            title = songs[index].value(forProperty: MPMediaItemPropertyTitle) as! String
            // lire l'annonce de fin
            // readText appellera todoNext() quand le texte aura été lu (didFinish)
            amelie.readText(someText: "Vous avez écouté. Un extrait de. \(title)")
        }
    } // func
    
    // lance le traitement du premier morceau
    ActAndWait(index: 0, step: 0)
    
}

//func ios_playSong(atIndex sIndex: Int) {
//    // le morceau à jouer
//    // obtenir le ID persistent du morceau (ne dépend pas de la playlist)
//    let selectedItem: NSNumber = songs[sIndex].value(forKey: MPMediaItemPropertyPersistentID) as! NSNumber
//
//    print("MPMediaItemPropertyPersistentID \(selectedItem)")
//
//    musicplayer.stop()
//    // construction d'une requête ramenant un seul morceau
//    let query = MPMediaQuery()
//    // le prédicat décrit les conditions
//    let predicate = MPMediaPropertyPredicate(value: selectedItem, forProperty: MPMediaItemPropertyPersistentID )
//    query.addFilterPredicate(predicate)
//    // passe la requête au player
//    musicplayer.setQueue(with: query)
//    musicplayer.repeatMode = .none
//    musicplayer.play()
//}





//func playQuizz(forPlaylist name: String, withSettings settings: UserSettings) {
//    var songName: String = ""
//
//    // detecting and of playing song
//    let trackChangedObserver : AnyObject?
//
//    // Amelie est un objet de la classe Speaker pour la synthèse vocale
//    let amelie = Speaker(voiceID: "com.apple.ttsbundle.Amelie-compact")
//
//    let musicplayer : MPMusicPlayerController = settings.MusicPlayer!
//
//
//    trackChangedObserver = NotificationCenter.default
//        .addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
//        object: nil, queue: OperationQueue.main) { (notification) -> Void in
//            updateTrackInformation()
//    }
//
//    musicplayer.beginGeneratingPlaybackNotifications()
//
//
//    musicplayer.stop()
//    // construction d'une requête ramenant tous les morceaux de la playlist
//    let query = MPMediaQuery()
//    // le prédicat décrit les conditions
//    let predicate = MPMediaPropertyPredicate(value: name, forProperty: MPMediaPlaylistPropertyName )
//    query.addFilterPredicate(predicate)
//
//    // --------------- récupération des morceaux dans un tableau
//    let songs : [MPMediaItem] = query.items ?? []
//    songName = songs[0].value(forProperty: MPMediaItemPropertyTitle) as! String
//
//    // song ID
//    let songID = songs[0].value(forProperty: MPMediaItemPropertyPersistentID)
//    let query2 = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)])
//
//    // test settings
//    settings.currentSong = songName
//
//    // amelie.readText(someText: songName)
//    // passe la requête au player
//    musicplayer.setQueue(with: query)
//    musicplayer.repeatMode = .none
//    musicplayer.play()
//
//    func stopQuizz() {
//        musicplayer.endGeneratingPlaybackNotifications()
//        musicplayer.stop()
//    }
//
//    func updateTrackInformation() {
//        print("updateTrackInformation")
//
//        // print(musicplayer.nowPlayingItem?.title ?? "no song")
//        if let mediaItem = musicplayer.nowPlayingItem {
//          print(String(mediaItem.persistentID))
//            print(musicplayer.indexOfNowPlayingItem)
//        }
//
//    }
//}
//
//
//func playQuizz2(forPlaylist name: String, withSettings settings: UserSettings) {
//    var songName: String = ""
//
//    // detecting and of playing song
//    let trackChangedObserver : AnyObject?
//    var currentSongIndex: Int = 0
//
//    // Amelie est un objet de la classe Speaker pour la synthèse vocale
//    let amelie = Speaker(voiceID: "com.apple.ttsbundle.Amelie-compact")
//
//    let musicplayer : MPMusicPlayerController = settings.MusicPlayer!
//
//
//    trackChangedObserver = NotificationCenter.default
//        .addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
//        object: nil, queue: OperationQueue.main) { (notification) -> Void in
//            updateTrackInformation()
//    }
//
//    musicplayer.beginGeneratingPlaybackNotifications()
//
//
//    musicplayer.stop()
//    // construction d'une requête ramenant tous les morceaux de la playlist
//    let query = MPMediaQuery()
//    // le prédicat décrit les conditions
//    let predicate = MPMediaPropertyPredicate(value: name, forProperty: MPMediaPlaylistPropertyName )
//    query.addFilterPredicate(predicate)
//
////    // --------------- récupération des morceaux dans un tableau
////    let songs : [MPMediaItem] = query.items ?? []
////    songName = songs[0].value(forProperty: MPMediaItemPropertyTitle) as! String
////
////    // song ID
////    let songID = songs[0].value(forProperty: MPMediaItemPropertyPersistentID)
////    let query2 = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)])
////
////    // test settings
////    settings.currentSong = songName
//
//    // amelie.readText(someText: songName)
//    // passe la requête au player
//    musicplayer.setQueue(with: query)
//    musicplayer.repeatMode = .none
//    musicplayer.shuffleMode = .off
//    musicplayer.play()
//
//    func stopQuizz() {
//        musicplayer.endGeneratingPlaybackNotifications()
//        musicplayer.stop()
//    }
//
//    func updateTrackInformation() {
//        var newIndex: Int
//        var songTitle: String
//        print("updateTrackInformation")
//
//        // print(musicplayer.nowPlayingItem?.title ?? "no song")
//        if let mediaItem = musicplayer.nowPlayingItem {
//            songTitle = mediaItem.title!
//            print(songTitle)
//            newIndex = musicplayer.indexOfNowPlayingItem
//            if newIndex != currentSongIndex {
//                musicplayer.pause()
//                currentSongIndex = newIndex
//                amelie.todoNext = {
//                    print("amelie did speak")
//                    musicplayer.play()
//                    print("after play")
//                }
//                amelie.readText(someText: songTitle)
//            }
//        }
//    }
//}
