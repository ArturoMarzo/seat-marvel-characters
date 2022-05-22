import UIKit

// Using struct instead of a class to store character information prevents mutability
struct CharacterDetailViewModel {
    let name: String
    let description: String?
    let imageURL: String?
    let comics: [CharacterDetailComic]?
    let availableComics: Int
    let series: [CharacterDetailSerie]?
    let availableSeries: Int
    let stories: [CharacterDetailStory]?
    let availableStories: Int
    
    init(characterDetail: CharacterDetailModel) {
        self.name = characterDetail.name
        self.description = characterDetail.description
        self.imageURL = characterDetail.imageURL
        self.comics = characterDetail.comics
        self.availableComics = characterDetail.availableComics
        self.series = characterDetail.series
        self.availableSeries = characterDetail.availableSeries
        self.stories = characterDetail.stories
        self.availableStories = characterDetail.availableStories
    }
}

class CharacterDetailViewModelBuilder: CharacterDetailViewModelBuilderContract {
    func buildViewModel(characterDetail: CharacterDetailModel) -> CharacterDetailViewModel {
        return CharacterDetailViewModel(characterDetail: characterDetail)
    }
}
