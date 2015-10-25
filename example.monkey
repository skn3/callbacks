Import skn3.callbacks

Global CALLBACK_DO_SOMETHING:= RegisterCallbackId("Do Something")

Function Main:Int()
	Local myClass1:= New MyClass("myClass1")
	Local myClass2:= New MyClass("myClass2")
	Local myClass3:= New MyClass("myClass3")
	
	FireCallback(CALLBACK_DO_SOMETHING, Null, Null)
End

Class MyClass Implements CallbackReciever
	Field name:String
	
	Method New(name:string)
		Self.name = name
		
		'add callbacks to this class
		AddCallbackReciever(Self, CALLBACK_DO_SOMETHING)
	End
	
	Method OnCallback:Bool(id:Int, source:Object, data:Object)
		Select id
			Case CALLBACK_DO_SOMETHING
				Print "CALLBACK_DO_SOMETHING called for " + name
		End
		
		'return to not block further callbacks
		Return False
	End
End