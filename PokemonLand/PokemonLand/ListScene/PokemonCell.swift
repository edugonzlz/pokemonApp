import SwiftUI
import Kingfisher

struct PokemonCell: View {
    
    @ObservedObject var vo: ListViewModel.PokemonCellVo
    
    var body: some View {
        VStack {
            KFImage(vo.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: Constants.margin, leading: Constants.margin,
                                    bottom: Constants.margin, trailing: Constants.margin))
            
            Text(vo.name)
                .font(Font.title)
                .padding(EdgeInsets(top: Constants.margin, leading: 0, bottom: Constants.margin, trailing: 0))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCell(vo: ListViewModel.PokemonCellVo(name: "lalala", imageURL: URL(string: "https://purepng.com/public/uploads/large/purepng.com-pokemonpokemonpocket-monsterspokemon-franchisefictional-speciesone-pokemonmany-pokemonone-pikachu-1701527784812pkckd.png")))
    }
}
