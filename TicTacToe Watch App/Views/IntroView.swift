//
//  IntroView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import SwiftUI

/// Vista de introducción con animación del logo
struct IntroView: View {
    /// Acción a ejecutar cuando finaliza la intro
    var onComplete: () -> Void
    
    /// Estados para la animación
    @State private var showFirstText = false
    @State private var showSecondText = false
    @State private var showThirdText = false
    
    var body: some View {
        ZStack {
            // Fondo con degradado
            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Logo animado
            VStack(spacing: 5) {
                // Título con animación secuencial
                Text("TIC")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(showFirstText ? 1 : 0)
                    .scaleEffect(showFirstText ? 1 : 0.8)
                
                Text("TAC")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(showSecondText ? 1 : 0)
                    .scaleEffect(showSecondText ? 1 : 0.8)
                
                Text("TOE")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(showThirdText ? 1 : 0)
                    .scaleEffect(showThirdText ? 1 : 0.8)
            }
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
        }
        .onAppear {
            // Iniciar la secuencia de animaciones
            withAnimation(.easeInOut(duration: 0.4).delay(0.2)) {
                showFirstText = true
            }
            
            withAnimation(.easeInOut(duration: 0.4).delay(0.6)) {
                showSecondText = true
            }
            
            withAnimation(.easeInOut(duration: 0.4).delay(1.0)) {
                showThirdText = true
            }
            
            // Programar el fin de la intro después de la animación
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onComplete()
            }
        }
    }
}

/// Vista previa para el diseñador de SwiftUI
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(onComplete: {})
    }
} 