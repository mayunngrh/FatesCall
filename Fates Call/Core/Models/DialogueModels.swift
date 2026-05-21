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

struct DialogueChoice {
    let id: String
    let text: String
    var grantsEvent: String? = nil      // adds this event to the log when chosen
    var requiresEvent: String? = nil    // locked unless this event is already in the log
}

struct DialogueLine {
    let speakerId: String
    let text: String
    var cast: [CharacterPosition]? = nil        // if set, overrides the active cast from this line onward
    var expressions: [String: String]? = nil    // characterId → emotion, overrides from this line onward
    var background: String? = nil               // image name, overrides background from this line onward
    var sfx: String? = nil                      // sound file name to play when this line starts
    var choices: [DialogueChoice]? = nil        // if set, renders choice buttons instead of Next
}

struct DialogueScene {
    let id: String
    let background: String                // initial background image when scene opens
    let cast: [CharacterPosition]         // initial cast when scene opens
    let lines: [DialogueLine]
}

struct CharacterInfo {
    let id: String
    let name: String
    let role: String
    let portraitImage: String
}
