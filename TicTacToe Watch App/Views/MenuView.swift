//
//  MenuView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import SwiftUI

/// Vista del menú principal del juego
struct MenuView: View {
    /// ViewModel para el menú
    @StateObject private var viewModel = MenuViewModel()
    
    /// Gestiona la presentación del selector de dificultad
    @State private var showingDifficultyPicker = false
    
    // Tipo de destino para la navegación
    enum NavigationDestination: Hashable {
        case game(GameViewModel)
        
        // Implementación de Hashable
        func hash(into hasher: inout Hasher) {
            switch self {
            case .game(let viewModel):
                // Usamos el puntero de memoria del ViewModel como hash
                hasher.combine(ObjectIdentifier(viewModel))
            }
        }
        
        // Implementación de Equatable
        static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
            switch (lhs, rhs) {
            case (.game(let lvm), .game(let rvm)):
                return ObjectIdentifier(lvm) == ObjectIdentifier(rvm)
            }
        }
    }
    
    // Estado para el destino de navegación
    @State private var navigationPath = NavigationPath()
    
    /// Gestor de retroalimentación háptica
    private let hapticManager = HapticManager()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(spacing: 15) {
                    // Título
                    Text("TIC TAC TOE")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Botón juego contra IA
                    Button {
                        hapticManager.playHaptic(for: .selection)
                        showingDifficultyPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "cpu")
                            Text("Jugar vs IA")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                    // Botón juego dos jugadores
                    Button {
                        hapticManager.playHaptic(for: .selection)
                        viewModel.selectedMode = .twoPlayer
                        let gameViewModel = viewModel.createGameViewModel()
                        navigationPath.append(NavigationDestination.game(gameViewModel))
                    } label: {
                        HStack {
                            Image(systemName: "person.2")
                            Text("Dos Jugadores")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    
                    // Agregar espacio flexible para empujar botones hacia abajo
                    Spacer()
                    .frame(height: 10)
                    
                    // Botones "¿Cómo jugar?" y "Creador" lado a lado
                    HStack(spacing: 10) {
                        // Botón "¿Cómo jugar?"
                        Button {
                            hapticManager.playHaptic(for: .selection)
                            viewModel.showHowToPlay = true
                        } label: {
                            VStack {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 20))
                                Text("Ayuda")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        .layoutPriority(1)
                        
                        // Botón "Creador"
                        Button {
                            hapticManager.playHaptic(for: .selection)
                            viewModel.showCreator = true
                        } label: {
                            VStack {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 20))
                                Text("Acerca de")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        .layoutPriority(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .game(let gameViewModel):
                    GameView(
                        viewModel: gameViewModel,
                        onBackToMenu: { 
                            navigationPath.removeLast()
                        }
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
            .scrollIndicators(.visible)
            .background(
                LinearGradient(
                    colors: [Color.black.opacity(0.8), Color.black.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            // Modal para seleccionar la dificultad
            .sheet(isPresented: $showingDifficultyPicker) {
                difficultyPicker
            }
            // Modal para "¿Cómo jugar?"
            .sheet(isPresented: $viewModel.showHowToPlay) {
                howToPlayView
            }
            // Modal para "Creador"
            .sheet(isPresented: $viewModel.showCreator) {
                creatorView
            }
        }
    }
    
    /// Vista del selector de dificultad
    private var difficultyPicker: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Selecciona dificultad")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top)
                
                // Botón para cada nivel de dificultad
                ForEach([GameMode.singlePlayerEasy, .singlePlayerMedium, .singlePlayerHard]) { mode in
                    Button {
                        hapticManager.playHaptic(for: .selection)
                        viewModel.selectedMode = mode
                        showingDifficultyPicker = false
                        let gameViewModel = viewModel.createGameViewModel()
                        navigationPath.append(NavigationDestination.game(gameViewModel))
                    } label: {
                        HStack {
                            Image(systemName: viewModel.icon(for: mode))
                            Text(mode.description)
                                .font(.system(size: 15))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(viewModel.color(for: mode))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Botón para cerrar el selector
                Button("Cancelar") {
                    showingDifficultyPicker = false
                }
                .padding(.top, 5)
                
                Spacer()
            }
            .padding()
        }
        .scrollIndicators(.visible)
        .background(Color.black.opacity(0.9))
    }
    
    /// Vista de "¿Cómo jugar?"
    private var howToPlayView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("¿Cómo jugar?")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 5)
                
                Group {
                    Text("1. El juego se desarrolla en un tablero de 3x3.")
                    
                    Text("2. Dos jugadores por turnos marcan los espacios vacíos.")
                    
                    Text("3. El jugador que logre colocar tres de sus marcas en línea horizontal, vertical o diagonal gana.")
                    
                    Text("4. Si se llenan todas las casillas sin que haya un ganador, el juego termina en empate.")
                }
                .font(.system(size: 15))
                
                Spacer()
                
                Button("Cerrar") {
                    viewModel.showHowToPlay = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)
            }
            .padding()
        }
        .scrollIndicators(.visible)
        .background(Color.black.opacity(0.9))
    }
    
    /// Vista de "Creador"
    private var creatorView: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 15) {
                Text("Creador")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 5)
                
                Text("Desarrollado por:")
                    .font(.system(size: 15))
                
                Text("Michell Alexis Policarpio Moran")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text("© 2025")
                    .font(.system(size: 14))
                    .padding(.top, 5)
                
                Spacer()
                
                Button("Cerrar") {
                    viewModel.showCreator = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)
            }
            .padding()
        }
        .scrollIndicators(.visible)
        .background(Color.black.opacity(0.9))
    }
}

/// Estilo personalizado para los botones del menú
struct MenuButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .background(configuration.isPressed ? color.opacity(0.7) : color)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Vista previa para el diseñador de SwiftUI
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
} 