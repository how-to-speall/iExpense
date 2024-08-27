//
//  ContentView.swift
//  iExpense
//
//  Created by Ahoura Bagherikhoshkroudi on 2024-08-21.
//

import SwiftUI

struct ExpenseItem{
    let name: String
    let type: String
    let ammount: Double
}


@Observable
class Expense{
    var item = [ExpenseItem]()
}

struct ContentView: View {
    
    @State private var expenses = Expense()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(expenses.item, id: \.name){ item in
                    Text(item.name)
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("add expense", systemImage: "plus"){
                    let expense = ExpenseItem(name: "Test", type: "Personal", ammount: 5)
                    expenses.item.append(expense)
                    
                }
                
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
