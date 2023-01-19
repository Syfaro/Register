//
//  TestView.swift
//  Register
//
//  Created by Greg Cordover on 1/19/23.
//

import SwiftUI

enum Field: String, Hashable {
  case first, second, third
}

struct TestView: View {
  @FocusState var focusedField: Field?
  @FocusState var testState: Bool

  var body: some View {
    let _ = Self._printChanges()

    List {
      VStack {
        TextField("First", text: .constant("first"))
          .focused($testState)

        TextField("Second", text: .constant("second"))
          .focused($focusedField, equals: .second)

        TextField("Third", text: .constant("third"))
          .focused($focusedField, equals: .third)

      }.onSubmit {
        switch focusedField {
        case .first:
          focusedField = .second
        case .second:
          focusedField = .third
        case .third:
          focusedField = .first
        case nil: break
        }
      }.onChange(of: testState) { _ in
        testState = true
      }
    }
  }
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TestView()
  }
}
