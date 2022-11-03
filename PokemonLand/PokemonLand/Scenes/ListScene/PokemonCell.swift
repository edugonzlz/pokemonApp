import SwiftUI
import Kingfisher

struct PokemonCell: View {
    
    @ObservedObject var vo: ListViewModel.PokemonCellVo
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                FavoriteView(isFavorite: $vo.isFavorite)
                    .padding(8)
                    .onTapGesture {
                        vo.favoriteButtonTapped?()
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
        PokemonCell(vo: .init(name: "Name", imageURL: nil, isFavorite: true))
    }
}
