---@class Node.Never: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Never
local M = ls.node.register 'Node.Never'

M.kind = 'never'

function M:view()
    return 'never'
end

ls.node.NEVER = New 'Node.Never' ()

function ls.node.never()
    return ls.node.NEVER
end
