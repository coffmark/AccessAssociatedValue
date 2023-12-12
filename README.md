# `@AccessAssociatedValue` Macros

```swift
@AccessAssociatedValue
enum ViewState {
  case loading(isInticator: Bool)
  case success(cards: [String], isIndicator: Bool)
  case failed(isIndicator: Bool)
}

let viewState = ViewState.success(cards: ["Card1", "Card2"], isIndicator: false)
print(viewState.loading) // nil
print(viewState.success?.cards) // ["Card1", "Card2"]
```
- Easy to access associated value
- Type safe

## How to Use

1. File > Add to Packages
2. Search `https://github.com/coffmark/AccessAssociatedValue`
3. Select Project

## Contributed

Contributions are always welcome!
