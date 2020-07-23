//
//  Speaker.swift
//  SQuiz
//
//  Created by patrick philipot on 15/04/2020.
//  Copyright © 2020 patrick philipot. All rights reserved.
//

import Foundation
import AVFoundation

class Speaker:NSObject, AVSpeechSynthesizerDelegate {
    static let synthesizer = AVSpeechSynthesizer()
    var voiceID: String?
    var todoNext = {() -> Void in}
    
    init(voiceID: String){
        super.init()
        self.voiceID = voiceID
        if Speaker.synthesizer.delegate == nil {
            Speaker.synthesizer.delegate = self
        }
    }
    
    func readText(someText: String) {
        let speakUtterance = AVSpeechUtterance(string: someText)
        speakUtterance.voice = AVSpeechSynthesisVoice(identifier: self.voiceID!)
        speakUtterance.preUtteranceDelay = 1.0
        Speaker.synthesizer.speak(speakUtterance)
        // le delegate interceptera le didFinish pour lancer la fonction todoNext
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // lance le prochain traitement quand le texte a été entièrement lu.
        todoNext()
    }
    
} // class
