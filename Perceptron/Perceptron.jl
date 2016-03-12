type Perceptron
  treinar::Function
  executar::Function
  corrigirPeso::Function
  tranningSet::Array
  w::Array

  function Perceptron(tranningSet, w =[0,0,0])
    this = new()
    this.tranningSet = tranningSet
    this.w = w

    this.treinar = function()
      limiteIteracao = 1000
      println("Treinando ...")
      treinou = false
      while !treinou && limiteIteracao > 0
        println(w)
        treinou = true

        for i = 1:length(this.tranningSet[:,1])
          saida = this.executar(this.tranningSet[i,1],this.tranningSet[i,2])
          if saida != this.tranningSet[i,3]
            this.corrigirPeso(i, saida)
            treinou = false
          end
        end

        limiteIteracao = limiteIteracao - 1
      end

      if treinou
        println("Treinou")
      end
    end

    this.executar = function(x, y)
      rede = (x * this.w[1]) + (y * this.w[2]) + ((-1) * this.w[3])
      # 0 = (x * 13) + (y * (-6)) + ((-1) * 37)
      # 0 = 13x - 6y - 37
      # y = (13x - 37)/6
      # 0 = (x * 13) + (y * (-6)) + ((-1) * 37)
      # -(x * 13) =  (y * (-6)) + ((-1) * 37)
      # -13x = -6y - 37
      # 13x = 6y + 37
      # x = (6y + 37)/13
      #println("Rede ",rede)
      if rede >= 0
        return 1
      end
      return 0
    end

    this.corrigirPeso = function(linha, saida)
      this.w[1] = this.w[1] + (1 * (this.tranningSet[linha,3] - saida) * this.tranningSet[linha,1])
      this.w[2] = this.w[2] + (1 * (this.tranningSet[linha,3] - saida) * this.tranningSet[linha,2])
      this.w[3] = this.w[3] + (1 * (this.tranningSet[linha,3] - saida) * (-1))

      #this.w[1] = this.w[1] + (saida * this.tranningSet[linha,1])
      #this.w[2] = this.w[2] + (saida * this.tranningSet[linha,2])
    end

    return this
  end

end

tranningSet = readcsv("data.txt")
perceptron = Perceptron(tranningSet)
perceptron.treinar()

perceptron.executar(11,12)
perceptron.executar(1,2)

y0 = (- perceptron.w[3]) / perceptron.w[2]
x0 = (perceptron.w[3]) / perceptron.w[1]
xs = [0,x0]
ys = [y0,0]

indexValues1 = findn(tranningSet[:,3])
indexValues0 = find( temp->(temp == 0), tranningSet[:,3])

Plotly.set_credentials_file({"username"=>"hugdiniz","api_key"=>"hxmxgn0j3x"})

trace = [
  "x" => tranningSet[indexValues1,1],
  "y" => tranningSet[indexValues1,2],
  "mode" => "markers",
  "name" => "Bolotas",
  "marker" => [
    "color" => "rgb(255, 217, 102)",
    "size" => 12,
    "line" => [
      "color" => "white",
      "width" => 0.5
    ]
  ],
  "type" => "scatter"
]
trace2 = [
  "x" => tranningSet[indexValues0,1],
  "y" => tranningSet[indexValues0,2],
  "mode" => "markers",
  "name" => "Bolotas",
  "marker" => [
    "color" => "rgb(0, 217, 102)",
    "size" => 12,
    "line" => [
      "color" => "white",
      "width" => 0.5
    ]
  ],
  "type" => "scatter"
]
trace3 = [
  "x" => ys,
  "y" => xs,
  "mode" => "lines",
  "name" => "linhas",
  "marker" => [
    "color" => "rgb(205, 0, 152)",
    "size" => 12,
    "line" => [
      "color" => "white",
      "width" => 0.5
    ]
  ],
  "type" => "scatter"
]
layout = [
  "title" => "Quarter 1 Growth",
  "xaxis" => [
    "title" => "GDP per Capita",
    "showgrid" => false,
    "zeroline" => false
  ],
  "yaxis" => [
    "title" => "Percent",
    "showline" => false
  ]
]

response = Plotly.plot([trace,trace2,trace3], ["layout" => layout, "filename" => "line-style", "fileopt" => "overwrite"])

plot_url = response["url"]

