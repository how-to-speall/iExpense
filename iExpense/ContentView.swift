//
//  ContentView.swift
//  iExpense
//
//  Created by Ahoura Bagherikhoshkroudi on 2024-08-21.
//

import SwiftUI


struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let ammount: Double
}


@Observable
class Expense{
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
            List{
                ForEach(expenses.item){ item in
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
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("add expense", systemImage: "plus"){
                    showingAddExpense = true
                    
                }
                
            }
            .sheet(isPresented: $showingAddExpense){
                addView(expenses: expenses)
            }

        }
        
    }
    func removeItems(at offsets: IndexSet){
        expenses.item.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
