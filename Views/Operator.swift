//
//  Operator.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 20/09/24.
//

import Foundation
import Combine
import SwiftUI

extension Publisher where Output == [Team] {

    func rank() -> AnyPublisher<[Team], Failure> {
        return self
            .map { value in
                value.sorted { $0.score > $1.score }
            }
        .eraseToAnyPublisher()
    }
}

class TeamScoreViewModel : ObservableObject {
    
    @Published var rank : [Team] = []
    @Published var flamengo : Team = Team(name: "Flamengo", score: 0)
    @Published var vasco : Team = Team(name: "Vasco", score: 0)
    @Published var sp : Team = Team(name: "São Paulo", score: 0)
    @Published var palmeiras : Team = Team(name: "Palmeiras", score: 0)
    
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addScores()
        defineRank()
    }
    
    func addScores() {
        
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { value in
            self.flamengo.score += 1
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { value in
            self.vasco.score += 5
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { value in
            self.sp.score += 8
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { value in
            self.palmeiras.score += 1
        }
    }
    
    func defineRank(){
        $flamengo
            .combineLatest($sp, $palmeiras, $vasco)
            .map { value1, value2, value3, value4 in
                        return [value1, value2, value3, value4]
                    }
            .rank()
            .sink(receiveValue: { value in
                self.rank = value
            })
            .store(in: &cancellables)
    }
}


struct TeamScore: View {
    
    @StateObject var vm = TeamScoreViewModel()
    @State private var inputWord: String = ""
    
    
    var body: some View {
        
        ScrollView {
            
            
            LazyVStack(alignment: .center) {
                Text("\(vm.flamengo.name) | \(vm.flamengo.score)  X \(vm.vasco.score) | \(vm.vasco.name)")
                Text("\(vm.palmeiras.name) | \(vm.palmeiras.score)  x  \(vm.sp.score) | \(vm.sp.name)")
            }
            
            Text("RANKING")
            LazyVStack(alignment: .center) {
                ForEach(vm.rank, id: \.name) { team in
                    Text("\(team.name.uppercased())")
                }
            }
        }
    }
}



#Preview {
    Search()
}

