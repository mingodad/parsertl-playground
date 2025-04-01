Smalltalk addClassMethod: #addInstanceVariables:toClass: toClass: Smalltalk  withBody: [
  :lst :cls |
  lst do: [ :v | self addInstanceVariable: v toClass: cls ]
]

Smalltalk addClassMethod: #addClassVariables:toClass: toClass: Smalltalk  withBody: [
  :lst :cls |
  lst do: [ :v | self addClassVariable: v toClass: cls ]
]

Smalltalk createClass: #Error parentClass: Exception

Smalltalk createClass: #MessageNotUnderstood parentClass: Error

Smalltalk createClass: #ZeroDivide parentClass: Error

Smalltalk createClass: #InvalidArgument parentClass: Error

Smalltalk createClass: #IndexOutofBounds parentClass: Error

Smalltalk createClass: #EmptyCollection parentClass: Error

Smalltalk createClass: #Stack

Smalltalk addInstanceVariable: #coll toClass: Stack

Smalltalk addInstanceMethod: #initialize toClass: Stack withBody: [ coll := OrderedCollection new]

Smalltalk addInstanceMethod: #isEmpty toClass: Stack withBody: [ ^ (coll size) = 0 ]

Smalltalk addInstanceMethod: #push: toClass: Stack withBody: [ :v | coll add: v ]

Smalltalk addInstanceMethod: #pop toClass: Stack withBody: [
  ^ coll removeLast
]

Smalltalk addInstanceMethod: #top toClass: Stack withBody: [
  ((coll size) = 0 )
    ifTrue:  [EmptyCollection new signal]
    ifFalse: [ ^ coll at: (coll size)]
]

Smalltalk createClass: #CompileError parentClass: Error
