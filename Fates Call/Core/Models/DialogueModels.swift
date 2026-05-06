//
//  DialogueModels.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

import Foundation

enum CharacterSide {
    case left
    case right
}

struct CharacterPosition {
    let characterId: String
    let side: CharacterSide
    let order: Int
}

struct DialogueLine {
    let speakerId: String
    let text: String
}

struct DialogueScene {
    let id: String
    let cast: [CharacterPosition]
    let lines: [DialogueLine]
}

struct CharacterInfo {
    let id: String
    let name: String
    let role: String
    let portraitImage: String
}
