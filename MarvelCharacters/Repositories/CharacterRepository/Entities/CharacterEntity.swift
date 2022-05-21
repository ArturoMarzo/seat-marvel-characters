struct CharactersListResponseEntity: Codable {
    let data: CharactersListDataEntity?
}

struct CharactersListDataEntity: Codable {
    let results: [CharacterEntity]?
    let total: Int?
}

struct CharacterEntity: Codable {
    let id: UInt?
    let name: String?
    let description: String?
    let thumbnail: ImageEntity?
}
