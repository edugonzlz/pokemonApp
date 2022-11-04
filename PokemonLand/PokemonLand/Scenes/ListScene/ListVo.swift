import Foundation
import Combine
import SwiftUI

extension ListViewModel {
    struct ListVo {
        var items: [PokemonCell.Vo]
        var totalItems: Int
    }
}
