local tree = {
  ["v1"] = {
    ["webtexts"] = {
      ["[a-zA-Z0-9_-]+"] = {
        ["test"] = {
          "finish1"
        },
        ["[a-zA-Z0-9_-]+"] = {
          "finish2"
        }
      },
      ["product"] = {
        ["test1"] = {
          "finish3"
        },
        ["[a-zA-Z0-9_-]+"] = {
          "finish4"
        },
        ["test2"] = {
          "finish5"
        }
      }
    }
  }
}

local function getRoutePattern(urlPart)
  local hit

  if tree[urlPart] then
    hit = urlPart
  else
    for urlPattern in pairs(tree) do
      if urlPart:match("^" .. urlPattern .. "$") then
        hit = urlPattern
        break
      end
    end
  end

  if hit then
     tree = tree[hit]

     print(hit)
  end
end

local url = "v1/webtexts/product/test1"

for urlPart in url:gmatch("([^/]+)") do
  getRoutePattern(urlPart)
end
