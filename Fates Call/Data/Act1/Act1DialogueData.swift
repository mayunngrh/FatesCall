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

    // Scene opens in consultation room, travels to Wayan's house, returns to consultation room
    static let scene_case1_appointment = DialogueScene(
        id: "act1_case1_appointment",
        background: "bg_consultation_room",
        cast: [
            CharacterPosition(characterId: "wayan", side: .left,  order: 0),
            CharacterPosition(characterId: "dewi",  side: .right, order: 0)
        ],
        lines: [
            // — Consultation room —
            DialogueLine(
                speakerId: "wayan",
                text: "Tuan... I don't know who else to turn to. My family is suffering.",
                expressions: ["dewi": "blush_sad"],
                sfx: "sfx_ambient_wind.mp3"
            ),
            DialogueLine(
                speakerId: "dewi",
                text: "Tell me everything. When did this begin?",
                expressions: ["dewi": "blush_afraid"]
            ),
            DialogueLine(
                speakerId: "wayan",
                text: "Three days ago. First the chickens died, then the crops started withering.",
                expressions: ["dewi": "surprised"],
                sfx: "sfx_suspense_sting.mp3"
            ),

            // — Cut to Wayan's house —
            DialogueLine(
                speakerId: "kakek",
                text: "I heard everything from outside. This is no ordinary misfortune.",
                cast: [
                    CharacterPosition(characterId: "wayan", side: .left,  order: 0),
                    CharacterPosition(characterId: "dewi",  side: .right, order: 1),
                    CharacterPosition(characterId: "kakek", side: .right, order: 0)
                ],
                expressions: ["dewi": "surprised"],
                background: "bg_wayan_house",
                sfx: "sfx_door_creak.mp3"
            ),
            DialogueLine(
                speakerId: "dewi",
                text: "Grandfather... you came.",
                expressions: ["dewi": "blush_happy"]
            ),
            DialogueLine(
                speakerId: "kakek",
                text: "Yes child... a very dark presence has passed through this place.",
                expressions: ["dewi": "blush_afraid"]
            ),

            // First choice — picking "trust the spirits" unlocks a secret option later
            DialogueLine(
                speakerId: "dewi",
                text: "How do you wish to handle this, Grandfather?",
                expressions: ["dewi": "blush_sad"],
                choices: [
                    DialogueChoice(
                        id: "choice_trust_spirits",
                        text: "We trust the spirits and perform the ritual.",
                        grantsEvent: "trusted_spirits"
                    ),
                    DialogueChoice(
                        id: "choice_investigate",
                        text: "We investigate further before acting."
                    )
                ]
            ),

            // — Back to consultation room — Wayan leaves, Dewi moves left
            DialogueLine(
                speakerId: "dewi",
                text: "Wayan, please wait outside. We need to speak privately.",
                cast: [
                    CharacterPosition(characterId: "dewi",  side: .left,  order: 0),
                    CharacterPosition(characterId: "kakek", side: .right, order: 0)
                ],
                expressions: ["dewi": "blush_sad"],
                background: "bg_consultation_room"
            ),
            DialogueLine(
                speakerId: "kakek",
                text: "What I sense here... it will not be easy to undo.",
                expressions: ["dewi": "blush_afraid"],
                sfx: "sfx_temple_bells.mp3"
            ),

            // Second choice — third option locked unless player chose "trust the spirits" earlier
            DialogueLine(
                speakerId: "kakek",
                text: "There is one more thing we can do. But it requires great courage.",
                expressions: ["kakek": "solemn", "dewi": "blush_afraid"],
                choices: [
                    DialogueChoice(
                        id: "choice_face_it",
                        text: "We face it head on."
                    ),
                    DialogueChoice(
                        id: "choice_wait",
                        text: "We wait and observe."
                    ),
                    DialogueChoice(
                        id: "choice_invoke_ancestors",
                        text: "Invoke the ancestors... I know the way.",
                        requiresEvent: "trusted_spirits"
                    )
                ]
            )
        ]
    )

}
