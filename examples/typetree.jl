using AbstractTrees
import AbstractTrees: children, printnode


struct TypeNode
    T::Type
end

children(node::TypeNode) = map(TypeNode, subtypes(node.T))

# Print as "T" instead of "TypeNode(T)"
printnode(io::IO, node::TypeNode) = print(io, node.T)
