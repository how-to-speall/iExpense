//
//  ContentView.swift
//  iExpense
//
//  Created by Ahoura Bagherikhoshkroudi on 2024-08-21.
//

import SwiftUI


struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let ammount: Double
}


@Observable
class Expense{
    var personal: [ExpenseItem]{
        item.filter {
            $0.type == "Personal"
        }
    }
    
    var business: [ExpenseItem]{
        item.filter {
            $0.type == "Business"
        }
    }
    
    var item = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(item){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                item = decodedItems
                return
            }
        }
        item = []
    }
}



struct ContentView: View {
    
    @State private var expenses = Expense()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading){
                Text("iExpense").font(.largeTitle).bold().padding()
                
                HStack{
                    VStack{
                        Text("Personal").font(.headline)
                        Form{
                            
                            ForEach(expenses.personal){ item in
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    Spacer()
                                    
                                    Text(item.ammount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                }
                                
                            }
                            
                            .onDelete(perform: removePersonalItems)
                        }
                    }
                    VStack{
                        Text("Business").font(.headline)
                        Form{
                            ForEach(expenses.business){ item in
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    Spacer()
                                    
                                    Text(item.ammount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                }
                                
                            }
                            .onDelete(perform: removeBusinessItems)
                        }
                    }
                    //.navigationTitle("iExpense")
                    .toolbar{
                        Button("add expense", systemImage: "plus"){
                            showingAddExpense = true
                            
                        }
                        
                    }
                }
                .sheet(isPresented: $showingAddExpense){
                    addView(expenses: expenses)
                }
                
            }
        }
        
    }
    
    //a little complicated for me tbh if i had to make this from scratch would prob just make 2 differnet
    //classes but that would not be scalable at all and very non efficent so ig i just gotta learn this
    func removeItems(at offsets: IndexSet, in inputArray: [ExpenseItem]) {
        var objectsToDelete = IndexSet()

        for offset in offsets {
            let item = inputArray[offset]

            if let index = expenses.item.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }

        expenses.item.remove(atOffsets: objectsToDelete)
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.personal)
    }

    func removeBusinessItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.business)
    }
}

#Preview {
    ContentView()
}
