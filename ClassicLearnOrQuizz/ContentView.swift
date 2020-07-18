//
//  ContentView.swift
//  ClassicLearnOrQuizz
//
//  Created by patrick philipot on 14/07/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    var myTitle = "Classic Quizz"
    
    let annonce = "Application pour étendre et tester ses connaissances en musique classique."
    
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
                Text("Learn mode \(settings.learnMode ? "On" : "Off")")
                Text("Quizz mode \(settings.quizzMode ? "On" : "Off")")
            }
            .font(.body)
                
            .navigationBarTitle(Text(myTitle), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink( "Réglages", destination: SettingsView()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
