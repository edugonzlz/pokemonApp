import SwiftUI
import Kingfisher

struct PokemonCell: View {
    
    var vo: ListViewModel.PokemonCellVo
    
    var body: some View {
        VStack {
            KFImage(vo.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: Constants.margin, leading: Constants.margin,
                                    bottom: Constants.margin, trailing: Constants.margin))
                .shadow(radius: 10)
            
            Text(vo.name)
                .font(Font.title)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: Constants.margin, leading: 0,
                                    bottom: Constants.margin, trailing: 0))
        }
        .background(.red)
        .cornerRadius(10)
    }
}

private extension PokemonCell {
    struct Constants {
        static let margin: CGFloat = 10
    }
}
