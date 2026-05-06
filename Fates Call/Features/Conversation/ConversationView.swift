//
//  ConversationView.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

import SwiftUI

struct ConversationView: View {
    
    let scene: DialogueScene
    @State private var currentLineIndex: Int = 0
    
    var currentLine: DialogueLine {
        scene.lines[currentLineIndex]
    }
    
    var leftCast: [CharacterPosition] {
        scene.cast
            .filter { $0.side == .left }
            .sorted { $0.order < $1.order }
    }
    
    var rightCast: [CharacterPosition] {
        scene.cast
            .filter { $0.side == .right }
            .sorted { $0.order < $1.order }
    }
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack(alignment: .bottom, spacing: 0) {
                    
                    HStack(alignment: .bottom, spacing: -20) {
                        ForEach(leftCast, id: \.characterId) { position in
                            CharacterPortraitView(
                                position: position,
                                isActive: position.characterId == currentLine.speakerId
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .bottom, spacing: -20) {
                        ForEach(rightCast, id: \.characterId) { position in
                            CharacterPortraitView(
                                position: position,
                                isActive: position.characterId == currentLine.speakerId
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 16)
                
                DialogueBoxView(
                    line: currentLine,
                    onNext: nextLine,
                    onPrevious: previousLine,
                    isFirst: currentLineIndex == 0,
                    isLast: currentLineIndex == scene.lines.count - 1
                )
                
            }
        }
    }
    
    private func nextLine() {
        guard currentLineIndex < scene.lines.count - 1 else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            currentLineIndex += 1
        }
    }
    
    private func previousLine() {
        guard currentLineIndex > 0 else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            currentLineIndex -= 1
        }
    }
    
}
