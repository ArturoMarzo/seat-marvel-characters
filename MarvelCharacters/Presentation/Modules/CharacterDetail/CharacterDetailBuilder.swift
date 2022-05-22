import UIKit

class CharacterDetailBuilder: BaseBuilder, CharacterDetailBuilderContract {
    var router: CharacterDetailRouterContract?
    var interactorManager: CharacterDetailInteractorManagerContract?
    var presenter: CharacterDetailPresenterContract?
    var view: CharacterDetailViewContract?
    var viewModelBuilder: CharacterDetailViewModelBuilderContract?
    
    // MARK: - CharacterDetailBuilder protocol
    func buildCharacterDetailModuleWith(characterId: UInt) -> UIViewController? {
        buildView()
        buildRouter()
        buildInteractorWith(characterId: characterId)
        buildViewModelBuilder()
        buildPresenter()
        buildCircularDependencies()
        
        return view as? UIViewController
    }
    
    // MARK: - Private
    private func buildView() {
        view = CharacterDetailViewController()
    }
    
    private func buildRouter() {
        guard let view = self.view as? UIViewController else {
            assert(false, "View has to be a UIViewController")
            return
        }
        
        router = CharacterDetailRouter(viewController: view)
    }
    
    private func buildInteractorWith(characterId: UInt) {
        interactorManager =
        CharacterDetailInteractorManager(characterId: characterId,
                                         characterRepository: repositoriesContainer.characterRepository)
    }
    
    private func buildViewModelBuilder() {
        viewModelBuilder = CharacterDetailViewModelBuilder()
    }
    
    private func buildPresenter() {
        guard let interactorManager = interactorManager,
              let router = router,
              let view = view,
              let viewModelBuilder = viewModelBuilder  else {
                  assert(false, "No dependencies available")
                  return
              }
        
        presenter = CharacterDetailPresenter(interactorManager: interactorManager,
                                             router: router,
                                             view: view,
                                             viewModelBuilder: viewModelBuilder)
    }
    
    private func buildCircularDependencies() {
        guard let presenter = presenter, let view = view as? CharacterDetailViewController else {
            assert(false, "No dependencies available")
            return
        }
        
        view.presenter = presenter
    }
}
