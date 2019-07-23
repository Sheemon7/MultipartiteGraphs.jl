g = MultipartiteGraph()

# add some vertices
users = ["u1", "u2", "u3"]
binaries = ["10301bf7", "f1ef763b", "0eed6aff", "04ce3f0b", "acb725a2"]
domains = ["domain.com", "learn.edu", "wikipedia.org"]
ips = ["93.172.226.55", "155.129.86.61", "4.204.201.145", "241.67.142.157"]

for u in users
    add_vertex!(g, "users", props=Dict(:name => u))
end
for b in binaries
    add_vertex!(g, "binaries", props=Dict(:name => b))
end
for d in domains
    add_vertex!(g, "domains", props=Dict(:name => d))
end
for i in ips
    add_vertex!(g, "ips", props=Dict(:name => i))
end
