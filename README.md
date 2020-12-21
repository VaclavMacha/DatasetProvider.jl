# DatasetProvider.jl

Work in progress...

## Installation

To install this package use Pkg REPL and following command

```julia
add https://github.com/VaclavMacha/DatasetProvider
```

## Basic usage

```julia
julia> using DatasetProvider

julia> using DatasetProvider: Ionosphere

julia> dataset = Ionosphere()
Dataset: Ionosphere
 - TwoClass problem
 - TabularData format

julia> data = load_raw(dataset, :train);

julia> first(data, 6)
6×35 DataFrame
 Row │ Column1  Column2  Column3  Column4   Column5  ⋯
     │ Int64    Int64    Float64  Float64   Float64  ⋯
─────┼────────────────────────────────────────────────
   1 │       1        0  0.99539  -0.05889   0.85243 ⋯
   2 │       1        0  1.0      -0.18829   0.93035
   3 │       1        0  1.0      -0.03365   1.0
   4 │       1        0  1.0      -0.45161   1.0
   5 │       1        0  1.0      -0.02401   0.9414  ⋯
   6 │       1        0  0.02337  -0.00592  -0.09924
                                    30 columns omitted
```

### Train-valid-test split
```julia
julia> split = TrainValidTest(at = (0.6, 0.2), shuffle = true, seed = 1234)
TrainValidTest((0.6, 0.2), true, true, 1234)

julia> train, valid, test = split(Ionosphere());

julia> first(train, 6)
6×35 DataFrame
 Row │ Column1  Column2  Column3  Column4   Column5  ⋯
     │ Int64    Int64    Float64  Float64   Float64  ⋯
─────┼────────────────────────────────────────────────
   1 │       1        0      1.0  -0.01081   1.0     ⋯
   2 │       1        0      1.0  -1.0       1.0
   3 │       1        0      1.0  -0.01179   1.0
   4 │       1        0     -1.0  -1.0      -0.50694
   5 │       0        0     -1.0  -1.0       0.0     ⋯
   6 │       1        0      0.0   0.0       0.0
                                    30 columns omitted

julia> ns = size.((train,  valid, test), 1)
(211, 70, 70)

julia> round.(ns ./ sum(ns); digits = 4)
(0.6011, 0.1994, 0.1994)
```

### Listing datasets

```julia
julia> listdatasets()
MultiClass:
  ColorImages:
    ✖ CIFAR10
    ✖ CIFAR100
    ✖ CIFAR20
  GrayImages:
    ✔ FashionMNIST
    ✔ MNIST
TwoClass:
  TabularData:
    ✔ Gisette
    ✖ Hepmass
    ✔ Spambase
    ✔ Ionosphere
```

### Removing datasets

```julia
julia> remove(Ionosphere)
 ✖ Ionosphere dataset removed

julia> listdatasets()
MultiClass:
  ColorImages:
    ✖ CIFAR10
    ✖ CIFAR100
    ✖ CIFAR20
  GrayImages:
    ✔ FashionMNIST
    ✔ MNIST
TwoClass:
  TabularData:
    ✔ Gisette
    ✖ Hepmass
    ✔ Spambase
    ✖ Ionosphere
```

```julia
julia> removeall()
Do you want to remove all downloaded datasets?
[y/n]
y
 ✖ Gisette dataset removed
 ✖ FashionMNIST dataset removed
 ✖ MNIST dataset removed
 ✖ Spambase dataset removed

julia> listdatasets()
MultiClass:
  ColorImages:
    ✖ CIFAR10
    ✖ CIFAR100
    ✖ CIFAR20
  GrayImages:
    ✖ FashionMNIST
    ✖ MNIST
TwoClass:
  TabularData:
    ✖ Gisette
    ✖ Hepmass
    ✖ Spambase
    ✖ Ionosphere
```
