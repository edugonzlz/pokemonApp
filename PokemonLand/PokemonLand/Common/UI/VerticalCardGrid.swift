import SwiftUI

struct VerticalCardGrid<Content: View>: View {

    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: config(viewWidth: proxy.size.width),
                          spacing: Constants.margin) {
                    content()
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: Constants.margin,
                             bottom: 0, trailing: Constants.margin))
    }
}

// MARK: - Private
private extension VerticalCardGrid {
    struct Constants {
        static var margin: CGFloat {
            10
        }
        static var cellHeight: CGFloat {
            250
        }
        static func cellWidth(viewWidth: CGFloat) -> CGFloat {
            return (viewWidth - margin * 3)/2
        }
    }

    func config(viewWidth: CGFloat) -> [GridItem] {
        return [GridItem(.adaptive(minimum: Constants.cellWidth(viewWidth: viewWidth)))]
    }
}
