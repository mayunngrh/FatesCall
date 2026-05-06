//
//  Act1DialogueData.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

struct Act1DialogueData {
    
    static let allScenes: [DialogueScene] = [
        scene_case1_appointment
    ]
    
    static let scene_case1_appointment = DialogueScene(
        id: "act1_case1_appointment",
        cast: [
            CharacterPosition(characterId: "wayan", side: .left,  order: 0),
            CharacterPosition(characterId: "dewi",  side: .right, order: 0)
        ],
        lines: [
            DialogueLine(
                speakerId: "wayan",
                text: "Tuan... I don't know who else to turn to. My family is suffering."
            ),
            DialogueLine(
                speakerId: "dewi",
                text: "Tell me everything. When did this begin?"
            ),
            DialogueLine(
                speakerId: "wayan",
                text: "Three days ago. First the chickens died, then the crops started withering."
            ),
            DialogueLine(
                speakerId: "dewi",
                text: "Don't worry. We will find the truth together."
            )
        ]
    )
    
}
