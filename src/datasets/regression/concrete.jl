struct Concrete <: Name end

# mandatory methods
format(::Type{Concrete}) = TabularData
task(::Type{Concrete}) = Regression
source(::Type{Concrete}) = "https://archive.ics.uci.edu/ml/datasets/BlogFeedback"

function downloadlink(::Type{Concrete})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/concrete/compressive/Concrete_Data.xls"
end

function preprocess(N::Type{Concrete})
    return path -> preprocess_csv(N, path, :train; istarget = 9, header = true, excel = true)
end

nattributes(::Type{Concrete}) = (8, )
ninstances(::Type{Concrete}) = (1030, 0, 0)

# optional methods
function checksum(::Type{Concrete})
    return "710076c66b9ca3f8050e7942f3dcbdbe04013534daeb0077ffd3079a52d8e0c4"
end

name(::Type{Concrete}) = "Concrete Compressive Strength Data Set"
author(::Type{Concrete}) = ["I-Cheng Yeh"]

function citation(::Type{Concrete})
    return """
    @article{yeh1998modeling,
        title={Modeling of strength of high-performance concrete using artificial neural networks},
        author={Yeh, I-C},
        journal={Cement and Concrete research},
        volume={28},
        number={12},
        pages={1797--1808},
        year={1998},
        publisher={Elsevier}
    }
    """
end