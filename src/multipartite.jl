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
    set_props!(g.mg, u, v, merge(props, Dict(:relation => relation)))
end

mp_nv(g::MultipartiteGraph, partite::AbstractString) = length(collect(mp_vertices(g, partite)))
mp_ne(g::MultipartiteGraph, relation::AbstractString) = length(collect(mp_edges(g, relation)))
mp_vertices(g::MultipartiteGraph, partite::AbstractString) = filter_vertices(g.mg, :partite, partite)
mp_edges(g::MultipartiteGraph, relation::AbstractString) = filter_edges(g.mg, :relation, relation)
function mp_inneighbors(g::MultipartiteGraph{T}, v::T; partite=nothing, relation=nothing) where T
    filter(inneighbors(g, v)) do u
        (isnothing(partite) || (has_prop(g, u, :partite) && get_prop(g, u, :partite) == partite)) &&
        (isnothing(relation) || (has_prop(g, Edge(v, u), :relation) && get_prop(g, Edge(v, u), :relation) == relation))
    end
end
function mp_outneighbors(g::MultipartiteGraph{T}, v::T; partite=nothing, relation=nothing) where T
    mp_inneighbors(g, v, partite, relation)
end

export MultipartiteGraph
export mp_nv, mp_ne, mp_vertices, mp_edges, mp_inneighbors, mp_outneighbors
