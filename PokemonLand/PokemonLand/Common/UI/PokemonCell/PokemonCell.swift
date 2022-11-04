import SwiftUI
import Kingfisher

struct PokemonCell: View {

    @ObservedObject var vo: Vo
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                FavoriteView(isFavorite: $vo.isFavorite)
                    .padding(EdgeInsets(top: Constants.padding, leading: Constants.padding,
                                        bottom: 0, trailing: Constants.padding))
                    .onTapGesture {
                        vo.favoriteButtonTapped()
                    }
            }

            KFImage(vo.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: 0, leading: Constants.padding,
                                    bottom: 0, trailing: Constants.padding))
                .shadow(radius: Constants.radius)
            
            Text(vo.name)
                .font(Font.title)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(EdgeInsets(top: 0, leading: Constants.padding/2,
                                    bottom: Constants.padding, trailing: Constants.padding/2))
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
