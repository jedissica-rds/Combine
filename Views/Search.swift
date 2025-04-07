//
//  Search.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 19/09/24.
//

import SwiftUI

import SwiftUI
import Combine

class PokemonSearchViewModel : ObservableObject {
    
        private var cancellables = Set<AnyCancellable>()
        let pokemonService: PokemonService
        @Published var pokemonSuggestion : [PokemonSuggestion] = []
        @Published var input : String = ""
        
        init(pokemonService: PokemonServiceProtocol) {
            self.pokemonService = pokemonService as! PokemonService
            getInput()
        }
    
    
        func getInput() {
            $input
                .debounce(for: 0.1, scheduler: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] returnedInput in
                    self?.fetchPokemon(name : returnedInput)
                }
                .store(in: &cancellables)

        }
        
        func fetchPokemon(name : String) {
            pokemonService.getAllPokemon()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error):
                            print("Error fetching pokemon: \(error)")
                        case .finished:
                            break
            }}, receiveValue: {[weak self] data in
                self?.pokemonSuggestion = data.results.filter {
                    $0.name.hasPrefix(name.lowercased())
                }
            }).store(in: &cancellables)
        }
}


struct Search: View {
    
    @StateObject var vm = PokemonSearchViewModel(pokemonService: PokemonService())
    @State private var inputWord: String = ""
    
    
    var body: some View {
        NavigationStack{
            TextField("Enter a Word", text: $vm.input)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(30)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(vm.pokemonSuggestion, id: \.name) { pokemon in
                        NavigationLink(destination: Update(name: pokemon.name)){
                            Text("\(pokemon.name)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Search()
}
