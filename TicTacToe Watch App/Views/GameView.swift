//
//  GameView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran
//

import SwiftUI

/// Vista principal del juego de Tres en Raya
struct GameView: View {
    /// ViewModel que gestiona la lógica del juego
    @ObservedObject var viewModel: GameViewModel
    
    /// Acción para volver al menú principal
    var onBackToMenu: () -> Void
    
    /// Gestor de retroalimentación háptica
    private let hapticManager = HapticManager()
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack(spacing: 0) {
                    // Cabecera con información del turno actual
                    header
                        .id("top") // ID para desplazamiento hacia arriba
                    
                    // Tablero de juego
                    gameBoard
                    
                    // Controles inferiores
                    if viewModel.gameOver {
                        gameOverControls
                            .id("gameOver")
                    } else {
                        gameControls
                    }
                }
                .padding(0)
                .onChange(of: viewModel.gameOver) { oldValue, newValue in
                    if newValue == true {
                        // Esperar 1.5 segundos antes de desplazar hacia abajo
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                scrollView.scrollTo("gameOver", anchor: .top)
                            }
                        }
                    } else {
                        // Cuando se inicia un nuevo juego, desplazar hacia arriba
                        withAnimation {
                            scrollView.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top) // Ignorar el área segura superior
        .scrollIndicators(.visible)
        .background(Color.black)
        .navigationBarHidden(true) // Ocultar la barra de navegación
    }
    
    /// Cabecera con información del juego
    private var header: some View {
        HStack {
            // Indicador del turno actual o resultado
            if viewModel.gameOver {
                if let winner = viewModel.winner {
                    Text("¡\(winner.name) gana!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(winner.color)
                } else {
                    Text("¡Empate!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.gray)
                }
            } else {
                Text("Turno: \(viewModel.currentPlayer.name)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewModel.currentPlayer.color)
            }
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.top, 14) // Pequeño margen superior de 14 puntos
        .padding(.bottom, 0)
    }
    
    /// Tablero de juego
    private var gameBoard: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(0..<3) { row in
                    ForEach(0..<3) { col in
                        Button(action: {
                            // Al tocar una celda, realizar movimiento
                            hapticManager.playHaptic(for: .selection)
                            viewModel.makeMove(row: row, col: col)
                        }) {
                            cellView(for: viewModel.boardState[row][col], isInWinningLine: isInWinningLine(row: row, col: col))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(viewModel.gameOver || viewModel.isAIThinking || !viewModel.boardState[row][col].isEmpty)
                    }
                }
            }
            
            // Indicador de IA pensando o puntuación
            HStack(spacing: 6) {
                if viewModel.isAIThinking {
                    Text("IA pensando...")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Spacer()
                    Text("\(viewModel.scoreX)")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                    Text("-")
                    Text("\(viewModel.scoreO)")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .font(.system(size: 14))
            .frame(height: 20) // Altura fija para evitar saltos de interfaz
            .padding(.top, 2)
        }
        .padding(.horizontal)
        .padding(.top, 0)
        .padding(.bottom, 5)
    }
    
    /// Verifica si una celda está en la línea ganadora
    private func isInWinningLine(row: Int, col: Int) -> Bool {
        guard let winningLine = viewModel.winningLine else {
            return false
        }
        
        return winningLine.contains(where: { $0.0 == row && $0.1 == col })
    }
    
    /// Vista de una celda individual del tablero
    private func cellView(for cellState: CellState, isInWinningLine: Bool) -> some View {
        ZStack {
            // Fondo de la celda
            RoundedRectangle(cornerRadius: 10)
                .fill(isInWinningLine ? Color.green.opacity(0.6) : Color.blue.opacity(0.15))
                .aspectRatio(1, contentMode: .fit)
            
            // Contenido según el estado de la celda
            if let player = cellState.player {
                Text(player.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(player.color)
            }
        }
    }
    
    /// Controles cuando el juego está en curso
    private var gameControls: some View {
        HStack {
            // Botón para volver al menú principal
            Button(action: onBackToMenu) {
                Image(systemName: "house.fill")
                    .font(.system(size: 16, weight: .bold))
            }
            .buttonStyle(BorderedButtonStyle())
            
            Spacer()
            
            // Botón para reiniciar juego
            Button(action: {
                hapticManager.playHaptic(for: .selection)
                viewModel.startNewGame()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .bold))
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .padding(.horizontal, 5)
    }
    
    /// Controles cuando el juego ha terminado
    private var gameOverControls: some View {
        VStack(spacing: 12) {
            // Botón para jugar de nuevo
            Button(action: {
                hapticManager.playHaptic(for: .selection)
                viewModel.startNewGame()
            }) {
                Label("Jugar de nuevo", systemImage: "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderedButtonStyle(tint: .green))
            
            // Botón para volver al menú
            Button(action: onBackToMenu) {
                Label("Menú principal", systemImage: "house.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderedButtonStyle(tint: .blue))
            
            // Botón para reiniciar puntuación
            Button(action: {
                hapticManager.playHaptic(for: .selection)
                viewModel.resetScore()
            }) {
                Label("Reiniciar puntuación", systemImage: "gobackward")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderedButtonStyle(tint: .gray))
        }
        .padding(.horizontal, 5)
        .padding(.top, 29) // Añadir margen superior para separar de la puntuación
    }
} 