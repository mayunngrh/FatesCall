//
//  CharacterRegistry.swift
//  Fates Call
//
//  Created by Mayun Suryatama on 07/05/26.
//

struct CharacterRegistry {
    
    static let all: [CharacterInfo] = [
        
        CharacterInfo(
            id: "dewi",
            name: "Dewi",
            role: "Fate Teller",
            portraitImage: "portrait_dewi"
        ),
        
        CharacterInfo(
            id: "kakek",
            name: "Kakek Putu",
            role: "Spirit Guide",
            portraitImage: "portrait_kakek"
        ),
        
        CharacterInfo(
            id: "wayan",
            name: "Wayan Santoso",
            role: "Rice Farmer",
            portraitImage: "portrait_wayan"
        ),
        
        CharacterInfo(
            id: "ibu_ketut",
            name: "Ibu Ketut",
            role: "Temple Priestess",
            portraitImage: "portrait_ibu_ketut"
        )
        
    ]
    
    static func find(_ id: String) -> CharacterInfo? {
        all.first { $0.id == id }
    }
    
}
