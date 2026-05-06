//
//  DialogueBoxView.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

import SwiftUI

struct DialogueBoxView: View {
    
    let line: DialogueLine
    let onNext: () -> Void
    let onPrevious: () -> Void
    let isFirst: Bool
    let isLast: Bool
    
    @State private var displayedText: String = ""
    @State private var isTyping: Bool = false
    private let typingSpeed: Double = 0.03
    
    var speakerName: String {
        CharacterRegistry.find(line.speakerId)?.name ?? line.speakerId
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Speaker name
            Text(speakerName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.yellow)
            
            // Dialogue text (shows typed version)
            Text(displayedText)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            
            // Navigation buttons
            HStack {
                
                // Previous button
                Button(action: onPrevious) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(isFirst ? .gray : .white)
                }
                .disabled(isFirst)
                
                Spacer()
                
                // Next / Skip button
                Button(action: handleNextTap) {
                    Text(nextButtonLabel)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }
                
            }
            
        }
        .padding(20)
        .background(Color.black.opacity(0.85))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .cornerRadius(16)
        .padding(16)
        .onAppear {
            startTyping()
        }
        .onChange(of: line.text) {
            startTyping()
        }
    }
    
    var nextButtonLabel: String {
        if isTyping { return "Skip" }
        if isLast   { return "Done" }
        return "Next ▶"
    }
    
    private func handleNextTap() {
        if isTyping {
            skipTyping()
        } else {
            onNext()
        }
    }
    
    private func startTyping() {
        displayedText = ""
        isTyping = true
        
        let fullText = line.text
        var charIndex = 0
        
        // reveal one character at a time
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText += String(fullText[index])
                charIndex += 1
            } else {
                // finished typing
                timer.invalidate()
                isTyping = false
            }
        }
    }
    
    // MARK: - Skip → show everything instantly
    private func skipTyping() {
        displayedText = line.text
        isTyping = false
    }
    
}
