import SwiftUI
import Kingfisher

struct PokemonCell: View {

    @ObservedObject var vo: Vo
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                FavoriteView(isFavorite: $vo.isFavorite)
                    .padding(Constants.padding)
                    .onTapGesture {
                        vo.favoriteButtonTapped()
                    }
            }

            KFImage(vo.imageURL)
                .resizable()
                .scaledToFit()
                .frame(height: Constants.imageHeight)
                .shadow(radius: Constants.radius)
                .padding(0)

            VStack {
                Text(vo.name)
                    .font(Font.title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(EdgeInsets(top: 0,
                                        leading: Constants.padding,
                                        bottom: Constants.padding,
                                        trailing: Constants.padding))
            }
            .frame(height: Constants.nameHeight)
            .padding(0)
        }
        .background(.red)
        .cornerRadius(Constants.radius)
    }
}

// MARK: - Private
private extension PokemonCell {
    struct Constants {
        static let padding: CGFloat = 10
        static let radius: CGFloat = 10
        static let imageHeight: CGFloat = 140
        static let nameHeight: CGFloat = 80
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
        PokemonCell(vo: .init(id: 1, name: "Torpedo de la praderarrr, pecador, jarr", imageURL: nil, isFavorite: true, favoriteButtonTapped: {}))
    }
}
