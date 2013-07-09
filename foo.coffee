class Foo
    foo: (c, d) ->
        console.log('hello', c, d)

    index: (a, b) ->
        console.log(this.foo)

f = new Foo()
f.index('a', 'b')