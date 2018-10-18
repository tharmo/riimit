       { v=$1; 
          while (getline f< "klk.freqs") {
            if (index(f, v " ")==1) {
           
             print f > "klklemma.freqs"
             break
            }
            if (f > v) break
            
          }
       }
