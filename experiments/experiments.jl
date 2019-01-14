using PGFPlotsX
using Colors
using ColorSchemes
using Random
using SurrogateModelOptim
using ColorBrewer
using Distances
using ScatteredInterpolation
using Statistics



function funcplotX(fun,xmin,xmax,ymin,ymax)
    
    np = 40   #Number of points in 1 dimension for plotting
    x = range(xmin,stop=xmax,length=np)
    y = range(ymin,stop=ymax,length=np)

    asd = (x,y)->[x,y]
    data = fun.(asd.(x,y'))
    
    ax = @pgf Axis(
        {
            #view = (-24, 40),
            #"point meta min" = (minimum(data)),
            #"point meta max" = (maximum(data)*0.75),
            #zmin = -20,
            #zmax = 2020,
        },
        Plot3(
            {
                surf,
            },
            Coordinates(x,y,data)
        )
    )
    @pgf push!(ax, ("PuBuGn_9", sortcolorscheme(ColorSchemes.PuBuGn_9, rev=false)))    

    return ax
end


f = rosenbrock2d

# res = smoptimize(x->(f(x)+3333*rand(MersenneTwister(abs(sum(reinterpret(Int64,x)))))), [(-5.0,5.0),(-5.0,5.0)],
#         SurrogateModelOptim.options(num_interpolants=20,
#                                     num_start_samples=15,
#                                     sampling_plan_opt_gens=100000,
#                                     rbf_opt_gens=20000,
#                                     variable_kernel_width = true,
#                                     variable_dim_scaling = true,
#                                     smooth = :single,
#                                     smooth_user = 0.0));display(funcplotX(x->median(res[3](x))[1],-5,5,-5,5))


res = smoptimize(hart6, repeat([(0.0,1.0)],6),
               SurrogateModelOptim.options(num_interpolants=100,
                                           num_start_samples=30,
                                           sampling_plan_opt_gens=90000,
                                           rbf_opt_gens=20000,
                                           variable_kernel_width = true,
                                           variable_dim_scaling = true,
                                           smooth = :single,
                                           smooth_user = 0.0))
return nothing       


