# 🎮 AppleWatch-TicTacToe
[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![Platform](https://img.shields.io/badge/Platform-watchOS-blue.svg)](https://www.apple.com/watchos/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

<p align="center">
  <img src="Screenshots/partida.png" alt="Tic Tac Toe para Apple Watch" width="180"/>
</p>

## 📱 Descripción
**AppleWatch-TicTacToe** es un juego clásico de Tic Tac Toe (Tres en raya) diseñado específicamente para Apple Watch. La aplicación cuenta con una interfaz optimizada para pantallas pequeñas y controles táctiles precisos, ofreciendo diferentes modos de juego y niveles de dificultad.

## ✨ Características
- 🤖 Tres niveles de dificultad contra la IA: Fácil, Medio y Difícil
- 👥 Modo multijugador para jugar con un amigo
- 🎲 Juego clásico de Tic Tac Toe con interfaz intuitiva
- ⌚ Diseñado específicamente para Apple Watch
- 🎯 Interfaz minimalista y fácil de usar
- 🔄 Sistema de turnos alternados entre X y O
- 🏆 Detección automática de ganador
- 🎨 Resaltado visual de la combinación ganadora
- 🌈 Interfaz con gradientes y animaciones atractivas
- 🌐 Disponible en español

## 🛠️ Tecnologías utilizadas
- SwiftUI
- WatchKit
- watchOS
- Combine

## 📋 Requisitos
- watchOS 10.0+
- Xcode 15.0+
- Swift 5.9+

## 🚀 Instalación
1. Clona este repositorio:
```bash
git clone https://github.com/TuUsuario/AppleWatch-TicTacToe.git
```
2. Abre `TicTacToe.xcodeproj` en Xcode
3. Selecciona tu dispositivo Apple Watch o simulador como destino
4. Ejecuta la aplicación (⌘+R)

## 🎮 Cómo jugar
1. Abre la aplicación en tu Apple Watch
2. Elige entre jugar contra la IA o en modo multijugador
3. Si eliges jugar contra la IA, selecciona el nivel de dificultad
4. Los jugadores se turnan para colocar su símbolo (X u O) en la cuadrícula
5. El primer jugador en alinear tres símbolos iguales (horizontal, vertical o diagonal) gana
6. Si la cuadrícula se llena sin un ganador, el juego termina en empate

## 🤖 Inteligencia Artificial
- **Modo Fácil**: La IA realiza movimientos aleatorios
- **Modo Medio**: La IA combina estrategia y aleatoriedad (60% estratégico, 40% aleatorio)
- **Modo Difícil**: La IA utiliza una estrategia avanzada, priorizando movimientos para ganar o bloquear al oponente

## 📸 Capturas de pantalla
<p align="center">
  <img src="Screenshots/menu.png" alt="Pantalla de menú" width="180"/>
  <img src="Screenshots/partida.png" alt="Partida en curso" width="180"/>
  <img src="Screenshots/victoria.png" alt="Pantalla de victoria" width="180"/>
</p>

## 🔍 Estructura del proyecto
- **ContentView**: Controlador de vista principal que maneja la navegación
- **IntroView**: Pantalla de inicio animada
- **MenuView**: Menú de selección de modo de juego
- **GameView**: Implementación principal del juego
- **GameMode**: Enumeración que define los modos de juego disponibles

## 👨‍💻 Autor
Michell Alexis Policarpio Moran - Ingeniero Informático de Veracruz, México

## 📄 Licencia
Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
