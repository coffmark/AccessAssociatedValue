import AccessAssociatedValue

@AccessAssociatedValue
enum ViewState {
    case loading(hasIndicator: Bool)
    case loaded(cards: [String], hasIndicator: Bool)
    case failed(hasIndicator: Bool)
}

let viewStateInLoading = ViewState.loading(hasIndicator: true)
print(viewStateInLoading.loading ?? "nil") // Optional(true)
print(viewStateInLoading.loaded ?? "nil") // nil

let viewStateInLoaded = ViewState.loaded(cards: ["Card1", "Card2"], hasIndicator: false)
print(viewStateInLoaded.loaded ?? "nil") // Optional((cards: ["Card1", "Card2"], hasIndicator: false))
print(viewStateInLoaded.loaded?.cards ?? "nil") // Optional(["Card1", "Card2"])
print(viewStateInLoaded.loading ?? "nil") // nil

