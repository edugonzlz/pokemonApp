import SwiftUI

struct ConnectionStatusView: View {
    var body: some View {
        ZStack {
            Color.blue
                .padding(.zero)
            Text("Network not available")
                .padding(.zero)
                .foregroundColor(.white)
        }
        .frame(width: nil, height: 20, alignment: .center)
    }
}
