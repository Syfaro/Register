//
//  PaymentLineItem.swift
//  Register
//

import SwiftUI

struct PaymentLineBadgeView: View {
  let name: String
  let badgeName: String
  let levelName: String
  let price: Decimal
  let discountedPrice: Decimal?

  var isDiscounted: Bool {
    guard let discountedPrice = discountedPrice else {
      return false
    }

    return discountedPrice != price
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(name)
        Text(levelName + " Registration")

        Text("\"\(badgeName)\"")
          .bold()
      }

      Spacer()

      VStack(alignment: .trailing) {
        Text(price, format: .currency(code: "USD"))
          .strikethrough(isDiscounted)
          .foregroundColor(isDiscounted ? .secondary : .primary)

        if let discountedPrice = discountedPrice, isDiscounted {
          Text(discountedPrice, format: .currency(code: "USD"))
        }
      }
    }
  }
}

struct PaymentBadgeLine_Previews: PreviewProvider {
  static var previews: some View {
    PaymentLineBadgeView(
      name: "First Last",
      badgeName: "Fancy Name",
      levelName: "Sponsor",
      price: 175,
      discountedPrice: nil
    ).previewDisplayName("Standard Badge")

    PaymentLineBadgeView(
      name: "First Last",
      badgeName: "Fancy Name",
      levelName: "Sponsor",
      price: 175,
      discountedPrice: 150
    ).previewDisplayName("Discounted Badge")
  }
}
