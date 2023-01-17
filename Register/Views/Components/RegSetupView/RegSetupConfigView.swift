//
//  RegSetupConfigView.swift
//  Register
//

import ComposableArchitecture
import SwiftUI

struct RegSetupConfigFeature: ReducerProtocol {
  @Dependency(\.apis) var apis

  struct State: Equatable {
    var registerRequest = RegisterRequest()
    var isLoading = false

    var isRegistrationDisabled: Bool {
      isLoading || !registerRequest.isReady
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case registerTerminal
    case registered(TaskResult<Config>)
  }

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .registerTerminal:
        state.isLoading = true
        let req = state.registerRequest
        return .task {
          let req = req
          do {
            let config = try await apis.registerTerminal(req)
            try await ConfigLoader.saveConfig(config)
            return .registered(.success(config))
          } catch {
            return .registered(.failure(error))
          }
        }
      case .registered:
        state.isLoading = false
        return .none
      }
    }
  }
}

struct RegSetupConfigView: View {
  let store: StoreOf<RegSetupConfigFeature>

  var body: some View {
    WithViewStore(store) { viewStore in
      Section("Terminal Registration") {
        TextField(
          text: viewStore.binding(\.registerRequest.$terminalName),
          prompt: Text("Terminal Name")
        ) {
          Text("Terminal Name")
        }
        .textInputAutocapitalization(.never)

        TextField(
          text: viewStore.binding(\.registerRequest.$host),
          prompt: Text("APIS Host")
        ) {
          Text("APIS Host")
        }
        .keyboardType(.URL)
        .textInputAutocapitalization(.never)

        SecureField(
          text: viewStore.binding(\.registerRequest.$token),
          prompt: Text("APIS Token")
        ) {
          Text("APIS Token")
        }

        Button {
          viewStore.send(.registerTerminal)
        } label: {
          HStack(spacing: 8) {
            Text("Register Terminal")

            if viewStore.isLoading {
              ProgressView()
            }
          }
        }.disabled(viewStore.isRegistrationDisabled)
      }.disabled(viewStore.isLoading)
    }
  }
}

struct RegSetupConfigView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      RegSetupConfigView(
        store: Store(
          initialState: .init(),
          reducer: RegSetupConfigFeature()
        ))
    }
    .previewLayout(.fixed(width: 400, height: 400))
    .previewDisplayName("Invalid Config")

    Form {
      RegSetupConfigView(
        store: Store(
          initialState: .init(isLoading: true),
          reducer: RegSetupConfigFeature()
        ))
    }
    .previewLayout(.fixed(width: 400, height: 400))
    .previewDisplayName("Loading Config")

    Form {
      RegSetupConfigView(
        store: Store(
          initialState: .init(
            registerRequest: RegisterRequest(
              terminalName: "Terminal Name",
              host: "http://www.google.com",
              token: "Token"
            )
          ),
          reducer: RegSetupConfigFeature()
        ))
    }
    .previewLayout(.fixed(width: 400, height: 400))
    .previewDisplayName("Good Config")
  }
}
