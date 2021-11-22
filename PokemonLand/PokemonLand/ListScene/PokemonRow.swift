import SwiftUI

struct PokemonRow: View {
    
    var vo: ListViewModel.PokemonCellVo

    var body: some View {
        Text(vo.name)
            .font(Font.system(size: 10))
    }
}
