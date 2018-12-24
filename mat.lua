local mat={}
 
function mat.sigmoid(x,der)
  if der==true then
    return (1/(1+math.exp(-x)))*(1-(1/(1+math.exp(-x))))
  elseif der=="name" then
    return "sigmoid"
  elseif der==nil then
    return 1/(1+math.exp(-x))
  else
    print("invalid input for 'der', try true, 'name' or nil")
  end
end
 
function mat.sqsum(x,xo,der)
  y=0
  if x.m==xo.m and x.n==xo.n then
    if der==nil then
      for i=1,x.m do
        for j=1,x.n do
          y = y + (x-xo)*(x-xo)
        end
      end
      return y
    elseif der==true then
      for i=1,x.m do
        for j=1,x.n do
          y = y + (x-xo)
        end
      end
      return y
    elseif der=="name" then
      return "square sum"
    end
  end
end
 
function mat.matrix(M,N)
  mt = {}
  for i=1,M do
    mt[i] = {}
    for j=1,N do
      mt[i][j] = 0
    end
  end
  mt.m=M
  mt.n=N
  return mt
end
 
function mat.PrintMatrix(M)
  for i=1,M.m do
    row = ""
    for j=1,M.n do
      row=row..tostring(M[i][j])
      row=row.." "
    end
    print(row)
  end
end
 
function mat.RandomiseMatrix(M,min,max)
  for i=1,M.m do
    for j=1,M.n do
      M[i][j]=(max-min)*math.random()+min
    end
  end
  return M
end
 
function mat.rowvector(n)
  return mat.matrix(1,n)
end
 
function mat.colvector(n)
  return mat.matrix(n,1)
end
 
function mat.Trans(M)
  T = mat.matrix(M.n,M.m)
  for i=1,T.m do
    for j=1,T.n do
      T[i][j]=M[j][i]
    end
  end
  return T
end
 
function mat.Identity(n)
  I=mat.matrix(n,n)
  for i=1,n do
    I[i][i]=1
  end
  return I
end
 
function mat.add(M1,M2)
  if M1.m==M2.m and M1.n==M2.n then
    M = mat.matrix(M1.m,M1.n)
    for i=1,M.m do
      for j=1,M.n do
        M[i][j]=M1[i][j]+M1[i][j]
      end
    end
  else
    print("error in add: dimension mismatch")
  end
  return M
end
 
function mat.dot(M1,M2)
  if M1.n==M2.m then
    M = mat.matrix(M1.m,M2.n)
    for i=1,M.m do
      for j=1,M.n do
        for k=1,M1.n do
          M[i][j]=M[i][j] + M1[i][k]*M2[k][j]
        end
      end
    end
  else
    print("error in add: inner dimension mismatch")
  end
  return M
end
 
function mat.Tr(M)
  T = 0
  if M.m==M.n then
    for i=1,M.n do
      T = T+M[i][i]
    end
  end
  return T
end
 
function mat.Map(x,func,der)
  y=mat.matrix(x.m,x.n)
  for i=1,y.m do
    for j=1,y.n do
      y[i][j]=func(x[i][j],der)
    end
  end
  return y
end
 
function mat.NeuralNetwork(topologyVector,activation)
  V=topologyVector
  NN={}
  if V.n==1 then
    NN.depth = V.m-1
    for i=1,V.m-1 do
      NN[i]=mat.RandomiseMatrix(mat.matrix(V[i][1],V[i+1][1]),-1,1)
    end
  end
  if V.m==1 then
    NN.depth = V.n-1
    for i=1,V.n-1 do
      NN[i]=mat.RandomiseMatrix(mat.matrix(V[1][i],V[1][i+1]),-1,1)
    end
  end
  NN.activationname = activation(0,"name")
  function NN:activation(x,der)
    mat.Map(x,activation,der)
  end
  function NN:eval(x)
    evalu = NN:activation(mat.dot(NN[1],x))
    for i=2,NN.depth do
      evalu = NN:activation(mat.dot(NN[i],evalu))
    end
    return evalu
  end
  function NN:Print()
    for i=1,NN.depth do
      print("\nlayer "..i..":")
      mat.PrintMatrix(NN[i])
    end
    print("\nactivation:\n"..NN.activationname)
  end
  return NN
end

-- function mat.TrainNNEvolutionary(NN,inputs,targets,gens,genSize,genBest,mutation)
--   mutation=mutation+0.0001
--   gen = {}
--   scor={}
--   for i=1,genSize do
--     gen[i] = NN
--     for i=1,gens[i].depth do
--       gen[i][j]=mat.add(gen[i][j],mat.RandomiseMatrix(mat.matrix(NN[j].m,NN[j].m),-mutation,mutation))
--       scor[i]=mat.sqsum(gen[i].eval(inputs),targets)
--     end
--   end
--   for epochs=1,gens do
--     k=0
--     c=0
--     for i=1,genSize do
--       if scor[i]>k then
--         k=scor[i]
--       end
--     end
--     for i=1,genSize do
--       if scor[i]>k then
--         k=scor[i]
--       end
--     end
--     best={}
--     for i=1,genSize do
--       if scor[i]>(1-genBest)*k then
--         best[c]=gen[i]
--         c=c+1
--       end
--     end
--     gen=best
--     for i=1,(genSize-c) do
--       gen[c+i]=gen[i]
--       for j=1,(genSize-c) do
--       gen[c+i][j]=mat.add(gen[c+i][j],mat.RandomiseMatrix(mat.matrix(NN[j].m,NN[j].m),-mutation,mutation))
--       end
--     end

--   end
--   k=0
--   c=0
--   for i=1,(genSize) do 
--     scor[i]=mat.sqsum(gen[i].eval(inputs),targets)
--     if scor[i]>k then
--       c=i
--     end
--   end
--   return gen[c]
-- end 

--return mat
--This line was to make it a mosule but it doesn't seem to work for some reason. Now it's used as an explicitly defined "header"
--lines commented out are works in progress. They are currently very buggy or failed all the testing.
--Feel free to submit pull requests to fix or otherwise you can wait for me to get back to them.
--I maintain this library in my spare time so it may be a while.

------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
 
mat.PrintMatrix(mat.RandomiseMatrix(mat.matrix(2,2),0,1))
print("\n")
mat.PrintMatrix(mat.Map(mat.matrix(2,2),mat.sigmoid))
 
 
topology = mat.matrix(1,5)
for i=1,5 do
 topology[1][i] = 2
end
 
mat.PrintMatrix(topology)
 
nn=mat.NeuralNetwork(topology,mat.sigmoid)
nn.Print()
print("===============================================\n")
-- inputVector = mat.matrix(2,1)
-- inputVector[1][1]=1
-- inputVector[2][1]=0
-- mat.PrintMatrix(nn.eval(inputVector))
