//
//  MainView.swift
//  ToDo
//
//  Created by Robert Mayore on 12/11/2020.
//

import SwiftUI
import Combine

//A class that defines our ToDo item
struct ToDo: Identifiable{
    var id : Int?
    var name: String
}


//Main view
struct MainView: View {
    
    //List that holds our todo items
    //List has a state wrapper so if the list changes, any views that depend on the list will be updated too
    @State var todoItems = [
        ToDo(id:0, name: "To do item one"),
        ToDo(id:1, name: "To do item two"),
        ToDo(id:2, name: "To do item three"),
        ToDo(id:3, name: "To do item four"),
        ToDo(id:4, name: "To do item five"),
        ToDo(id:5, name: "To do item six")
    ]
    
    //A cancellable that will execute our receiveValue closure.
    //If not assigned to a global variable, it will be destroyed after view initialization
    @State var cancellable: AnyCancellable? = nil
    
    //the main body of our view
    var body: some View {
        
        //an ToDoItemViewDelegate instance to pass to the ToDoItemView view
        let delegate = ToDoItemViewDelegate()
        
        //Will create our published object's subscriber and prepare the receiveValue closure.
        //By subcsribing to the published ToDoItemViewDelegate.updatedToDoItem, we can be updated of new & updated todo items
        DispatchQueue.main.async {
            self.cancellable = delegate.$updatedToDoItem.sink{todo in
                if(todo != nil){
                    if(todo!.id == nil){
                        //new todo item
                        var newTodo = todo!
                        newTodo.id = self.todoItems.count
                        self.todoItems.append(newTodo)
                    }else{
                        //updated todo item
                        if let row = self.todoItems.firstIndex(where: {$0.id == todo!.id}) {
                            self.todoItems[row] = todo!
                        }
                    }
                }
            }
        }
        
        //Main navigation view will include
        //1. A navigation bar with a title
        //2. An Add button on the navigation bar, when clicked will navigate the ToDoItemView to add a new todo item
        //3. A list that will display all the todoItems, when an item is clicked , will navigate the ToDoItemView to update the todo item
        return NavigationView {
            List(todoItems) { toDoItem in
                NavigationLink(destination: ToDoItemView(existingItem: toDoItem, delegate: delegate)) {
                    Text(toDoItem.name)
                }
            }
            .navigationBarTitle(Text("To Do Items"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    NavigationLink(destination: ToDoItemView(existingItem: nil, delegate: delegate)) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .padding(6)
                                            .frame(width: 24, height: 24)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .foregroundColor(.white)
                                    } )
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif


