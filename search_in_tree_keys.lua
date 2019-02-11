local tempTree
local prevPattern

local urlPartIndex = 1
local urlParts = {}

local resultPathParts = {}

local tree = {
    ["v1"] = {
        ["users"] = {
            ["[0-1]+"] = {
                "1"
            },
            ["[2-3]+"] = {
                "2"
            },
            ["[4-9]+"] = {
                "3"
            }
        },
        ["[a-zA-Z0-9_]+"] = {
            ["test"] = {
                "4"
            }
        }
    }
}

local function getRoutePattern()
    local hit
    local firstKey
    local urlPart = urlParts[urlPartIndex]

    if tree[urlPart] then
        hit = urlPart
        firstKey = urlPart
    else
        for urlPattern in pairs(tree) do
            if not firstKey then
                firstKey = urlPattern
            end

            if urlPart:match("^" .. urlPattern .. "$") then
                hit = urlPattern
                break
            end
        end
    end

    if hit then
        tempTree = tree
        prevPattern = firstKey
        urlPartIndex = urlPartIndex + 1

        tree = tree[hit]

        table.insert(resultPathParts, hit)
    else
        --- get previous level of tree, get previous url part, remove useless tree node and try again
        tree = tempTree
        tree[prevPattern] = nil
        urlPartIndex = urlPartIndex - 1

        table.remove(resultPathParts)
    end

    if urlParts[urlPartIndex] and tree then
        getRoutePattern()
    end
end

function Core:access()
    local url = "v1/users"
    local found

    for urlPartLocal in url:gmatch("([^/]+)") do
        table.insert(urlParts, urlPartLocal)
    end

    getRoutePattern()

    ngx.log(1, Json.encode(resultPathParts))

    return ngx.exit(ResponseCode.OK)
end
