//
//  ContentView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran on 4/14/25.
//

import SwiftUI

/// Vista principal que maneja la navegación entre el menú y el juego
struct ContentView: View {
    // Estado que controla si se muestra la pantalla de juego o el menú
    @State private var showingGame = false
    
    var body: some View {
        // Cambio condicional entre la vista del juego y la vista del menú
        if showingGame {
            GameView(showingGame: $showingGame)
        } else {
            MenuView(showingGame: $showingGame)
        }
    }
}

/// Vista del menú principal con opciones para iniciar el juego y mostrar información
struct MenuView: View {
    // Propiedad enlazada para comunicarse con ContentView
    @Binding var showingGame: Bool
    // Estados para controlar la visualización de modales informativos
    @State private var mostrarInfo = false
    @State private var mostrarCreador = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Título del juego
            Text("Tic Tac Toe")
                .font(.title3)
                .bold()
            
            // Botón para iniciar el juego
            Button(action: {
                showingGame = true
            }) {
                Text("Iniciar Juego")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Botón para mostrar las instrucciones del juego
            Button(action: {
                mostrarInfo.toggle()
            }) {
                Text("¿Cómo jugar?")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $mostrarInfo) {
                // Contenido del modal de instrucciones
                ScrollView {
                    VStack(spacing: 15) {
                        Text("¿Cómo jugar Tic Tac Toe?")
                            .font(.headline)
                            .padding(.top)
                        Text("1. El juego es para dos jugadores, X y O.\n2. Los jugadores se turnan para colocar su símbolo en una celda vacía de la cuadrícula 3x3.\n3. El objetivo es ser el primero en alinear tres símbolos iguales en línea horizontal, vertical o diagonal.\n4. Si todas las celdas se llenan sin un ganador, el juego termina en empate.")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding()
                        Button("Cerrar") {
                            mostrarInfo = false
                        }
                        .padding(.bottom)
                    }
                }
            }
            
            // Botón para mostrar información sobre el creador
            Button(action: {
                mostrarCreador.toggle()
            }) {
                Text("Creador")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $mostrarCreador) {
                // Contenido del modal de información del creador
                ScrollView {
                    VStack(spacing: 15) {
                        Text("Creador de la App")
                            .font(.headline)
                            .padding(.top)
                        Text("Esta app fue desarrollada por Michell Alexis Policarpio Moran, Ingeniero Informático de Veracruz, México.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Cerrar") {
                            mostrarCreador = false
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
    }
}

/// Vista principal del juego que contiene el tablero y la lógica del juego
struct GameView: View {
    // Propiedad enlazada para comunicarse con ContentView
    @Binding var showingGame: Bool
    // Estado del tablero de juego (array de 9 celdas vacías inicialmente)
    @State private var board = Array(repeating: "", count: 9)
    // Estado para rastrear el jugador actual
    @State private var currentPlayer = "X"
    // Estado para almacenar el jugador ganador (nil si no hay ganador)
    @State private var winner: String? = nil
    // Estado para almacenar los índices de las celdas ganadoras
    @State private var winningIndices: [Int] = []
    // Estado para controlar la visualización del resultado final
    @State private var mostrarResultado = false
    
    var body: some View {
        // ScrollViewReader para permitir el desplazamiento automático
        ScrollViewReader { proxy in
            VStack(alignment: .center, spacing: 4) {
                // Muestra el turno actual si no hay ganador
                if winner == nil {
                    Text("Turno: \(currentPlayer)")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                // Cuadrícula 3x3 para el tablero de juego
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
                    ForEach(0..<9) { index in
                        // Botón para cada celda del tablero
                        Button(action: {
                            // Solo permite jugar en celdas vacías y si no hay ganador
                            if board[index].isEmpty && winner == nil {
                                // Coloca el símbolo del jugador actual
                                board[index] = currentPlayer
                                // Verifica si hay un ganador
                                checkWinner()
                                // Cambia al siguiente jugador
                                currentPlayer = currentPlayer == "X" ? "O" : "X"
                            }
                        }) {
                            ZStack {
                                // Fondo de la celda (verde si forma parte de la combinación ganadora)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(winningIndices.contains(index) ? Color.green.opacity(0.6) : Color.blue.opacity(0.15))
                                    .aspectRatio(1, contentMode: .fit)
                                
                                // Muestra el símbolo del jugador si la celda no está vacía
                                if !board[index].isEmpty {
                                    Text(board[index])
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(board[index] == "X" ? .blue : .red)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
                
                // Muestra la pantalla de resultado si hay un ganador
                if winner != nil {
                    if mostrarResultado {
                        VStack(spacing: 12) {
                            // Mensaje según el resultado (ganador o empate)
                            Text(winner == "Empate" ? "¡Empate!" : "¡Ganó \(winner!)!")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(winner == "X" ? .blue : .red)
                            
                            // Botones para jugar de nuevo o volver al menú
                            VStack(spacing: 10) {
                                Button(action: { resetGame() }) {
                                    Text("Jugar de nuevo")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                }
                                Button(action: { showingGame = false }) {
                                    Color.red
                                        .frame(height: 32)
                                        .cornerRadius(10)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                            }
                            .padding(.horizontal)
                        }
                        .id("bottom") // ID para el desplazamiento automático
                    }
                } else {
                    // Botón para volver al menú durante el juego
                    Button(action: { showingGame = false }) {
                        Color.red
                            .frame(height: 32)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 0)
            // Reacción al cambio de ganador
            .onChange(of: winner) {
                if winner != nil {
                    // Retrasa la visualización del resultado para permitir ver la jugada ganadora
                    mostrarResultado = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        mostrarResultado = true
                        // Desplaza automáticamente a la vista del resultado
                        withAnimation {
                            proxy.scrollTo("bottom", anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    /// Verifica si hay un ganador o un empate
    private func checkWinner() {
        // Todas las posibles combinaciones ganadoras
        let winningCombos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Vertical
            [0, 4, 8], [2, 4, 6]              // Diagonal
        ]
        
        // Comprueba cada combinación ganadora
        for combo in winningCombos {
            if board[combo[0]] != "" &&
               board[combo[0]] == board[combo[1]] &&
               board[combo[1]] == board[combo[2]] {
                // Establece el ganador y las celdas ganadoras
                winner = board[combo[0]]
                winningIndices = combo
                return
            }
        }
        
        // Si el tablero está lleno y no hay ganador, es un empate
        if !board.contains("") {
            winner = "Empate"
            winningIndices = []
        }
    }
    
    /// Reinicia el juego a su estado inicial
    private func resetGame() {
        board = Array(repeating: "", count: 9)
        currentPlayer = "X"
        winner = nil
        winningIndices = []
        mostrarResultado = false
    }
}

/// Vista previa para Xcode
#Preview {
    ContentView()
}