//
//  ContentView.swift
//  TicTacToe Watch App
//
//  Created by Michell Alexis Policarpio Moran on 4/14/25.
//

import SwiftUI
import Combine

/// Enumeración para los modos de juego
enum GameMode {
    case singlePlayerEasy   // Un jugador contra IA fácil
    case singlePlayerMedium // Un jugador contra IA media
    case singlePlayerHard   // Un jugador contra IA difícil
    case multiPlayer        // Dos jugadores
}

/// Vista principal que maneja la navegación entre el menú y el juego
struct ContentView: View {
    // Estado que controla si se muestra la pantalla de juego o el menú
    @State private var showingGame = false
    // Modo de juego seleccionado
    @State private var gameMode = GameMode.multiPlayer
    // Estado para controlar la pantalla de intro
    @State private var showingIntro = true
    
    var body: some View {
        // Si estamos mostrando la intro, mostrarla
        if showingIntro {
            IntroView {
                withAnimation {
                    showingIntro = false
                }
            }
        }
        // Si no, mostrar el juego o el menú según corresponda
        else if showingGame {
            GameView(showingGame: $showingGame, gameMode: gameMode)
        } else {
            MenuView(showingGame: $showingGame, gameMode: $gameMode)
        }
    }
}

/// Vista de introducción con logo animado
struct IntroView: View {
    var onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Logo del juego
            VStack(spacing: 0) {
                // Título con animación de color
                Text("TIC")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("TAC")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("TOE")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.8), Color.black.opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            // Programar la transición a la siguiente vista después de 1.5 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.5) {
                onComplete()
            }
        }
    }
}

