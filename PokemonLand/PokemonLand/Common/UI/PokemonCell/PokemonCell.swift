import SwiftUI
import Kingfisher

struct PokemonCell: View {
    class Vo: ObservableObject {
        let id: Int
        let name: String
        let imageURL: URL?
        @Published var isFavorite: Bool
        var favoriteButtonTapped: () -> Void

        init(id: Int, name: String, imageURL: URL? = nil, isFavorite: Bool, favoriteButtonTapped: @escaping () -> Void) {
            self.id = id
            self.name = name
            self.imageURL = imageURL
            self.isFavorite = isFavorite
            self.favoriteButtonTapped = favoriteButtonTapped
        }
    }

    @ObservedObject var vo: Vo
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                FavoriteView(isFavorite: $vo.isFavorite)
                    .padding(8)
                    .onTapGesture {
                        vo.favoriteButtonTapped()
                    }
            }

            KFImage(vo.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: Constants.padding, leading: Constants.padding,
                                    bottom: Constants.padding, trailing: Constants.padding))
                .shadow(radius: 10)
            
            Text(vo.name)
                .font(Font.title)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(EdgeInsets(top: Constants.padding, leading: Constants.padding/2,
                                    bottom: Constants.padding, trailing: Constants.padding/2))
        }
        .background(.red)
        .cornerRadius(10)
    }
}

private extension PokemonCell {
    struct Constants {
        static let padding: CGFloat = 10
    }
}

private struct FavoriteView: View {

    @Binding var isFavorite: Bool

    var body: some View {
        isFavorite ?
        Image(systemName: "star.fill")
            .tint(.yellow) :
        Image(systemName: "star")
            .tint(.gray)
    }
}

struct PokemonCell_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCell(vo: .init(id: 1, name: "Name", imageURL: nil, isFavorite: true, favoriteButtonTapped: {}))
    }
}

extension PokemonCell.Vo: Identifiable {
    static func == (lhs: PokemonCell.Vo, rhs: PokemonCell.Vo) -> Bool {
        return lhs.name == rhs.name
    }
}

extension PokemonCell.Vo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
