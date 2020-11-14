//
//  ContentView.swift
//  iOS14-2SwiftUIExperiment
//
//  Created by Joseph on 11/11/2020.
//

import SwiftUI
import CoreData

struct DetailView : View {
    let count: Int
    let incrementClosure: () -> ()
    var body: some View {
        Text("Count: \(count)")
        Button(action: incrementClosure) {
            Label("Add Item", systemImage: "plus")
        }
    }
}

class Counter : ObservableObject {
    @Published var count: Int = 0
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @ObservedObject var counter: Counter
    
    var body: some View {
        NavigationView {
            
//            NavigationLink(
//                destination: DetailView(count: counter.count) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                        counter.count += 1
//                    }
//                },
//                label: {
//                    Text("Detail")
//                })
            List {
                ForEach(items) { item in
                    NavigationLink(
                        destination: VStack {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            Text("Count: \(item.count)")
                            Button(action: {
                                increment(item: item)
                            }
                                , label: {
                                Text("Increment")
                            })
                        },
                        label: {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter) - \(item.count)")
                        })
                }
                .onDelete(perform: deleteItems)
                ForEach(items) { item in
                    HStack {
                    Button(action: { increment(item: item) }) { Label("Increment", systemImage: "plus") }
                    Text("Item at \(item.timestamp!, formatter: itemFormatter) - \(item.count)")
                    }
                }
            }
            .toolbar {
                HStack {
                    #if os(iOS)
                    EditButton()
                    #endif

                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func increment(item: Item) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            item.count += 1
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
                assertionFailure(error.localizedDescription)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var counter = Counter()
    static var previews: some View {
        ContentView(counter: counter).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
