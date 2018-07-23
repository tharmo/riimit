 BEGIN {FS=" "}
       {
         if ($1!=plk) { print  $3;did=1 }  
         else {           if (did<15) {
             if ($2!=pav) {
               print $3 
               did=did+1
             }
           }     
         }  
       
         plk=$1
         pav=$2
       } 
