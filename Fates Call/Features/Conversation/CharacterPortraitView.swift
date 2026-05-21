//
//  CharacterPortraitView.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

import SwiftUI

struct CharacterPortraitView: View {

    let position: CharacterPosition
    let isActive: Bool
    var expression: String? = nil

    var character: CharacterInfo? {
        CharacterRegistry.find(position.characterId)
    }

    var portraitImageName: String? {
        guard let character else { return nil }
        if let expression,
           UIImage(named: "\(character.portraitImage)_\(expression)") != nil {
            return "\(character.portraitImage)_\(expression)"
        }
        return character.portraitImage
    }
    
    var mirrorEffect: CGFloat {
        position.side == .right ? -1 : 1
    }

    var horizontalOffset: CGFloat {
        guard isActive else { return 0 }
        // left side shifts right (toward center)
        // right side shifts left (toward center)
        return position.side == .left ? 12 : -12
    }

    var portraitScale: CGFloat {
        position.order == 0 ? 1.0 : 0.82
    }

    var verticalOffset: CGFloat {
        position.order == 0 ? 0 : 24
    }

    var stackOffset: CGFloat {
        let direction: CGFloat = position.side == .left ? -1 : 1
        return position.order == 0 ? 0 : direction * 30
    }
    
    var portraitOpacity: Double {
        if isActive { return 1.0 }
        return position.order == 0 ? 0.55 : 0.35
    }
    
    var body: some View {
        Group {
            if let imageName = portraitImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.3))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .scaleEffect(x: mirrorEffect * portraitScale,
                     y: portraitScale, anchor: .bottom)
        .opacity(portraitOpacity)
        .offset(x: stackOffset + horizontalOffset, y: verticalOffset)
        .animation(.easeInOut(duration: 0.3), value: isActive)
    }
    
}
