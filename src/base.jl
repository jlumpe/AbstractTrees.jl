#
# children() and related functions
#

"""
    children(node)

Get the immediate children of `node`.

This is the primary function that needs to be implemented for custom tree types. It should return an
iterable object for which an appropriate implementation of `Base.pairs` is available.

The default behavior is to assume that if an object is iterable, iterating over
it gives its children. Non-iterable types are treated as leaf nodes.
"""
children(node) = Base.isiterable(typeof(node)) ? node : ()


"""
    isleaf(node)

Check if `node` is a leaf node - i.e. has no children.
"""
isleaf(node) = childcount(node) == 0


"""
    ischild(node1, node2)

Check if `node2` is the parent of `node1`.
"""
ischild(node1, node2) = any(node -> node === node1, children(node2))


"""
    childcount(node)

Get the count of a node's children.

This is equivalent to `length(children(node))` but may be more effecient for certain types.
"""
childcount(node) = length(children(node))


#
# Subtree-related functions
#

"""
    intree(node, root)

Check if `node` is a member of the tree rooted at `root`.

By default this traverses through the entire tree in search of `node`, and so may be slow if a
more specialized method has not been implemented for the given tree type.

See also: [`isdescendant`](@ref)
"""
intree(node, root) = any(n -> n === node, PreOrderDFS(root))

"""
    isdescendant(node1, node2)

Check if `node1` is a descendant of `node2`. This isequivalent to checking whether `node1` is a
member of the subtree rooted at `node2` (see [`intree`](@ref)) except that a node cannot be a
descendant of itself.

Internally this calls `intree(node1, node2)` and so may be slow if a specialized method of that
function is not available.
"""
isdescendant(node1, node2) = node1 !== node2 && intree(node1, node2)


"""
    treesize(node)

Get the size of the tree rooted at `node`.

By default this recurses through all nodes in the tree and so may be slow if a more specialized
method has not been implemented for the given type.
"""
treesize(node) = isleaf(node) ? 1 : 1 + mapreduce(treesize, +, children(node))


"""
    treebreadth(node)

Get the number of leaves in the tree rooted at `node`. Leaf nodes have a breadth of one.

By default this recurses through all nodes in the tree and so may be slow if a more specialized
method has not been implemented for the given type.
"""
treebreadth(node) = isleaf(node) ? 1 : mapreduce(treebreadth, +, children(node))


"""
    treeheight(node)

Get the maximum depth from `node` to any of its descendants. Leaf nodes have a height of zero.

By default this recurses through all nodes in the tree and so may be slow if a more specialized
method has not been implemented for the given type.
"""
treeheight(node) = isleaf(node) ? 0 : 1 + mapreduce(treeheight, max, children(node))



#
#  Parent- and ancestor-related functions
#

"""
    parentnode(node)

Get the parent of the given node, or `nothing` if the node is the root.
"""
function parentnode end


"""
    isroot(node)

Check if the given node is a root node, i.e. has no parent.
"""
isroot(node) = isnothing(parentnode(node))


"""
    getroot(node)
"""
function getroot(node)
    parent = parentnode(node)
    return isnothing(parent) ? node : getroot(parent)
end


"""
    treedepth(node)
"""
treedepth(node) = isroot(node) ? 0 : 1 + treedepth(parentnode(node))


"""
    ancestors(node; incself::Bool=false)

Get an iterator over a node's ancestors in ascending order.

If `incself=true` the iterator will start with `node` itself, otherwise it will start with `node`'s
parent.
"""
ancestors(node; incself::Bool=false) = AncestorsIterator(incself ? node : parentnode(node))


struct AncestorsIterator{T}
    node::T
end

Base.IteratorEltype(::Type{AncestorsIterator{T}}) where T = hasmethod(nodetype, Tuple{T}) ? Base.HasEltype() : Base.EltypeUnknown()
Base.eltype(::Type{AncestorsIterator{T}}) where T = nodetype(T)

Base.iterate(a::AncestorsIterator, next=a.node) = isnothing(next) ? nothing : (next, parentnode(next))
