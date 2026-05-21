//
//  ConversationView.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

import SwiftUI
import AVFoundation

struct ConversationView: View {

    let scene: DialogueScene
    @State private var currentLineIndex: Int = 0
    @State private var activeCast: [CharacterPosition] = []
    @State private var activeExpressions: [String: String] = [:]
    @State private var activeBackground: String = ""
    @State private var eventLog: Set<String> = []
    @State private var audioPlayer: AVAudioPlayer?

    var currentLine: DialogueLine {
        scene.lines[currentLineIndex]
    }

    var leftCast: [CharacterPosition] {
        activeCast
            .filter { $0.side == .left }
            .sorted { $0.order < $1.order }
    }

    var rightCast: [CharacterPosition] {
        activeCast
            .filter { $0.side == .right }
            .sorted { $0.order < $1.order }
    }

    var body: some View {
        GeometryReader { screen in
            let screenW    = screen.size.width
            let screenH    = screen.size.height
            let dialogueH  = screenH * 2 / 5
            let portraitH  = screenH - dialogueH

            ZStack(alignment: .bottom) {

                // ── Background ──────────────────────────────────────────
                Color.black.ignoresSafeArea()

                if UIImage(named: activeBackground) != nil {
                    Image(activeBackground)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenW, height: screenH)
                        .clipped()
                        .transition(.opacity)
                        .id(activeBackground)
                }

                Color.black.opacity(0.4).ignoresSafeArea()

                // ── Content ─────────────────────────────────────────────
                VStack(spacing: 0) {

                    // Portrait row — takes exactly what's left above dialogue box
                    HStack(alignment: .bottom, spacing: 0) {

                        ZStack(alignment: .bottomLeading) {
                            ForEach(leftCast, id: \.characterId) { position in
                                CharacterPortraitView(
                                    position: position,
                                    isActive: position.characterId == currentLine.speakerId,
                                    expression: activeExpressions[position.characterId]
                                )
                                .transition(.opacity)
                            }
                        }
                        .frame(width: screenW / 2, height: portraitH, alignment: .bottomLeading)

                        ZStack(alignment: .bottomTrailing) {
                            ForEach(rightCast, id: \.characterId) { position in
                                CharacterPortraitView(
                                    position: position,
                                    isActive: position.characterId == currentLine.speakerId,
                                    expression: activeExpressions[position.characterId]
                                )
                                .transition(.opacity)
                            }
                        }
                        .frame(width: screenW / 2, height: portraitH, alignment: .bottomTrailing)

                    }

                    // Dialogue box — exactly 1/3 screen height, no shrink/grow
                    DialogueBoxView(
                        line: currentLine,
                        onNext: nextLine,
                        onPrevious: previousLine,
                        onChoicePicked: handleChoice,
                        isFirst: currentLineIndex == 0,
                        isLast: currentLineIndex == scene.lines.count - 1,
                        eventLog: eventLog
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(width: screenW - 32, height: dialogueH)
                    .padding(.bottom, 36)
                }
            }
            .frame(width: screenW, height: screenH)
        }
        .ignoresSafeArea()
        .onAppear {
            applyLine(at: 0)
        }
    }

    private func nextLine() {
        guard currentLineIndex < scene.lines.count - 1 else { return }
        applyLine(at: currentLineIndex + 1)
    }

    private func previousLine() {
        guard currentLineIndex > 0 else { return }
        applyLine(at: currentLineIndex - 1)
    }

    private func handleChoice(_ choice: DialogueChoice) {
        if let event = choice.grantsEvent {
            eventLog.insert(event)
        }
        nextLine()
    }

    private func applyLine(at index: Int) {
        let line = scene.lines[index]

        let resolvedCast: [CharacterPosition] = {
            for i in stride(from: index, through: 0, by: -1) {
                if let c = scene.lines[i].cast { return c }
            }
            return scene.cast
        }()

        let resolvedBackground: String = {
            for i in stride(from: index, through: 0, by: -1) {
                if let b = scene.lines[i].background { return b }
            }
            return scene.background
        }()

        var resolvedExpressions: [String: String] = [:]
        for i in 0...index {
            if let e = scene.lines[i].expressions {
                resolvedExpressions.merge(e) { _, new in new }
            }
        }

        withAnimation(.easeInOut(duration: 0.6)) {
            currentLineIndex = index
            activeCast = resolvedCast
            activeExpressions = resolvedExpressions
            activeBackground = resolvedBackground
        }

        if let sfxName = line.sfx {
            playSFX(sfxName)
        }
    }

    private func playSFX(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }

}
