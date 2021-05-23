# Examples

## TypeNode

Julia types naturally form a tree structure with `Any` at the root.\* We can define a very simple
`TypeNode` struct which wraps a `Type` value to make this structure available to the AbstractTrees
API:


```@eval
using Markdown
content = read("../../examples/typetree.jl", String)
Markdown.parse(string("```julia\n", content, "\n```"))
```

```@setup typetree
include("../../examples/typetree.jl")
```

The children of `TypeNode(T)` are `TypeNode`s wrapping the direct subtypes of `T`:

```jldoctest typetree
julia> children(TypeNode(Signed))
6-element Vector{TypeNode}:
 TypeNode(BigInt)
 TypeNode(Int128)
 TypeNode(Int16)
 TypeNode(Int32)
 TypeNode(Int64)
 TypeNode(Int8)
```

Concrete types are correctly identified as leaf nodes:

```jldoctest typetree
julia> children(TypeNode(Int))
TypeNode[]

julia> isleaf(TypeNode(Int))
true
```

We can use [`print_tree`](@ref) to show the entire type hierarchy starting from a given type:

```jldoctest typetree
julia> print_tree(TypeNode(Number))
Number
├─ Complex
└─ Real
   ├─ AbstractFloat
   │  ├─ BigFloat
   │  ├─ Float16
   │  ├─ Float32
   │  └─ Float64
   ├─ AbstractIrrational
   │  └─ Irrational
   ├─ Integer
   │  ├─ Bool
   │  ├─ Signed
   │  │  ├─ BigInt
   │  │  ├─ Int128
   │  │  ├─ Int16
   │  │  ├─ Int32
   │  │  ├─ Int64
   │  │  └─ Int8
   │  └─ Unsigned
   │     ├─ UInt128
   │     ├─ UInt16
   │     ├─ UInt32
   │     ├─ UInt64
   │     └─ UInt8
   └─ Rational
```


\* Technically, this isn't true for `Union` and some partially-parameterized `UnionAll` types,

