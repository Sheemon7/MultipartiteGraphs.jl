module MultipartiteGraphs

using LightGraphs
using MetaGraphs

import LightGraphs:
    ne, nv, vertices, edges, has_edges, has_vertex,
    is_directed, inneighbors, outneighbors, all_neighbors,
    dst, src,
    add_vertex!, add_edge!

import GraphPlot:
    gplot

const PropDict = AbstractDict{Symbol, T} where T

mutable struct MultipartiteGraph{T} <: AbstractGraph{T}
    mg::MetaGraph{T}
end

MultipartiteGraph() = MultipartiteGraph(MetaGraph(Graph()))

for f in [:ne, :nv, :vertices, :edges, :has_edge, :has_vertex,
          :is_directed, :inneighbors, :outneighbors, :all_neighbors,
          :dst, :src, :gplot]
    @eval @inline $f(g::MultipartiteGraph, args...; kwargs...) = $f(g.mg, args...; kwargs...)
end

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

relation_edges(g::MultipartiteGraph, relation::AbstractString) = filter_edges(g.mg, :relation_type, relation)

export MultipartiteGraph

end # module
