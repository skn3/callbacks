Strict

'version 1
' - first commit

Import monkey.boxes
Import monkey.map
Import skn3.arraylist

Private
Global callbackIdCount:Int
Global callbackIds:= New ArrayList<String>
Global recieverIdLists:= New IntMap<ArrayList<CallbackReciever>>
Public

'public interface
Interface CallbackReciever
	Method OnCallback:Bool(id:Int, source:Object, data:Object)
End

'public api
Function RegisterCallbackId:Int(name:string)
	' --- register a uniquee callback id ---
	'create new id
	callbackIdCount += 1
	
	'set the callback id name
	callbackIds.AddLast(name)
	
	'return id of callback
	Return callbackIdCount
End

Function GetCallbackId:String(id:Int)
	' --- get the id of a callback ---
	If id < 1 or id > callbackIdCount Return ""
	Return callbackIds.data[id - 1]
End

Function ClearCallbackRecievers:Void(id:Int)
	' --- this will clear all recievers for an id ---
	recieverIdLists.Remove(id)
End

Function RemoveCallbackReciever:Void(reciever:CallbackReciever)
	' --- remove a callback reciever ---
	Local list:ArrayList<CallbackReciever>
	For Local listId:= EachIn recieverIdLists.Keys()
		list = recieverIdLists.ValueForKey(listId)
		If list
			'remove reciever from list
			list.Remove(reciever)
			
			'check for empty list
			If list.IsEmpty() recieverIdLists.Remove(listId)
		EndIf
	Next
End

Function AddCallbackReciever:Void(reciever:CallbackReciever, id:int)
	' --- add a callback reciever ---
	If id = 0 Return
	
	'see if the list exists
	Local list:= recieverIdLists.ValueForKey(id)
	If list = Null
		'create new list
		list = New ArrayList<CallbackReciever>
		recieverIdLists.Insert(id, list)
	EndIf
	
	'add reciever to list
	If list.Contains(reciever) = False list.AddLast(reciever)
End

Function FireCallback:Bool(id:Int, source:Object, data:Object)
	' --- fires a callback ---
	Local list:= recieverIdLists.ValueForKey(id)
	If list
		'fire callback for all recievers
		For Local index:= 0 Until list.count
			'check for a callback blocking further execution
			If list.data[index].OnCallback(id, source, data) = True Return True
		Next
	EndIf
	
	'return that it wasn't blocked
	Return False
End

Function FireCallback:Bool(id:Int, source:Object)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, Null)
End

Function FireCallback:Bool(id:Int, source:Object, data:String)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, Object(StringObject(data)))
End

Function FireCallback:Bool(id:Int, source:Object, data:Bool)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, Object(BoolObject(data)))
End

Function FireCallback:Bool(id:Int, source:Object, data:int)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, Object(IntObject(data)))
End

Function FireCallback:Bool(id:Int, source:Object, data:Float)
	' --- shortcut to auto box ---
	Return FireCallback(id, source, Object(FloatObject(data)))
End
