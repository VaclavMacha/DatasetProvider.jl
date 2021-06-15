# DatasetProvider.jl

Work in progress...

## Installation

To install this package use Pkg REPL and following command

```julia
add https://github.com/VaclavMacha/DatasetProvider
```

## Loading raw data

```julia
julia> using DatasetProvider

julia> using DatasetProvider: Ionosphere

julia> data = loadraw(Ionosphere, :train);

julia> first(data, 6)
6×35 DataFrame
 Row │ targets  real_01  real_02  real_03  real_04   real_05   real_06   real_07    ⋯
     │ String   Int64    Int64    Float64  Float64   Float64   Float64   Float64    ⋯
─────┼───────────────────────────────────────────────────────────────────────────────
   1 │ g              1        0  0.99539  -0.05889   0.85243   0.02306   0.83398   ⋯
   2 │ b              1        0  1.0      -0.18829   0.93035  -0.36156  -0.10868
   3 │ g              1        0  1.0      -0.03365   1.0       0.00485   1.0
   4 │ b              1        0  1.0      -0.45161   1.0       1.0       0.71216
   5 │ g              1        0  1.0      -0.02401   0.9414    0.06531   0.92106   ⋯
   6 │ b              1        0  0.02337  -0.00592  -0.09924  -0.11949  -0.00763
                                                                   27 columns omitted
```

### Train-valid-test split

```julia
julia> d = Dataset(Ionosphere; origheader = true, seed = 123, binarize = true)
Ionosphere(shuffle = false, seed = 123, asmatrix = false, origheader = true, binarize = true)

julia> split = TrainValidTest((0.6, 0.2))
TrainValidTest((0.6, 0.2))

julia> train, valid, test = load(split, d);

julia> first(train, 6)
6×35 DataFrame
 Row │ Column35  Column1  Column2  Column3  Column4   Column5   Column6   Column7    ⋯
     │ Bool      Int64    Int64    Float64  Float64   Float64   Float64   Float64    ⋯
─────┼────────────────────────────────────────────────────────────────────────────────
   1 │    false        1        0  0.99539  -0.05889   0.85243   0.02306   0.83398   ⋯
   2 │     true        1        0  1.0      -0.18829   0.93035  -0.36156  -0.10868
   3 │    false        1        0  1.0      -0.03365   1.0       0.00485   1.0
   4 │     true        1        0  1.0      -0.45161   1.0       1.0       0.71216
   5 │    false        1        0  1.0      -0.02401   0.9414    0.06531   0.92106   ⋯
   6 │     true        1        0  0.02337  -0.00592  -0.09924  -0.11949  -0.00763
                                                                    27 columns omitted

julia> ns = size.((train,  valid, test), 1)
(211, 70, 70)

julia> round.(ns ./ sum(ns); digits = 4)
(0.6011, 0.1994, 0.1994)
```

```julia
julia> d = Dataset(Ionosphere; origheader = true, seed = 123, binarize = true, asmatrix = true)
Ionosphere(shuffle = false, seed = 123, asmatrix = true, origheader = true, binarize = true)

julia> split = TrainValidTest((0.6, 0.2))
TrainValidTest((0.6, 0.2))

julia> train, valid, test = load(split, d);

julia> train[1][1:6, 1:5]
6×5 Matrix{Float64}:
 1.0  0.0  0.99539  -0.05889   0.85243
 1.0  0.0  1.0      -0.18829   0.93035
 1.0  0.0  1.0      -0.03365   1.0
 1.0  0.0  1.0      -0.45161   1.0
 1.0  0.0  1.0      -0.02401   0.9414
 1.0  0.0  0.02337  -0.00592  -0.09924

julia> train[2][1:6]
6-element Vector{Bool}:
 0
 1
 0
 1
 0
 1
```

### Listing datasets

```julia
julia> listdatasets()
MultiClass: 
  ColorImages: 
    ✔ CIFAR10 
    ✔ CIFAR100 
    ✔ CIFAR20 
    ✔ SVHN2 
    ✔ SVHN2Extra 
  GrayImages: 
    ✔ FashionMNIST 
    ✔ MNIST 
  TabularData: 
    ✔ RedWineQuality 
    ✔ WhiteWineQuality 
TwoClass: 
  TabularData: 
    ✔ BreastCancer 
    ✔ Gisette 
    ✔ HEPMASS 
    ✔ Ionosphere 
    ✔ Spambase 
Regression: 
  TabularData: 
    ✔ BikeSharingDay 
    ✔ BikeSharingHour 
    ✔ FacebookV1 
    ✔ FacebookV2 
    ✔ FacebookV3 
    ✔ FacebookV4 
    ✔ FacebookV5 
    ✔ CommunitiesCrime 
    ✔ Concrete 
    ✔ ProteinStructure 
```

### Removing datasets

```julia
julia> remove(DatasetProvider.Ionosphere)
 ✖ Ionosphere dataset removed
```