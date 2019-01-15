
        BEGIN { FS="/"; OFS=""}
        { #if (NR>100000) exit
        if (index($2,"*")==1) next
          res=""
         
          for (i=2;i<=NF;i++) {
           if (index($i,"#")>0) { i=i+1;continue} #skiupppaa yhdyssanat
           $i=gensub(/ Foc_.*$/,"","g",$i)  
           print "/" $i "/"
           $i=gensub(/\$/,"","g",$i)  
           #$i=gensub(/^[ \t]+|[ \t]+$/,"","g",$i)  #TRIM
           $i=gensub(/ /,",",1,$i)  #lemman ja muodon erottava välilyönti pilkuksi
           $i=gensub(/ /,"_","g",$i)  # muut välilyönnit ja dollarit_
           res=res "," $i "_"
          } 
          if (res!="")     print substr($1,2),res
           else print "***" $0
        }
       
