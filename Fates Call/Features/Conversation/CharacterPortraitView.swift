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
    
    var character: CharacterInfo? {
        CharacterRegistry.find(position.characterId)
    }
    
    var mirrorEffect: CGFloat {
        position.side == .right ? -1 : 1
    }

    var portraitOpacity: Double {
        isActive ? 1.0 : 0.45
    }
    
    var portraitOffset: CGFloat {
        isActive ? -12 : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 180)
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .scaleEffect(x: mirrorEffect, y: 1)
                .opacity(portraitOpacity)
                .offset(y: portraitOffset)
                .animation(.easeInOut(duration: 0.25), value: isActive)
            
            // Character name
            if let character = character {
                Text(character.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isActive ? .white : .gray)
                    .animation(.easeInOut(duration: 0.25), value: isActive)
            }
            
        }
    }
    
}
