import AccessAssociatedValue

@AccessAssociatedValue
enum ViewState {
    case loading(hasIndicator: Bool)
    case loaded(cards: [String], hasIndicator: Bool)
    case failed(hasIndicator: Bool)
}

let viewStateInLoading = ViewState.loading(hasIndicator: true)
print(viewStateInLoading.loading) // Optional(true)
print(viewStateInLoading.loaded) // nil

let viewStateInLoaded = ViewState.loaded(cards: ["Card1", "Card2"], hasIndicator: false)
print(viewStateInLoaded.loaded) // Optional((cards: ["Card1", "Card2"], hasIndicator: false))
print(viewStateInLoaded.loaded?.cards) // Optional(["Card1", "Card2"])
print(viewStateInLoaded.loading) // nil

