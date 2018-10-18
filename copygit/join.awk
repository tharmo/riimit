### reading  klk_lemmas.iso
 BEGIN { for (i=1;i<5;i++) { getline <"klk_lemmas2.iso";print;print "---------------"}}
         #BEGIN { for (i=1;i<2;i++) { getline <"klk_w2.iso";print;print "---------------"}}
        {  
         #if ($1==v1) { n=n+$3;  next}
         #print
         v2=$2;v3=$3;v4=$4
         n=$3
         #if (NR>11111) exit
         if (v1!=$1)
         {
         v1=$1;
         getline <"klk_lemmas2.iso"; 
           #kk=kk+1;        if (kk>9999) exit
           if (v1!=$1)           print "<li>**************", NR ,$0 "///<b>" v1,"</b>" v2
           lemma= $2;sana=$1
          } 
           #if (NR>1000) exit
          
        if (lemma!="*")
           print lemma,v2,n> "lemmapareja.iso"
           }
