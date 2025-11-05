//
// Copyright (c) 2025, ___ORGANIZATIONNAME___ All rights reserved. 
// 
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
          GenerativeView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
