//
//  ToDoItemView.swift
//  ToDo
//
//  Created by Robert Mayore on 21/11/2020.
//
import SwiftUI

//A class with a publisher that emits to subscribers
class ToDoItemViewDelegate : ObservableObject {
    @Published var updatedToDoItem: ToDo?
}

//The todo item view
struct ToDoItemView: View {
    
    //Will read the value of the presentationMode enviroment property
    @Environment(\.presentationMode) var presentationMode
    
    //An optional todo item object passed from the main view
    var existingItem: ToDo?
    
    //A stateful variable to bind to the todo name Text field
    @State var name: String
    
    //Delegate instance that wraps the observed object
    @ObservedObject var delegate: ToDoItemViewDelegate
    
    //The init block was purposefully added to initialize the name with the existingItem.name value if it exists
    init(existingItem: ToDo?, delegate: ToDoItemViewDelegate) {
        self.existingItem = existingItem
        self.delegate = delegate
        _name = State(initialValue: existingItem?.name ?? "")
    }
    
    //the main body of our view
    var body: some View {
        
        //Vertical stack layout view will include
        //1. A navigation bar with a title
        //2. A SAVE button on the navigation bar, when clicked will execute the addToDo action
        //3. A TextField for the todo name
        VStack{
            Form {
                Section {
                    TextField("Name", text: $name)
                }
            }
        }
        .navigationBarTitle(Text((existingItem != nil) ? "Edit To do item" : "Add new To do item"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: addToDo, label: {Text("SAVE")}))
    }
    
    //the addToDo action will init/update our published object
    //the subscribers can then get the updated object and update the views
    func addToDo(){
        
        if var toDo = self.existingItem {
            //will update the existingItem with the new item, then set it as new [published] todo item
            toDo.name = self.name
            self.delegate.updatedToDoItem = toDo
        }else{
            //create new [published] todo item
            let toDo = ToDo(id: nil, name: self.name)
            self.delegate.updatedToDoItem = toDo
        }
        //Dismisses the view if it is currently presented i.e. navigate back
        self.presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(existingItem : nil, delegate : ToDoItemViewDelegate())
    }
}
#endif
