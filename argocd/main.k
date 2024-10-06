import math

schema Person:
    name: str
    age: int

_person = Person {
    name = 'John Connor'
    age: 54
}

_receivedPersonsName = option('personName')
# execute: kcl run main.k -D personName=pepe, kcl run main.k -D personName='John Connor', kcl run main.k -D personName=Javier

if _receivedPersonsName == 'John Connor':
    _result = 'is John'
elif _receivedPersonsName == 'Javier':
    _result = 'is Javier'
else:
    _result = 'unknown'
result = _result

func: (int, int) -> int = lambda x: int, y: int -> int {
    x + y
}
a = func(1, 1)

