//
// Copyright (c) 2025, ___ORGANIZATIONNAME___ All rights reserved.
//
//

import SwiftUI
import FoundationModels
struct GenerativeView: View {
  private var model = SystemLanguageModel.default

  @State private var prompt: String = "Write me a story about coffee."
  @State private var output: String = ""
  @State private var session:LanguageModelSession? = nil
  @State private var  instructions = """
      Suggest related topics. Keep them concise (three to seven words) and make sure they \
      build naturally from the person's topic.
      """

  @State private var isGenerating = false
  @State private var errorMessage: String? = nil
  
  var body: some View {

    switch model.availability {
    case .available:
      // Show your intelligence UI.
      VStack(alignment: .leading, spacing: 16) {
        Text("available")
          .font(.headline)

        VStack(alignment: .leading, spacing: 8) {
          Text("Prompt")
            .font(.subheadline)
          TextField("Enter prompt", text: $prompt, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(3, reservesSpace: true)
        }

        HStack {
          Button {
            Task {
              await generate()
            }
          } label: {
            if isGenerating {
              ProgressView()
            } else {
              Text("Generate")
            }
          }
          .buttonStyle(.borderedProminent)
          .disabled(isGenerating || prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }

        if let errorMessage {
          Text(errorMessage)
            .foregroundStyle(.red)
        }

        VStack(alignment: .leading, spacing: 8) {
          Text("Output")
            .font(.subheadline)
          ScrollView {
            Text(output)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .frame(minHeight: 120)
        }

        Spacer()
      }
      .padding()
    case .unavailable(.deviceNotEligible):
      // Show an alternative UI.
      Text("deviceNotEligible")
    case .unavailable(.appleIntelligenceNotEnabled):
      // Ask the person to turn on Apple Intelligence.
      Text("appleIntelligenceNotEnabled")
    case .unavailable(.modelNotReady):
      // The model isn't ready because it's downloading or because of other system reasons.
      Text("modelNotReady")
    case .unavailable(let _):
      // The model is unavailable for an unknown reason.
      Text("unavailable ")
    }
  }

  private func generate() async {
    errorMessage = nil
    isGenerating = true
    defer { isGenerating = false }

    if session == nil {
      session = LanguageModelSession(instructions: instructions)
    }

    guard let session = session else {
      return
    }
    do {
      // Create session options as needed. Adjust to your API surface if different.
//      var options = InferenceOptions()
      let options = GenerationOptions(temperature: 2.0)

      let promptText = prompt.isEmpty ? "Write me a story about coffee." : prompt
      let response = try await session.respond(
        to: promptText,
        options: options
      )

      // If `response` is a string, assign directly; otherwise, convert as needed.
      self.output = String(describing: response)
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }
}

#Preview {
  GenerativeView()
}
