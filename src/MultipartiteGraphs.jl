module MultipartiteGraphs

using LightGraphs
using MetaGraphs

import LightGraphs:
    ne, nv, vertices, edges, has_edge, has_vertex,
    is_directed, inneighbors, outneighbors,
    dst, src,
    add_vertex!, add_edge!

import MetaGraphs:
    props, get_prop,
    set_props!, set_prop!,
    rem_prop!, has_prop,
    clear_props!

import GraphPlot:
    gplot

const PropDict = AbstractDict{Symbol, T} where T

mutable struct MultipartiteGraph{T} <: AbstractGraph{T}
    mg::MetaGraph{T}
end

MultipartiteGraph() = MultipartiteGraph(MetaGraph(Graph()))

for f in [:ne, :nv, :vertices, :edges, :has_edge, :has_vertex,
          :inneighbors, :outneighbors,
          :dst, :src, :gplot,
          :props, :get_prop,
          :set_props!, :set_prop!,
          :rem_prop!, :has_prop,
          :clear_props!
         ]
    @eval @inline $f(g::MultipartiteGraph, args...; kwargs...) = $f(g.mg, args...; kwargs...)
end
is_directed(::MultipartiteGraph{T}) where T = false
is_directed(::Type{MultipartiteGraph{T}}) where T = false

function add_vertex!(g::MultipartiteGraph, partite::AbstractString;
                     props::PropDict=Dict{Symbol, Any}())
    add_vertex!(g.mg) || return false
    set_props!(g.mg, nv(g.mg), merge(props, Dict(:partite => partite)))
end

function add_edge!(g::MultipartiteGraph{T}, u::T, v::T, relation::AbstractString;
                     props::PropDict=Dict{Symbol, Any}()) where T
    add_edge!(g.mg, u, v) || return false
    set_props!(g.mg, u, v, merge(props, Dict(:relation_type => relation)))
end

nv(g::MultipartiteGraph, partite::AbstractString) = length(collect(vertices(g, partite)))
ne(g::MultipartiteGraph, relation::AbstractString) = length(collect(edges(g, relation)))
vertices(g::MultipartiteGraph, partite::AbstractString) = filter_vertices(g.mg, :partite, partite)
edges(g::MultipartiteGraph, relation::AbstractString) = filter_edges(g.mg, :relation_type, relation)

export MultipartiteGraph

end # module
