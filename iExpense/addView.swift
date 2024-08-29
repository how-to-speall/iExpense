//
//  addView.swift
//  iExpense
//
//  Created by Ahoura Bagherikhoshkroudi on 2024-08-28.
//

import SwiftUI

struct addView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    
    var expenses: Expense
    
    let types = ["Business","Personal"]
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                
                
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save"){
                    let item = ExpenseItem(name: name, type: type, ammount: amount)
                    expenses.item.append(item)
                    dismiss()
                    
                }
            }
        }
    }
}

#Preview {
    addView(expenses: Expense())
}
