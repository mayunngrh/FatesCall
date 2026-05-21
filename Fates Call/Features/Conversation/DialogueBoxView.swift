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
    let onChoicePicked: (DialogueChoice) -> Void
    let isFirst: Bool
    let isLast: Bool
    let eventLog: Set<String>

    @State private var displayedText: String = ""
    @State private var isTyping: Bool = false
    @State private var typingTimer: Timer? = nil
    private let typingSpeed: Double = 0.03

    var speakerName: String {
        CharacterRegistry.find(line.speakerId)?.name ?? line.speakerId
    }

    var hasChoices: Bool {
        guard let choices = line.choices else { return false }
        return !choices.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    Text(speakerName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.yellow)

                    Text(displayedText)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)

                    if hasChoices && !isTyping {
                        choicesView
                    }

                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 8)
            }

            if hasChoices && !isTyping {
                EmptyView()
            } else {
                navigationView
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.88))
        .onAppear { startTyping() }
        .onChange(of: line.text) { startTyping() }
    }

    @ViewBuilder
    private var choicesView: some View {
        VStack(spacing: 8) {
            ForEach(line.choices ?? [], id: \.id) { choice in
                let locked = isLocked(choice)
                Button {
                    if !locked { onChoicePicked(choice) }
                } label: {
                    HStack(spacing: 8) {
                        if locked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                        Text(choice.text)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(locked ? .gray : .white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(locked ? Color.white.opacity(0.04) : Color.white.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(locked ? Color.white.opacity(0.08) : Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .disabled(locked)
            }
        }
    }

    private var navigationView: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .foregroundColor(isFirst ? .gray : .white)
            }
            .disabled(isFirst)

            Spacer()

            Button(action: handleNextTap) {
                Text(nextButtonLabel)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 12)
    }

    private var nextButtonLabel: String {
        if isTyping { return "Skip" }
        if isLast   { return "Done" }
        return "Next ▶"
    }

    private func isLocked(_ choice: DialogueChoice) -> Bool {
        guard let required = choice.requiresEvent else { return false }
        return !eventLog.contains(required)
    }

    private func handleNextTap() {
        if isTyping {
            skipTyping()
        } else {
            onNext()
        }
    }

    private func startTyping() {
        typingTimer?.invalidate()
        displayedText = ""
        isTyping = true

        let fullText = line.text
        var charIndex = 0

        typingTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText += String(fullText[index])
                charIndex += 1
            } else {
                timer.invalidate()
                isTyping = false
            }
        }
    }

    private func skipTyping() {
        typingTimer?.invalidate()
        typingTimer = nil
        displayedText = line.text
        isTyping = false
    }

}
