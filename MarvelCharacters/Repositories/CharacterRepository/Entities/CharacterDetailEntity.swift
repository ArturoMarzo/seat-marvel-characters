struct CharacterDetailResponseEntity: Codable {
    let data: CharacterDetailDataEntity?
}

struct CharacterDetailDataEntity: Codable {
    let results: [CharacterDetailEntity]?
}

struct CharacterDetailEntity: Codable {
    let id: UInt?
    let name: String?
    let description: String?
    let thumbnail: ImageEntity?
    let comics: ComicsEntity?
    let series: SeriesEntity?
    let stories: StoriesEntity?
    
    struct ComicsEntity: Codable {
        let available: Int
        let items: [CharacterDetailComicEntity]
    }

    struct CharacterDetailComicEntity: Codable {
        let name: String
    }

    struct SeriesEntity: Codable {
        let available: Int
        let items: [CharacterDetailSerieEntity]
    }

    struct CharacterDetailSerieEntity: Codable {
        let name: String
    }

    struct StoriesEntity: Codable {
        let available: Int
        let items: [CharacterDetailStoryEntity]
    }

    struct CharacterDetailStoryEntity: Codable {
        let name: String
    }

}
