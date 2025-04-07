//
//  Update.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 23/09/24.
//

import SwiftUI
import Combine


class UpdateViewlModel : ObservableObject {
    
    @Published var pokemon : Pokemon = Pokemon(id: 1, name: "", baseExperience: 1, height: 1, isDefault: true, order: 1, weight: 1, abilities: [], forms: [], gameIndices: [], heldItems: [], locationAreaEncounters: "", moves: [], species: Species(name: "", url: ""), sprites: Sprites(backDefault: "", backFemale: nil, backShiny: "", backShinyFemale: nil, frontDefault: "", frontFemale: nil, frontShiny: "", frontShinyFemale: nil, other: nil, versions: nil, animated: nil), cries: Cries(latest: "", legacy: ""), stats: [], types: [], pastTypes: [])
    
    var cancellables = Set<AnyCancellable>()
    var service = PokemonService()
    
    init(){

    }
    
    func getPokemon(name : String){
        service.getPokemon(name: name)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching pokemon: \(error)")
                }
            } receiveValue: { pokemon in
                self.pokemon = pokemon
            }
            .store(in: &cancellables)
    }
}

struct Update: View {
    var name : String?
    @StateObject var vm = UpdateViewlModel()
    
    var body: some View {
        
        ScrollView {
            Text("\(String(describing: vm.pokemon.name))")
        }
        .onAppear() {
            vm.getPokemon(name: name!)
            }
        }
    }


#Preview {
    Update(name: "ditto")
}
