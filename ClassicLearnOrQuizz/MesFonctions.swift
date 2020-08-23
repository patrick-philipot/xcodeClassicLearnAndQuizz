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
// #MARK playAllSong
// fonction récursive
func playAllSong(withSettings settings: UserSettings){
    // Joue tous les morceaux de la playlist séquentiellement
    // - avec une annonce avant
    // - avec une annonce après
    //
    print("PlayAllSong")
    let musicplayer : MPMusicPlayerController = settings.MusicPlayer!
    let name : String = settings.currentPlaylist
    
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
    var stopPlayAll = false
    
    func ActAndWait( index: Int, step: Int) {
        // index est l'indice d'accès séquentiel aux morceaux de la playlist
        // step décrit l'action à réaliser
        // step = 0 -> lire l'annonce d'intro, puis jouer le morceau
        // step > 0 -> lire l'annonce après

        // nom du morceau à jouer
        var title: String
        
        if settings.isInBackground {
            print("ActAndWait l'app est passée en background")
            print("index = \(index), step = \(step)")
        }
        
        
        // sortie avant la fin
        if stopPlayAll == true {
            print("stopPlayAll est vrai")
            return
        }
        
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
            // détecter la mise en arrière plan
            if settings.isInBackground {
                print("ActAndWait passage en arrière plan détecté avant annonce début")
            } else {
                // lire l'annonce intro
                // readText appellera todoNext() quand le texte aura été lu (didFinish)
                if settings.learnMode {
                    amelie.readText(someText: "Vous allez entendre. Un extrait de. \(title)")
                } else {
                    amelie.readText(someText: "Écoutez et retrouvez l'oeuvre et l'auteur")
                }
            }

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
            // détecter la mise en arrière plan
            if settings.isInBackground {
                print("ActAndWait passage en arrière plan détecté avant annonce fin")
            } else {
                title = songs[index].value(forProperty: MPMediaItemPropertyTitle) as! String
                // lire l'annonce de fin
                // readText appellera todoNext() quand le texte aura été lu (didFinish)
                amelie.readText(someText: "Vous avez écouté. Un extrait de. \(title)")
            }
        }
    } // func
    
    // lance le traitement du premier morceau
    ActAndWait(index: 0, step: 0)
    
}

