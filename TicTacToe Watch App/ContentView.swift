//
//  ContentView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import SwiftUI

/// Vista principal de la aplicación
struct ContentView: View {
    /// Estado para controlar la navegación inicial
    @State private var showingIntro = true
    
    var body: some View {
        if showingIntro {
            // Vista de introducción que muestra el logo animado
            IntroView(onComplete: {
                withAnimation {
                    showingIntro = false
                }
            })
        } else {
            // Una vez finalizada la intro, mostrar el menú principal
            MenuView()
        }
    }
}

#Preview {
    ContentView()
}