/// Vista del menú principal con opciones para iniciar el juego y mostrar información
struct MenuView: View {
    // Propiedad enlazada para comunicarse con ContentView
    @Binding var showingGame: Bool
    // Modo de juego seleccionado
    @Binding var gameMode: GameMode
    // Estados para controlar la visualización de modales informativos
    @State private var mostrarInfo = false
    @State private var mostrarCreador = false
    @State private var mostrarDificultadIA = false
    // Para animación de los botones
    @State private var animatedButton: Int? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Título más compacto
                Text("Tic Tac Toe")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                
                // Botón para iniciar juego contra IA
                menuButton(
                    id: 1,
                    text: "Jugar vs IA",
                    icon: "cpu",
                    gradientColors: [.blue, .purple],
                    action: {
                        withAnimation {
                            animatedButton = 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            mostrarDificultadIA = true
                            animatedButton = nil
                        }
                    }
                )
                .sheet(isPresented: $mostrarDificultadIA) {
                    // Menú de selección de dificultad con estética mejorada
                    ScrollView {
                        ZStack {
                            // Fondo con gradiente suave
                            LinearGradient(
                                colors: [Color.black.opacity(0.8), Color.black.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            
                            VStack(spacing: 15) {
                                Text("Selecciona dificultad")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                                
                                dificultadButton(
                                    text: "Fácil",
                                    systemImage: "tortoise",
                                    gradientColors: [.green.opacity(0.8), .green],
                                    action: {
                                        gameMode = .singlePlayerEasy
                                        mostrarDificultadIA = false
                                        showingGame = true
                                    }
                                )
                                
                                dificultadButton(
                                    text: "Media",
                                    systemImage: "hare",
                                    gradientColors: [.orange.opacity(0.8), .orange],
                                    action: {
                                        gameMode = .singlePlayerMedium
                                        mostrarDificultadIA = false
                                        showingGame = true
                                    }
                                )
                                
                                dificultadButton(
                                    text: "Difícil",
                                    systemImage: "bolt.fill",
                                    gradientColors: [.red.opacity(0.8), .red],
                                    action: {
                                        gameMode = .singlePlayerHard
                                        mostrarDificultadIA = false
                                        showingGame = true
                                    }
                                )
                                
                                Button(action: {
                                    mostrarDificultadIA = false
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.left")
                                        Text("Atrás")
                                    }
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(
                                        Capsule()
                                            .fill(Color.gray.opacity(0.3))
                                    )
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            }
                            .padding()
                        }
                    }
                }
                
                // Botón para iniciar juego multijugador
                menuButton(
                    id: 2,
                    text: "Juego Multijugador",
                    icon: "person.2.fill",
                    gradientColors: [.green, .teal],
                    action: {
                        withAnimation {
                            animatedButton = 2
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            gameMode = .multiPlayer
                            showingGame = true
                            animatedButton = nil
                        }
                    }
                )
                
                // Botones de información en horizontal - más compacto
                HStack(spacing: 10) {
                    // Botón para mostrar las instrucciones del juego
                    infoButton(
                        text: "Cómo jugar",
                        icon: "questionmark.circle.fill",
                        action: {
                            mostrarInfo.toggle()
                        }
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Botón para mostrar información sobre el creador
                    infoButton(
                        text: "Creador",
                        icon: "person.fill",
                        action: {
                            mostrarCreador.toggle()
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 5)
                
                // Sheets para información
                .sheet(isPresented: $mostrarInfo) {
                    // Contenido del modal de instrucciones
                    ScrollView {
                        ZStack {
                            Color.black.opacity(0.9)
                                .ignoresSafeArea()
                            
                            VStack(spacing: 15) {
                                Text("¿Cómo jugar?")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.top)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    instruccionItem(numero: "1", texto: "El juego es para dos jugadores, X y O.")
                                    instruccionItem(numero: "2", texto: "Los jugadores se turnan para colocar su símbolo en una celda vacía de la cuadrícula 3x3.")
                                    instruccionItem(numero: "3", texto: "El objetivo es ser el primero en alinear tres símbolos iguales en línea horizontal, vertical o diagonal.")
                                    instruccionItem(numero: "4", texto: "Si todas las celdas se llenan sin un ganador, el juego termina en empate.")
                                }
                                .padding()
                                
                                Text("En modo 1 jugador, tú serás X y la IA será O.")
                                    .font(.system(size: 16, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.horizontal)
                                
                                Button(action: {
                                    mostrarInfo = false
                                }) {
                                    Text("Cerrar")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(
                                            Capsule()
                                                .fill(Color.blue.opacity(0.6))
                                        )
                                }
                                .padding(.vertical)
                            }
                            .padding()
                        }
                    }
                }
                .sheet(isPresented: $mostrarCreador) {
                    // Contenido del modal de información del creador
                    ScrollView {
                        ZStack {
                            LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.black.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            
                            VStack(spacing: 15) {
                                // Avatar simulado del creador
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .foregroundColor(.white)
                                    )
                                    .padding(.top, 20)
                                
                                Text("Creador de la App")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Esta app fue desarrollada por Michell Alexis Policarpio Moran, Ingeniero Informático de Veracruz, México.")
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding()
                                
                                Button(action: {
                                    mostrarCreador = false
                                }) {
                                    Text("Cerrar")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(
                                            Capsule()
                                                .fill(Color.purple.opacity(0.6))
                                        )
                                }
                                .padding(.bottom)
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 0)
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.8), Color.black.opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // Función para crear un botón principal de menú con estilo consistente
    private func menuButton(id: Int, text: String, icon: String, gradientColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(text)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
            .scaleEffect(animatedButton == id ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animatedButton)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Función para crear un botón de dificultad con estilo consistente
    private func dificultadButton(text: String, systemImage: String, gradientColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(text)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 5)
    }
    
    // Función para crear un botón de información con estilo consistente
    private func infoButton(text: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(text)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Función para crear un ítem de instrucción con estilo consistente
    private func instruccionItem(numero: String, texto: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(numero)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.blue.opacity(0.6)))
            
            Text(texto)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/// Vista principal del juego que contiene el tablero y la lógica del juego
struct GameView: View {
    // Propiedad enlazada para comunicarse con ContentView
    @Binding var showingGame: Bool
    // Modo de juego
    let gameMode: GameMode
    
    @State private var board = Array(repeating: "", count: 9) // Estado del tablero de juego (array de 9 celdas vacías inicialmente)
    @State private var currentPlayer = "X"                    // Estado para rastrear el jugador actual
    @State private var winner: String? = nil                  // Estado para almacenar el jugador ganador (nil si no hay ganador)
    @State private var winningIndices: [Int] = []             // Estado para almacenar los índices de las celdas ganadoras
    @State private var mostrarResultado = false               // Estado para controlar la visualización del resultado final
    @State private var aiTimer: AnyCancellable?               // Temporizador para el movimiento de la IA
    @State private var aiThinking = false                     // Estado para indicar si la IA está pensando
    @State private var scrollProxy: ScrollViewProxy? // Para guardar referencia al proxy
    
    var body: some View {
        // ScrollViewReader para permitir el desplazamiento automático
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: true) {
                VStack(alignment: .center, spacing: 0) {
                    // Cuadrícula 3x3 para el tablero de juego - Sin espaciado vertical adicional
                    VStack(spacing: 0) {
                        // Muestra el turno actual o resultado (siempre visible)
                        HStack {
                            if winner == nil {
                                Text("Turno: \(currentPlayer)")
                                    .font(.system(size: 18, weight: .semibold))
                            } else if winner == "Empate" {
                                Text("Resultado: Empate")
                                    .font(.system(size: 18, weight: .semibold))
                            } else {
                                Text("Ganador: \(winner!)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(winner == "X" ? .blue : .red)
                            }
                        }
                        .padding(.vertical, 1)
                        
                        // Pequeño espacio entre el turno y el tablero
                        Spacer().frame(height: 6)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
                            ForEach(0..<9) { index in
                                // Botón para cada celda del tablero
                                Button(action: {
                                    // Solo permite jugar en celdas vacías, sin ganador, y en el turno correcto
                                    if board[index].isEmpty && winner == nil && !aiThinking {
                                        // En multijugador, cualquier jugador puede jugar
                                        // En modo un jugador, solo el jugador humano (X) puede jugar
                                        if gameMode == .multiPlayer || currentPlayer == "X" {
                                            // Coloca el símbolo del jugador actual
                                            makeMove(at: index)
                                            
                                            // Si es modo de un jugador y el turno es de la IA
                                            if gameMode != .multiPlayer && currentPlayer == "O" && winner == nil {
                                                // La IA está pensando
                                                aiThinking = true
                                                
                                                // Simulamos que la IA está "pensando"
                                                aiTimer = Timer.publish(every: 1, on: .main, in: .common)
                                                    .autoconnect()
                                                    .sink { _ in
                                                        // Determina el movimiento de la IA según el nivel
                                                        let aiMove = getAIMove()
                                                        
                                                        if let move = aiMove {
                                                            makeMove(at: move)
                                                            aiThinking = false
                                                            aiTimer?.cancel()
                                                        }
                                                    }
                                            }
                                        }
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
                                .disabled(aiThinking)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        // Muestra el indicador de que la IA está pensando debajo del tablero
                        if aiThinking {
                            Text("IA pensando...")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                                .padding(.top, 4)
                        }
                    }
                    .id("tablero") // ID para el tablero
                    
                    // Muestra la pantalla de resultado si hay un ganador
                    if winner != nil {
                        if mostrarResultado {
                            VStack(spacing: 12) {
                                // Mensaje según el resultado (ganador o empate)
                                if winner == "Empate" {
                                    Text("¡Empate!")
                                        .font(.system(size: 20, weight: .bold))
                                } else {
                                    Text(winner == "X" ? 
                                         (gameMode == .multiPlayer ? "¡Ganó X!" : "¡Ganaste!") : 
                                         (gameMode == .multiPlayer ? "¡Ganó O!" : "¡Ganó la IA!"))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(winner == "X" ? .blue : .red)
                                }
                                
                                // Botones para jugar de nuevo o volver al menú
                                VStack(spacing: 10) {
                                    Button(action: { resetGame() }) {
                                        HStack {
                                            Image(systemName: "arrow.counterclockwise")
                                            Text("Jugar de nuevo")
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                    }
                                    
                                    Button(action: { showingGame = false }) {
                                        HStack {
                                            Image(systemName: "house.fill")
                                            Text("Menú principal")
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal, 6)
                                .padding(.top, 6)
                            }
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(15)
                            .padding(.horizontal, 6)
                            .padding(.top, 8)
                            .id("bottom") // ID para el desplazamiento automático
                        }
                    }
                    
                    // Espacio adicional al final para permitir scroll
                    Spacer().frame(height: 15)
                }
                .frame(maxWidth: .infinity)
                .padding(0) // Sin padding en ninguna dirección
            }
            .onAppear {
                // Guarda la referencia al proxy
                scrollProxy = proxy
            }
            .ignoresSafeArea(edges: .top) // Ignora el área segura superior
            // Reacción al cambio de ganador
            .onChange(of: winner) { _ in
                if winner != nil {
                    // Cancela el temporizador de la IA si existe
                    aiTimer?.cancel()
                    aiThinking = false
                    
                    // Retrasa la visualización del resultado para permitir ver la jugada ganadora
                    mostrarResultado = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        mostrarResultado = true
                        // Desplaza automáticamente a la vista del resultado
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo("bottom", anchor: .top)
                            }
                        }
                    }
                }
            }
            .onDisappear {
                // Asegura que el temporizador se cancele al salir de la vista
                aiTimer?.cancel()
            }
        }
    }
    
    /// Realiza un movimiento en la posición especificada
    private func makeMove(at index: Int) {
        // Solo permite jugar en celdas vacías
        if board[index].isEmpty && winner == nil {
            // Coloca el símbolo del jugador actual
            board[index] = currentPlayer
            // Verifica si hay un ganador
            checkWinner()
            // Cambia al siguiente jugador si no hay un ganador
            if winner == nil {
                currentPlayer = currentPlayer == "X" ? "O" : "X"
            }
        }
    }
    
    /// Obtiene un movimiento aleatorio para la IA en modo fácil
    private func getAIEasyMove() -> Int? {
        // Busca celdas vacías
        let availableMoves = board.indices.filter { board[$0].isEmpty }
        guard !availableMoves.isEmpty else { return nil }
        
        // Elige una celda aleatoria entre las disponibles
        return availableMoves.randomElement()
    }
    
    /// Obtiene el mejor movimiento para la IA en modo difícil
    private func getAIHardMove() -> Int? {
        // Combinaciones ganadoras
        let winningCombos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Vertical
            [0, 4, 8], [2, 4, 6]              // Diagonal
        ]
        
        // Busca celdas vacías
        let availableMoves = board.indices.filter { board[$0].isEmpty }
        guard !availableMoves.isEmpty else { return nil }
        
        // 1. Intenta ganar - Busca un movimiento que pueda ganar
        for combo in winningCombos {
            let values = combo.map { board[$0] }
            let oCount = values.filter { $0 == "O" }.count
            let emptyCount = values.filter { $0.isEmpty }.count
            
            // Si hay dos O y un espacio vacío, coloca ahí para ganar
            if oCount == 2 && emptyCount == 1 {
                let emptyIndex = combo.first { board[$0].isEmpty }
                if let index = emptyIndex {
                    return index
                }
            }
        }
        
        // 2. Bloquea al jugador - Evita que el jugador gane
        for combo in winningCombos {
            let values = combo.map { board[$0] }
            let xCount = values.filter { $0 == "X" }.count
            let emptyCount = values.filter { $0.isEmpty }.count
            
            // Si hay dos X y un espacio vacío, bloquea
            if xCount == 2 && emptyCount == 1 {
                let emptyIndex = combo.first { board[$0].isEmpty }
                if let index = emptyIndex {
                    return index
                }
            }
        }
        
        // 3. Intenta tomar el centro si está disponible
        if board[4].isEmpty {
            return 4
        }
        
        // 4. Intenta tomar las esquinas
        let corners = [0, 2, 6, 8].filter { board[$0].isEmpty }
        if !corners.isEmpty {
            return corners.randomElement()
        }
        
        // 5. Toma cualquier espacio disponible
        return availableMoves.randomElement()
    }
    
    /// Obtiene un movimiento inteligente para la IA en modo medio (mezcla de aleatorio y estratégico)
    private func getAIMediumMove() -> Int? {
        // Combinaciones ganadoras
        let winningCombos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Vertical
            [0, 4, 8], [2, 4, 6]              // Diagonal
        ]
        
        // Busca celdas vacías
        let availableMoves = board.indices.filter { board[$0].isEmpty }
        guard !availableMoves.isEmpty else { return nil }
        
        // 60% del tiempo juega estratégicamente, 40% aleatorio
        if Bool.random() && Bool.random() && Bool.random() {
            // 1. Intenta ganar en un solo movimiento
            for combo in winningCombos {
                let values = combo.map { board[$0] }
                let oCount = values.filter { $0 == "O" }.count
                let emptyCount = values.filter { $0.isEmpty }.count
                
                if oCount == 2 && emptyCount == 1 {
                    let emptyIndex = combo.first { board[$0].isEmpty }
                    if let index = emptyIndex {
                        return index
                    }
                }
            }
            
            // 2. Bloquea jugadas ganadoras obvias
            for combo in winningCombos {
                let values = combo.map { board[$0] }
                let xCount = values.filter { $0 == "X" }.count
                let emptyCount = values.filter { $0.isEmpty }.count
                
                if xCount == 2 && emptyCount == 1 {
                    let emptyIndex = combo.first { board[$0].isEmpty }
                    if let index = emptyIndex {
                        return index
                    }
                }
            }
            
            // 3. Prefiere el centro
            if board[4].isEmpty {
                return 4
            }
        }
        
        // Movimiento aleatorio
        return availableMoves.randomElement()
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
        aiTimer?.cancel()
        aiThinking = false
        
        // Desplaza la vista hacia arriba al tablero
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                scrollProxy?.scrollTo("tablero", anchor: .top)
            }
        }
    }
    
    // Método para obtener el movimiento de la IA según el nivel de dificultad
    private func getAIMove() -> Int? {
        switch gameMode {
        case .singlePlayerEasy:
            return getAIEasyMove()
        case .singlePlayerMedium:
            return getAIMediumMove()
        case .singlePlayerHard:
            return getAIHardMove()
        default:
            return nil
        }
    }
}

/// Vista previa para Xcode
#Preview {
    ContentView()
}