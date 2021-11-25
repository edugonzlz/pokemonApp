import SwiftUI
import Kingfisher

struct PokemonCell: View {
    
    var vo: ListViewModel.PokemonCellVo
    
    var body: some View {
        VStack {
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
