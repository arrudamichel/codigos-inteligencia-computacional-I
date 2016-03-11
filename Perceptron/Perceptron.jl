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
      treinou = false
      while treinou
        for i = 1:length(this.tranningSet[:,1])
          saida = this.executar(this.tranningSet[i,1],this.tranningSet[i,2])

          if saida != this.tranningSet[i,3]
            this.corrigirPeso(i, saida)
            treinou = false
          end
        end
      end
    end

    this.executar = function(x, y)
      rede = (x * this.w[1]) + (y * this.w[2])

      if rede >= 0
        return 1
      end
      return 0
    end

    this.corrigirPeso = function(linha, saida)
      this.w[1] = w[1] + (1 * (this.tranningSet[linha][3] - saida) * this.tranningSet[linha][1])
      this.w[2] = w[2] + (1 * (this.tranningSet[linha][3] - saida) * this.tranningSet[linha][2])
    end

    return this
  end

end

tranningSet = readcsv("data.txt")
perceptron = Perceptron(tranningSet)
perceptron.treinar()
