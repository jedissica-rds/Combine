//
//  Password.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 22/09/24.
//

import Foundation
import SwiftUI
import Combine

class PasswordConditions: ObservableObject {
    @Published var password : String = ""
    var cancellables = Set<AnyCancellable>()
    
    @Published var isLenghtValid : Bool = false
    @Published var isCapitalLetterValid : Bool = false
    @Published var isNumeralValid : Bool = false
    @Published var isSpecialCharacterValid : Bool = false
    @Published var isPasswordValid : Bool = false

    init() {
        passwordLenghtValidation()
        passwordCapitalLetterValidation()
        passwordNumeralValidation()
        passwordSpecialCharacterValidation()
        passwordValidation()
    }
    
    
    func isCapitalLetter(text : String) -> Bool{
        let upperCaseLetters = CharacterSet.uppercaseLetters
        
        if text.rangeOfCharacter(from: upperCaseLetters) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func isNumeral(text : String) -> Bool{
        let numerals = CharacterSet.decimalDigits
        
        if text.rangeOfCharacter(from: numerals) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func isSpecialCharacter(text : String) -> Bool{
        let specialCharacter = CharacterSet.init(charactersIn: "@#$%")
        
        if text.rangeOfCharacter(from: specialCharacter) != nil{
            return true
        }
        else {
            return false
        }
    }
    
    func passwordLenghtValidation(){
        $password
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map{ (text) -> Bool in
                if text.count >= 6 {
                    return true
                }
                return false
            }
            .sink(receiveValue: {
                [weak self] (isValid) in
                guard let self else {return}
                self.isLenghtValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func passwordCapitalLetterValidation(){
        $password
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map{ (text) -> Bool in
                if self.isCapitalLetter(text: text) {
                    return true
                }
                return false
            }
            .sink(receiveValue: {
                [weak self] (isValid) in
                guard let self else {return}
                self.isCapitalLetterValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func passwordNumeralValidation(){
        $password
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map{ (text) -> Bool in
                if self.isNumeral(text: text){
                    return true
                }
                return false
            }
            .sink(receiveValue: {
                [weak self] (isValid) in
                guard let self else {return}
                self.isNumeralValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func passwordSpecialCharacterValidation(){
        $password
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map{ (text) -> Bool in
                if self.isSpecialCharacter(text: text){
                    return true
                }
                return false
            }
            .sink(receiveValue: {
                [weak self] (isValid) in
                guard let self else {return}
                self.isSpecialCharacterValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func passwordValidation() {
        Publishers.CombineLatest4($isLenghtValid, $isCapitalLetterValid, $isNumeralValid, $isSpecialCharacterValid)
            .map { lengthValid, capitalLetterValid, numeralValid, specialCharacterValid in
                return lengthValid && capitalLetterValid && numeralValid && specialCharacterValid
            }
            .sink { [weak self] isValid in
                self?.isPasswordValid = isValid
            }
            .store(in: &cancellables)
    }

}

struct Password: View {
    @StateObject var vm = PasswordConditions()
    
    var body: some View {
        VStack{
            TextField("Password", text: $vm.password)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(30)
            
            LazyVStack{
                
                if !vm.isLenghtValid && vm.password.count >= 1{
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.red)
                        Text("the length must be greater than 6 digits.")
                            .font(.caption)
                    }.padding(.trailing)}
                
                if !vm.isCapitalLetterValid && vm.password.count >= 1{
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.red)
                        Text("the password must contain a capital letter.")
                            .font(.caption)
                    }.padding(.trailing)}
                
                if !vm.isSpecialCharacterValid && vm.password.count >= 1{
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.red)
                        Text("the password must contain a special character.")
                            .font(.caption)
                    }.padding(.trailing)}
                
                if !vm.isNumeralValid && vm.password.count >= 1{
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.red)
                        Text("the password must contain a numeral.")
                            .font(.caption)
                    }.padding(.trailing)}
                
                
                if vm.isPasswordValid && vm.password.count >= 1{
                    HStack() {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                        Text("the password is alright")
                            .font(.caption)
                    }.padding(.trailing)}
            }
        }
    }
}

#Preview {
    Password()
}

