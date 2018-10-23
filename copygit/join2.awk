         BEGIN { for (i=1;i<5;i++) { getline <"klk_lemmas2.iso";print;print "---------------"}}
         
          {  
         #if (NR<46582770) next;   
         #if (NR>46619780) exit
         #if ($1==v1) { n=n+$3;  next}
         v1=$1;
         v2=$2;v3=$3;v4=$4
         #if (lemma=="vain")     print "VAIN:" $0 "?p;" p1 " v:" v1 >"er";
         #if ($1=="vain") print "+" $0, "//" lemma  "\\" p1 > "er"
         n=$4;kot=$3
         #if (NR>11111) exit
         if (p1!=$1 && v1!=nextsana)  ##nexts siltä varalta että luetiin jo ohi
         while (getline <"klk_lemmas2.iso") {
             lemma= $2;sana=$1;nextsana=$1
             #print "lemma:" $0 "@" v1 ">" p1> "er"
             p1=v1
             
            if (sana>=v1) break else print NR ," ", v1, v2, v3, v,4, ":::", lemma >"er"
            }
           #if (NR>1000) exit
         if (lemma!="*")
           print lemma,v2,kot,n> "lemmapareja.iso"
           #if (lemma=="ainoastaan")       print "++++" lemma,v2,kot,n
         p1=v1  
         #if (v1=="vain") print "vainko: p=" p1 "/v=" v1 "/lemma:" lemma >"er"
         #if (lemma=="vain") print "vain)): p=" p1 "/v=" v1 "/lemma:" lemma >"er"
        }
